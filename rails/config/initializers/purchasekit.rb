# Demo mode enables local development without a PurchaseKit account.
# Products are defined locally and purchases complete without API calls.
#
# For production, disable demo mode and configure your API credentials:
#
#   PurchaseKit::Pay.configure do |config|
#     config.api_url = "https://purchasekit.dev"
#     config.api_key = Rails.application.credentials.purchasekit[:api_key]
#     config.app_id = Rails.application.credentials.purchasekit[:app_id]
#   end
#
PurchaseKit::Pay.configure do |config|
  config.demo_mode = true
  config.demo_products = {
    "annual" => {apple_product_id: "dev.purchasekit.pro.annual"},
    "monthly" => {apple_product_id: "dev.purchasekit.pro.monthly"}
  }
end
