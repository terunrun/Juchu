require "csv"

class ProductsController < ApplicationController
  before_action :redirect_to_login, only: [ :index ]
  before_action :redirect_to_login_customer, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    respond_to do |format|
      format.html do
        if !params[:search_name].blank? && !params[:search_date].blank?
          session[:product_search_name] = params[:search_name]
          session[:product_search_date] = params[:search_date]
          @products = Product.where("name LIKE ?", "%#{params[:search_name]}%").where(created_at: params[:search_date].in_time_zone.all_day)
        elsif !params[:search_name].blank?
          session[:product_search_name] = params[:search_name]
          @products = Product.where("name LIKE ?", "%#{params[:search_name]}%")
        elsif !params[:search_date].blank?
          session[:product_search_date] = params[:search_date]
          @products = Product.where(created_at: params[:search_date].in_time_zone.all_day)
        else
          session[:product_search_name] = "nil"
          session[:product_search_date] = "nil"
          @products = Product.all
        end
      end
      format.csv do
        if !session[:product_search_key].blank?
          @products = Product.where("name LIKE ?", "%#{session[:product_search_key]}%")
        else
          @products = Product.all
        end
        send_data render_to_string, filename: "products.csv", type: :csv
#        products_csv
      end
    end
  end

  def show
    @product = Product.find(params[:id])
    if @product.customer_id != session[:customer_id]
      redirect_to root_path, info: "不正なアクセスです"
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new( product_params )
    @product.customer_id = current_customer.id
    if @product.save
      redirect_to product_path(@product.id), success: "商品を発注しました"
    else
      render :new, danger: "商品の発注に失敗しました"
    end
  end

  def edit
    @product = Product.find( params[:id] )
  end

  def update
    product = Product.find( params[:id] )
    if product.created_at.since(1.days) < Time.now
      flash[:danger] = "発注から24時間以上が経過しているため変更できません"
      redirect_to product_path(product.id)
    else
      if product.update_attributes( product_params )
        flash[:success] = "発注情報を変更しました"
        redirect_to product_path(product.id)
      else
        flash.now[:danger] = "発注情報の変更に失敗しました"
        redirect_to product_path(product.id)
      end
    end
  end

  def destroy
    product = Product.find( params[:id] )
    if product.created_at.since(1.days) < Time.now
      flash[:danger] = "発注から24時間以上が経過しているため削除できません"
      redirect_to product_path(product.id)
    else
      product.delete
      redirect_to customer_path(current_customer)
    end
  end


  private

    def product_params
      params.require(:product).permit( :name, :number, :description )
    end

    def products_csv
      csv_date = CSV.generate do |csv|
#        csv_column_names = ["製品名","製品説明","価格"]
        csv_column_names = ["商品名","受注数","説明","発注者","受注日"]
        csv << csv_column_names
        @products.each do |product|
          csv_column_values = [
            product.name,
            product.number,
            product.description,
            Customer.find(product.customer_id).name,
            product.created_at,
          ]
          csv << csv_column_values
        end
      end
      send_data(csv_date,filename: "product3.csv")
    end

end
