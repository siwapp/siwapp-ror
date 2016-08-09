class SiwappHooks
  def invoice_generation(inv)
    unless Settings.event_invoice_generation_url.blank?
      datetime = DateTime.now.strftime '%Y-%m-%d %H:%M'
      begin
        Rails.logger.tagged("WEBHOOK", "DEBUG") { Rails.logger.debug "#{datetime} -- A punto de enviar el post. vete tu a saber donde se logea esto"}
        Rails.logger.tagged("WEBHOOK", "ERROR") { Rails.logger.error "#{datetime} -- Generando un error falso"}
        response = HTTP.post(
                   Settings.event_invoice_generation_url,
                   :json => JSON.parse(inv.to_jbuilder.target!)
                   )
        # response.code ha de ser 200
      rescue ActiveRecord::RecordNotFound
        Rails.logger.error "Invoice not found"
        # do nothing
      rescue HTTP::Error
        Rails.logger.error "Some kind of weird error while sending info"
        # TODO: some logging mechanism
      end
    end
  end
end


Wisper.subscribe(SiwappHooks.new, async: true)
