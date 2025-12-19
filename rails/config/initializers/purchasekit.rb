PurchaseKit::Pay.configure do |config|
  config.api_url = Rails.application.credentials.purchasekit[:api_url]
  config.api_key = Rails.application.credentials.purchasekit[:api_key]
  config.app_id = Rails.application.credentials.purchasekit[:app_id]
  config.webhook_secret = Rails.application.credentials.purchasekit[:webhook_secret]
end
