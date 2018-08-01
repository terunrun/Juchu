class UsersController < ApplicationController
  before_action :redirect_to_login, only: [:edit, :show, :upadte, :destroy, :index]

  def new
    @user = User.new
  end

  def create
    @user = User.new( user_params )
    if @user.save
      flash.now[:success] = "ユーザーを登録しました"
      #redirect_to root_path, success: "ユーザーを登録しました"
      redirect_to login_path
    else
      flash.now[:danger] = "ユーザーの登録に失敗しました"
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
  end

  def index
    @users = User.all
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
