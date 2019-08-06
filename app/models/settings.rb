# RailsSettings Model
class Settings < RailsSettings::Base
  source Rails.root.join("config/app.yml")
end
