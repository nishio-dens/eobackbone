class Api::OrdersController < ApiController
  def index
    @orders = Order
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .accessible_orders(current_character.corporation_id, current_user.id)
      .order(id: :desc)
  end

  def show
    @order = Order.preload(:order_details).find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    # TODO: POSTされたステータスをそのままいれてはいけない
    @order.processing_status = params[:status]
    if @order.save
      render json: { }
    else
      render json: { error: "something wrong" }
    end
  end
end
