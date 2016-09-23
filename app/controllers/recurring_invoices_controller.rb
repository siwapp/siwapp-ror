require 'csv'

class RecurringInvoicesController < CommonsController

  def generate
    # Generates pending invoices up to today
    RecurringInvoice.generate_pending_invoices
    redirect_to invoices_url
  end

  # DELETE
  # bulk deletes selected elements on list
  def remove
    ids = params["#{model.name.underscore}_ids"]
    if ids.is_a?(Array) && ids.length > 0
      model.where(id: params["#{model.name.underscore}_ids"]).destroy_all
      flash[:info] = "Successfully deleted #{ids.length} #{type_label}"
    end
    redirect_to sti_path(@type)
  end

  # GET /recurring_invoices/chart_data.json
  # Returns a json with dates as keys and sums of the invoices
  # as values
  def chart_data
    # date_from = (params[:q].nil? or params[:q][:issue_date_gteq].empty?) ? 30.days.ago.to_date : Date.parse(params[:q][:issue_date_gteq])
    # date_to = (params[:q].nil? or params[:q][:issue_date_lteq].empty?) ? Date.current : Date.parse(params[:q][:issue_date_lteq])

    # scope = @search.result(distinct: true)
    # scope = scope.tagged_with(params[:tags].split(/\s*,\s*/)) if params[:tags].present?
    # scope = scope.select('issue_date, sum(gross_amount) as total').where(active: true).group('issue_date')

    # build all keys with 0 values for all
    @date_totals = {}

    # (date_from..date_to).each do |day|
    #   @date_totals[day.to_formatted_s(:db)] = 0
    # end

    # scope.each do |inv|
    #   @date_totals[inv.issue_date.to_formatted_s(:db)] = inv.total
    # end

    render
  end

  def get_csv(invoices=RecurringInvoice.all)
    csv_string = CSV.generate do |csv|
      csv << ["id", "series", "customer_id", "name", "identification", "email",
          "invoicing_address", "shipping_address", "contact_person", "terms",
          "notes", "base_amount", "discount_amount", "net_amount",
          "gross_amount", "tax_amount", "draft",
          "sent_by_email", "days_to_due", "enabled", "max_occurrences",
          "must_occurrences", "period", "period_type",
          "starting_date", "finishing_date", "created_at", "updated_at",
          "template_id", "meta_attributes"]
      invoices.each do |i|
        csv << [i.id, i.series, i.customer_id, i.name, i.identification, i.email,
            i.invoicing_address, i.shipping_address, i.contact_person, i.terms,
            i.notes, i.base_amount, i.discount_amount, i.net_amount,
            i.gross_amount, i.tax_amount, i.draft,
            i.sent_by_email, i.days_to_due, i.enabled, i.max_occurrences,
            i.must_occurrences, i.period, i.period_type,
            i.starting_date, i.finishing_date, i.created_at, i.updated_at,
            i.template_id, i.meta_attributes]
      end
    end
  end


  protected

  def configure_search
    super
    @search_filters = true
  end

  def set_listing(instances)
    @recurring_invoices = instances
  end

  def set_instance(instance)
    @recurring_invoice = instance
  end

  def get_instance
    @recurring_invoice
  end

  def recurring_invoice_params
    [
      :series_id,

      :customer_id,
      :identification,
      :name,
      :email,
      :contact_person,
      :invoicing_address,
      :shipping_address,
      :terms,
      :notes,

      :enabled,
      :days_to_due,
      :draft,
      :starting_date,
      :finishing_date,
      :period,
      :period_type,
      :max_occurrences,
      :sent_by_email,

      :tag_list,

      items_attributes: [
        :id,
        :description,
        :quantity,
        :unitary_cost,
        :discount,
        {:tax_ids => []},
        :_destroy
      ]
    ]
  end

end
