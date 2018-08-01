class CustomersController < ApplicationController
  before_action :redirect_to_login_customer, only: [:show, :edit, :update]
  before_action :redirect_to_root, only: :index
  before_action :redirect_to_login, only: :index

  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new( customer_params )
    if @customer.save
      redirect_to login_path, success: "発注者ユーザーを登録しました"
    else
      flash.now[:danger] = "発注者ユーザーの登録に失敗しました"
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def show
    @customer = Customer.find(params[:id])
    @products = @customer.products
  end

  def destroy
  end


  private

    def customer_params
      params.require(:customer).permit(:name, :email, :password, :password_confirmation)
    end

end
