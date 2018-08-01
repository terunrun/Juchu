class ApplicationController < ActionController::Base
  # CSRF対策　記述の意味を調べる☆
  protect_from_forgery with: :exception

  # flashメッセージの対タイプを定義
  add_flash_types :success, :info, :warning, :danger

  # helperモジュールを読み込み
  include SessionsHelper

  # ログイン画面へ遷移させる
  def redirect_to_login
    unless logged_in?
      flash[:info] = "ログインしてください"
      redirect_to login_path
    end
  end

  # ログイン画面へ遷移させる
  def redirect_to_login_customer
    unless logged_in_customer?
      flash[:info] = "ログインしてください"
      redirect_to login_customer_path
    end
  end

  def redirect_to_root
    unless current_customer.nil?
      flash[:info] = "この機能はご利用になれません"
      redirect_to root_path
    end
  end

end
