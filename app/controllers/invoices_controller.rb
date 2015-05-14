class InvoicesController < CommonsController

  def show
    # Redirect to edit if invoice not closed
    if @invoice.status != Invoice::CLOSED
      redirect_to action: 'edit'
    else
      # Show the template in an iframe
      render 'iframe_template'
    end
  end

  # Renders an invoice template
  def template
    @invoice = Invoice.find(params[:id])
    render inline: "hey there <%= @invoice %>"
  end

  protected

  def set_listing(instances)
    @invoices = instances
  end

  def set_instance(instance)
    @invoice = instance
  end

  def get_instance
    @invoice
  end

  def type_params
    params.require(:invoice).permit(
      :serie_id,
      :due_date,

      :customer_name,
      :customer_email,

      :invoicing_address,
      :draft,

      :tag_list,

      items_attributes: [
        :id,
        :description,
        :quantity,
        :unitary_cost,
        :discount,
        {:tax_ids => []},
        :_destroy
      ],

      payments_attributes: [
        :id,
        :date,
        :amount,
        :notes,
        :_destroy
      ]
    )
  end
end
