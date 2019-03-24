class ItemsController < ApplicationController
  before_action :redirect_to_login, only: [:new, :create, :show, :edit, :update, :destroy]

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(items_params)
    if @item.save
      redirect_to item_path(@item.id), success: "商品を登録しました"
    else
      render :new, danger: "商品の登録に失敗しました"
    end
  end

  def index
    if !params[:search_name].blank? && !params[:search_date].blank?
      session[:item_search_name] = params[:search_name]
      session[:item_search_date] = params[:search_date]
      @items = Item.where("name LIKE ?", "%#{params[:search_name]}%").where(created_at: params[:search_date].in_time_zone.all_day)
    elsif !params[:search_name].blank?
      session[:item_search_name] = params[:search_name]
      @items = Item.where("name LIKE ?", "%#{params[:search_name]}%")
    elsif !params[:search_date].blank?
      session[:item_search_date] = params[:search_date]
      @items = Item.where(created_at: params[:search_date].in_time_zone.all_day)
    else
      session[:item_search_name] = "nil"
      session[:item_search_date] = "nil"
      @items = Item.all
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
  end

  def upload
  end

  def destroy
  end


  private

    def items_params
      params.require(:item).permit( :name, :description, :picture )
    end

end
