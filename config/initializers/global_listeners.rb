class SiwappHooks
  def invoice_generation(invoice)
    sleep 5
    print "here it comes\n"
    unless Settings.invoice_generation_url.blank?
      HTTP.post(Settings.invoice_generation, :json => JSON.parse(invoice.to_jbuilder.target!))
    end
  end
end


Wisper.subscribe(SiwappHooks.new, async: true)
