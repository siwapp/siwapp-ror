class SiwappHooks
  def invoice_generation(inv)
    unless Settings.event_invoice_generation_url.blank?
      begin
        res = post(
                   Settings.event_invoice_generation_url,
                   :json => JSON.parse(inv.to_jbuilder.target!)
                   )
      rescue ActiveRecord::RecordNotFound
        # do nothing
      rescue HTTP::Error
        # TODO: some logging mechanism
      end
    end
  end
end


Wisper.subscribe(SiwappHooks.new, async: true)
