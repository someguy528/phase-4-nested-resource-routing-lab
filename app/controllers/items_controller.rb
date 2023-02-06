class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :rescue_record_not_found

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items.all
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  def create
    user = User.find(params[:user_id])
    item = user.items.create(item_params)
    render json: item , include: :user, status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def rescue_record_not_found(invalid)
  #   if !User.find_by(id: params[:user_id]) 
  #     error = "user not found"
  #   elsif !Item.find_by(id: params[:id])
  #     error = "item not found"
  #   end
  #   render json: {errors: error}, status: :not_found
    render json: {errors: invalid}, status: :not_found
  end

end
