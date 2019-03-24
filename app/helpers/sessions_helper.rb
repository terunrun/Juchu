module SessionsHelper
  # 現在ログインしているユーザーを返す
  def current_user
    if !session[:user_id].nil?
      @current_user ||= User.find(session[:user_id])
    end
  end

  # ログイン状態かどうかを判定（current_userがnilでなければtrueを返す）
  def logged_in?
    !current_user.nil?
  end

  # 現在ログインしている受注者ユーザーを返す
  def current_customer
    if !session[:customer_id].nil?
      @current_customer ||= Customer.find(session[:customer_id])
    # 永続セッションに対応するため追加
    # cookieに署名付き顧客idが存在するか
  elsif !cookies.signed[:customer_id].nil?
      # cookieの署名付き顧客idで顧客を検索
      customer = Customer.find(cookies.signed[:customer_id])
      # 顧客が存在し、cookieのトークンがデータベースと一致するか
      if customer && customer.authenticated?(:remember, cookies[:remember_token])
        log_in_customer customer
        @current_customer = customer
      end
    end
  end

  # 受注者がログイン状態かどうかを判定（current_userがnilでなければtrueを返す）
  def logged_in_customer?
    !current_customer.nil?
    # if !session[:logged_in_time].nil?
    #   binding.pry
    #   if session[:logged_in_time] < (Time.now - 60).to_s
    #     logout_customer
    #   end
    # end
  end

  # ユーザーのセッションを永続的にする
  def remember(customer)
    customer.remember
    # cookieに署名付きid（ブラウザに保存する前に暗号化される）を有効期限20年で保存
    cookies.permanent.signed[:customer_id] = customer.id
    # cookieにremember_tokenを有効期限20年で保存
    cookies.permanent[:remember_token] = customer.remember_token
  end

  private

    def log_in(user)
      session[:user_id] = user.id
    end

    # セッションのユーザーIDを削除し、現在ログインしているユーザーを空にする
    def logout
      session.delete(:user_id)
      @current_user = nil
    end

    def log_in_customer(customer)
      session[:customer_id] = customer.id
      # session[:logged_in_time] = Time.now
    end

    # セッションのユーザーIDを削除し、現在ログインしているユーザーを空にする
    def logout_customer
      forget(current_customer)
      session.delete(:customer_id)
      session.delete(:logged_in_time)
      @current_customer = nil
    end

    # 永続的セッションを破棄する
    def forget(customer)
      customer.forget
      cookies.delete(:customer_id)
      cookies.delete(:remember_token)
    end

    #
    def login_failed_count(customer)
      customer.increment_login_failed_number(customer.login_failed_number + 1)
      if customer.login_failed_number == 2
        customer.lock_account
      end
    end

end
