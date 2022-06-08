class ItemsController < ApplicationController
  layout false
  #skip_after_action :verify_authenticity_token
  before_action :find_item, only: %i[show edit update destroy]
  before_action :admin?,  only: %i[edit update new create destroy]
  def index
    @items = Item.all
    #render body: @items.map  {|i| "#{i.name}: #{i.price}"}
  end
  def create
    item = Item.create(items_params)
    if item.persisted?
      render json: item.name, status: create
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def new; end
  def show
    render body: 'Page not found', status: 404 unless @item
  end

  def edit
    render body: 'Page not found', status: 404 unless @item
  end

  def update
    if item.update(items_params)
      redirect_to item_path
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end
  def destroy
    if @item.destroy.destroyed?
      redirect_to "/items"
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end


  private
  def items_params
    params.permit(:name, :price)
  end

  def find_item
    @item = Item.where(id: params[:id]).first
  end

  def admin?
    render json: "Access denied", status: :forbidden unless params[:admin]
  end
end
