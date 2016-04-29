class ItemsController < ApplicationController

	# GET /items/amount
  #
  # Calculates the total amount for an item
  def amount
    currency = get_currency
    precision = currency.exponent.to_int
    @amount = ((params[:unitary_cost].to_f * params[:quantity].to_f * 10**precision).floor).to_f / 10**precision
    
    respond_to do |format|
      format.json
    end
  end
end