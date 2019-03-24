class Customer < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 244 }, uniqueness: true,
                   format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, length: { minimum: 6 }

  has_many :products, dependent: :destroy

  # 他属性の精査を回避するために設定
  attr_accessor :remember_token, :activation_token, :release_account_lock_token

  # オブジェクトがcreateされる前に実行されるメソッド（アクティベート用）
  before_create :create_activation_digest

  # 次回からのログイン情報入力を省略するためのメソッド ここから
  # ハッシュ値を生成するクラスメソッド
  def Customer.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返すクラスメソッド
  def Customer.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    # トークンを新規作成して仮想のremember_token属性に格納
    self.remember_token = Customer.new_token
    # 新規作成したトークンをハッシュ化してデータベースに保存
    update_attribute(:remember_digest, Customer.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  # ダイジェストがnilの場合はfalseを返す（複数ブラウザでログインしている状態への対応）
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  # 次回からのログイン情報入力を省略するためのメソッド ここまで

  # remember_digestカラムを空にする（永続セッションの破棄）
  def forget
    update_attribute(:remember_digest, nil)
  end

  # ログイン失敗回数をカウントアップする
  def increment_login_failed_number(count)
    update_attribute(:login_failed_number, count)
  end

  # アカウントをロックする
  def lock_account
    update_attribute(:unavailable_flg, true)
  end

  # アカウントロックを解除する
  def unlock_account
    update_attribute(:login_failed_number, 0)
    update_attribute(:unavailable_flg, false)
  end

  # アクティベート用トークンとそのDB保存用ハッシュを生成する
  def create_activation_digest
    self.activation_token = Customer.new_token
    self.activation_digest = Customer.digest(activation_token)
  end

  # アクティベート状態にする
  def account_activation
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.now)
  end

  # アカウントロック解除用トークンとそのDB保存用ハッシュを生成する
  def create_release_account_lock_digest
    self.release_account_lock_token = Customer.new_token
    self.update_attribute(:release_account_lock_digest, Customer.digest(release_account_lock_token))
  end


end
