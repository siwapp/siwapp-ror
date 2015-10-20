class InvoicesController < CommonsController

  # Gets the template to display invoices
  def get_template
    if template = Template.first  # TODO: this should change
      @template_url = "/invoices/template/#{template.id}/invoice/#{@invoice.id}"
    else
      @template_url = ""
    end
  end

  def show
    # Redirect to edit if invoice not closed
    if @invoice.status != Invoice::PAID or not get_template
      redirect_to action: 'edit'
    else
      # Show the template in an iframe
      render
    end
  end

  def edit
    get_template
    render
  end

  # Renders an invoice template in html and pdf formats
  def template
    @invoice = Invoice.find(params[:invoice_id])
    @template = Template.find(params[:id])
    html = render_to_string :inline => @template.template,
      :locals => {:invoice => @invoice}
    respond_to do |format|
      format.html { render inline: html }
      format.pdf do
        pdf = WickedPdf.new.pdf_from_string(html)
        send_data(pdf,
          :filename    => "#{@invoice}.pdf",
          :disposition => 'attachment')
      end
    end
  end

  # GET /invoices/autocomplete.json
  # View to get the item autocomplete feature.
  def autocomplete
    @items = Item.order(:description).where("description LIKE ?", "%#{params[:term]}%")
    respond_to do |format|
      format.json {
        render json: @items.map {|item|
          {
            'label': item.description, 
            'value': item.description,
            'id': item.id,
            'unitary_cost': item.unitary_cost
          }
        }
      }
    end
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

  def invoice_params
    [
      :series_id,
      :issue_date,
      :due_date,
      :days_to_due,

      :customer_id,
      :identification,
      :name,
      :email,
      :contact_person,
      :invoicing_address,
      :shipping_address,

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
    ]
  end
end
