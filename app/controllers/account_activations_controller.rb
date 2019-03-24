class AccountActivationsController < ApplicationController
  def edit
    customer = Customer.find_by(email: params[:email])
    if customer && !customer.activated? && customer.authenticated?(:activation, params[:id])
      customer.account_activation
      log_in_customer customer
      redirect_to customer_path(customer.id), success: "アクティベートが完了しました"
    else
      redirect_to root_path, danger: "不正なアクセスです"
    end
  end
end
