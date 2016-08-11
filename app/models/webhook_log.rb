class WebhookLog < ActiveRecord::Base
  def to_s
    "#{created_at} -- #{message}"
  end
end
