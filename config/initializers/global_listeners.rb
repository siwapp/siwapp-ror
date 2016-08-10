class SiwappHooks
  def invoice_generation(inv)
    unless Settings.event_invoice_generation_url.blank?
      datetime = DateTime.now.strftime '%Y-%m-%d %H:%M'
      begin
        response = HTTP.post(
                   Settings.event_invoice_generation_url,
                   :json => JSON.parse(inv.to_jbuilder.target!)
                   )
        if response.code / 100 == 2
          Rails.logger.tagged("WEBHOOK", "INFO") { Rails.logger.info "Invoice #{inv} successfully posted" }
        else
          Rails.logger.tagged("WEBHOOK", "ERROR") { Rails.logger.error "Invoice #{inv} couldn't be posted. Error #{response.code}" }
        end
      rescue ActiveRecord::RecordNotFound
        Rails.logger.tagged("WEBHOOK", "ERROR") { Rails.logger.error "Invoice #{inv} not found" }
      rescue HTTP::Error => error
        Rails.logger.tagged("WEBHOOK", "ERROR") { Rails.error "Error posting #{inv}: #{error}" }
      end
    end
  end
end


Wisper.subscribe(SiwappHooks.new, async: true)
