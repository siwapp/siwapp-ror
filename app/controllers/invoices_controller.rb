class InvoicesController < CommonsController

  # Gets the template to display invoices
  def get_template

    if template = Template.first  # TODO: this should change to get the default
      @template_url = "/invoices/template/#{template.id}/invoice/#{@invoice.id}"
    else
      @template_url = ""
    end
  end

  def show
    # Redirect to edit if invoice not closed
    if @invoice.status != Invoice::PAID or not get_template
      redirect_to action: :edit
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
      :locals => {:invoice => @invoice, :settings => Settings}
    respond_to do |format|
      format.html { render inline: html }
      format.pdf do
        pdf = WickedPdf.new.pdf_from_string(html,
            margin: {:top => 0, :bottom => 0, :left => 0, :right => 0})
        send_data(pdf,
          :filename    => "#{@invoice}.pdf",
          :disposition => 'attachment'
        )
      end
    end
  end

  # GET /invoices/autocomplete.json
  # View to get the item autocomplete feature.
  def autocomplete
    @items = Item.unique_description("%#{params[:term]}%")
    respond_to do |format|
      format.json {
        render json: @items.map {|item|
          {
            'label': "#{item.description} #{item.unitary_cost}",
            'value': item.description,
            'id': item.id,
            'unitary_cost': item.unitary_cost
          }
        }
      }
    end
  end

  # GET /invoices/sums.json
  # Returns a json with dates as keys and sums of the invoices
  # as values
  def sums
    # setting params: from, to
    from = params[:from] ? Date.parse(params[:from]) : 15.days.ago.to_date
    to = params[:to] ? Date.parse(params[:to]) : Date.today
    # build all keys with 0 values for all
    @date_totals = {}
    (from..to).each do |day|
      @date_totals[day.to_formatted_s(:short)] = 0
    end
    # now overwrite with data from invoices
    sql_date_totals = Invoice.select('issue_date, sum(gross_amount) as total')\
        .where(issue_date: from..to).where(draft: false).group('issue_date')
    sql_date_totals.each do |inv|
      @date_totals[inv.issue_date.to_formatted_s(:short)] = inv.total
    end

    render
  end

  def send_email
    @invoice = Invoice.find(params[:id])
    @invoice.send_email
    redirect_to :back, notice: "Email successfully sent."
  end

  protected

  def configure_search
    super
    @search_filters = true
  end

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
