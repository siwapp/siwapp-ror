class SiwappHooks
  def invoice_generation(inv)
    unless Settings.invoice_generation_url.blank?
      begin
        HTTP.post(Settings.invoice_generation_url, :json => JSON.parse(invoice.to_jbuilder.target!))
      rescue ActiveRecord::RecordNotFound
        # do nothing
      end
    end
  end
end


Wisper.subscribe(SiwappHooks.new, async: true)
