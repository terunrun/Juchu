class SessionsController < ApplicationController

  def new
  end

  def create
    if params[:session][:authorization_code] == Juchu::Application.config.authorization_code
      user = User.find_by( email: params[:session][:email])
      if user && user.authenticate(params[:session][:password])
        log_in user
        flash.now[:success] = "ログインしました"
        redirect_to user_path(user.id)
      else
        flash.now[:danger] = "ログインに失敗しました"
        render :new
      end
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    logout
    flash.now[:info] = "ログアウトしました"
    redirect_to root_path
  end

  def new_customer
  end

  # def create_customer
  #   customer = Customer.find_by( email: params[:session][:email])
  #   if customer && customer.authenticate(params[:session][:password])
  #     log_in_customer customer
  #     # POSTパラメータにremember_meがある場合はremerber_digestに保存
  #     params[:session][:remember_me] == "1" ? remember(customer) :forget(customer)
  #     redirect_to customer_path(customer.id), success: "ログインしました"
  #   else
  #     flash.now[:danger] = "ログインに失敗しました"
  #     render :new_customer
  #   end
  # end

  def create_customer
    customer = Customer.find_by( email: params[:session][:email] )
    if customer
      if !customer.unavailable_flg
        if customer.authenticate(params[:session][:password])
          if customer.activated?
            customer.unlock_account
            log_in_customer customer
            # POSTパラメータにremember_meがある場合はremerber_digestに保存
            params[:session][:remember_me] == "1" ? remember(customer) :forget(customer)
            redirect_to customer_path(customer.id), success: "ログインしました"
          else
            redirect_to root_path, danger: "アカウントをアクティベートしてください"
          end
        else
          login_failed_count(customer)
          flash.now[:danger] = "ログインに失敗しました"
          render :new_customer
        end
      else
        flash.now[:danger] = "アカウントがロックされています"
        render :new_customer
      end
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new_customer
    end
  end

  def destroy_customer
    # ログイン状態のときのみログアウトを実施（複数タブでログインしている状態への対応）
    logout_customer if logged_in_customer?
    flash.now[:info] = "ログアウトしました"
    redirect_to root_path
  end

  # private
  #
  #   def log_in(user)
  #     session[:user_id] = user.id
  #   end
  #
  #   # セッションのユーザーIDを削除し、現在ログインしているユーザーを空にする
  #   def logout
  #     session.delete(:user_id)
  #     @current_user = nil
  #   end
  #
  #   def log_in_customer(customer)
  #     session[:customer_id] = customer.id
  #   end
  #
  #   # セッションのユーザーIDを削除し、現在ログインしているユーザーを空にする
  #   def logout_customer
  #     forget(current_customer)
  #     session.delete(:customer_id)
  #     @current_customer = nil
  #   end
  #
  #   # 永続的セッションを破棄する
  #   def forget(customer)
  #     customer.forget
  #     cookies.delete(:customer_id)
  #     cookies.delete(:remember_token)
  #   end

end
