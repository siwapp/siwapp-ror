class ItemsController < ApplicationController

	# GET /items/amount
  #
  # Calculates the net amount for an item
  def amount
    item = Item.new(
      unitary_cost: params[:unitary_cost],
      quantity: params[:quantity],
      discount: params[:discount]
    )
    @amount = item.net_amount

    respond_to do |format|
      format.json
    end
  end
end
