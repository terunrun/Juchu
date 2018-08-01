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
    end
  end

  # 受注者がログイン状態かどうかを判定（current_userがnilでなければtrueを返す）
  def logged_in_customer?
    !current_customer.nil?
  end

end
