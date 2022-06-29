class ItemsController < ApplicationController
  layout false
  #skip_after_action :verify_authenticity_token
  before_action :find_item, only: %i[show edit update destroy upvote]
  before_action :admin?,  only: %i[edit]
  after_action  :show_info, only: %i[index]
  def index
    @items = Item
    @items = Item.where('price > ?', params[:price_from]) if params[:price_from]
    @items = @items.where('created_at >= ?', 1.day.ago) if params[:today]
    @items = @items.where('votes_count >= ?', params[:votes_count]) if params[:votes_count]
    @items = @items.order(:id)
    @items = @items.includes(:image)

  end
  def create
    item = Item.create(items_params)
    if item.persisted?
      flash[:success] = "Item was to database"
      render json: item.name, status: :created
    else
      flash.now[:error] = "Yot fill all fields correctly"
      render :new
      #render json: item.errors, status: :unprocessable_entity
    end
  end

  def new
    @item = Item.new
  end
  # def show
  #   render body: 'Page not found', status: 404 unless @item
  # end
  #
  # def edit
  #   render body: 'Page not found', status: 404 unless @item
  # end

  def update
    if item.update(items_params)
      flash[:success] = "Item was updated"
      redirect_to item_path
    else
      flash.now[:error] = "Yot fill all fields correctly"
      render json: item.errors, status: :unprocessable_entity
    end
  end
  def destroy
    if @item.destroy.destroyed?
      flash[:success] = "Item was deleted"
      render json: {success: true}
      #redirect_to "/items"
    else
      flash[:error] = "Item wasn't deleted"
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def upvote
    @item.increment! :votes_count
    redirect_to items_path
  end

  def expensive
    @items = Item.where("price > 50")
    render :index
  end


  private
  def items_params
    params.require(:item).permit(:name, :price, :description)
  end

  def find_item
    @item = Item.where(id: params[:id]).first
    render_404 unless @item
  end


  def show_info
    puts "Index endpoint"
  end
end
