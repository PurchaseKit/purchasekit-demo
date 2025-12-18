PurchaseKit::Pay.configure do |config|
  config.api_key = Rails.application.credentials.dig(:purchasekit, :api_key) || ENV["PURCHASEKIT_API_KEY"]
  config.webhook_secret = Rails.application.credentials.dig(:purchasekit, :webhook_secret) || ENV["PURCHASEKIT_WEBHOOK_SECRET"]
end
