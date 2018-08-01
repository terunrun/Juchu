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

  def create_customer
    customer = Customer.find_by( email: params[:session][:email])
    if customer && customer.authenticate(params[:session][:password])
      log_in_customer customer
      redirect_to customer_path(customer.id), success: "ログインしました"
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new_customer
    end
  end

  def destroy_customer
    logout_customer
    flash.now[:info] = "ログアウトしました"
    redirect_to root_path
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
    end

    # セッションのユーザーIDを削除し、現在ログインしているユーザーを空にする
    def logout_customer
      session.delete(:customer_id)
      @current_customer = nil
    end

end
