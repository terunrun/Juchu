class ReleaseAccountLocksController < ApplicationController
  def new
    @customer = Customer.new
  end

  def create
    customer = Customer.find_by(email: params[:customer][:email])
    if customer
      customer.create_release_account_lock_digest
      CustomerMailer.release_account_lock(customer).deliver_now
    end
    redirect_to root_path, info: "入力されたメールアドレスにアカウントロック解除用のメールを送信しました。"
  end

  def edit
    customer = Customer.find_by(email: params[:email])
    if customer && customer.authenticated?(:release_account_lock, params[:id])
      customer.unlock_account
      redirect_to login_customer_path, success: "アカウントロックを解除しました。"
    else
      redirect_to root_path, danger: "不正なアクセスです。"
    end
  end
end
