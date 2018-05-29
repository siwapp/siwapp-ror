class SiwappHooks
  def invoice_generation(inv)
    unless Settings.event_invoice_generation_url.blank?
      begin
        invoice_json = InvoiceSerializer.new(inv).to_json
        response = HTTP.post(
                     Settings.event_invoice_generation_url,
                     :json => JSON.parse(invoice_json)
                   )
        if response.code / 100 == 2
          WebhookLog.create level: 'info', message: "Invoice #{inv} successfully posted", event: :invoice_generation
        else
          WebhookLog.create level: 'error', message: "Invoice #{inv} couldn't be posted. Error #{response.code}", event: :invoice_generation
        end
      rescue ActiveRecord::RecordNotFound
        WebhookLog.create level: 'error', message: "Invoice #{inv} not found", event: :invoice_generation
      rescue HTTP::Error => error
        WebhookLog.create level: 'error', message: "Error posting #{inv}: #{error}", event: :invoice_generation
      end
    end
  end
end


Wisper.subscribe(SiwappHooks.new, async: true)
