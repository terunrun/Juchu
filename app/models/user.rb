class User < ApplicationRecord

  # \A：文字列の先頭
  # \w：a-z、A-Z、0-9、_
  # + ：1回以上
  # \-.：-と.
  # \d ：0-9
  # \z ：文字列の末尾
  # /i ：大文字小文字を区別しない
  # \Aと\wで正規表現を適用させる範囲を指定している
  # []で囲むと、その中のいずれかに合致する場合にtrue
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 244 }, uniqueness: true,
                   format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, length: { minimum: 6 }

end
