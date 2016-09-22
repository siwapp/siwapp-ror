class Api::V1::InvoicesController < Api::V1::CommonsController

  include CommonsHelper

  set_pagination_headers :invoices, only: [:index]

  # Renders invoice template in pdf
  # GET /api/v1/invoices/template/:id/invoice/:invoice_id
  def template
    @invoice = Invoice.find(params[:invoice_id])
    @template = Template.find(params[:id])
    html = render_to_string :inline => @template.template,
      :locals => {invoice: @invoice, settings: Settings}
    respond_to do |format|
      format.pdf do
        pdf = @invoice.pdf(html)
        send_data(pdf, :filename => "#{@invoice}.pdf", :disposition => 'attachment')
      end
    end
  end



  protected

  def set_instance instance
    @invoice = instance
  end

  def get_instance
    @invoice
  end

  def set_listing instances
    @invoices = instances
  end

  def invoice_params
    [
      :number,
      :series_id,
      :issue_date,
      :due_date,
      :days_to_due,
      :invoice_number,

      :customer_id,
      :identification,
      :name,
      :email,
      :contact_person,
      :invoicing_address,
      :shipping_address,
      :terms,
      :notes,

      :draft,

      :tag_list,

      :meta_attributes,

      :items_attributes => [
        :id,
        :description,
        :quantity,
        :unitary_cost,
        :discount,
        :tax_ids => []
      ],

      :payments_attributes => [
        :id,
        :date,
        :amount,
        :notes
      ],

    ]
  end


end
