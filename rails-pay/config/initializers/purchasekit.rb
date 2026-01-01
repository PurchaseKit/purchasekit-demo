# Demo mode enables local development without a PurchaseKit account.
# Products are defined locally and purchases complete without API calls.
#
# DEMO=1 (default) - demo mode, no API calls
# DEMO=0 - connect to local SaaS
#
PurchaseKit.configure do |config|
  if ENV.fetch("DEMO", "1") == "1"
    config.demo_mode = true
    config.demo_products = {
      "prod_3VC24F5M" => {apple_product_id: "dev.purchasekit.pro.annual"},
      "prod_28VWPCQ7" => {apple_product_id: "dev.purchasekit.pro.monthly"}
    }
    puts "PurchaseKit: Demo mode enabled"
  else
    # Connect to local SaaS for development testing
    config.api_url = ENV.fetch("PURCHASEKIT_API_URL", "http://localhost:3000")
    config.api_key = ENV.fetch("PURCHASEKIT_API_KEY", "sk_G4JJ8JQGR56V3PXV7726XQRQ8GC3CX2M")
    config.app_id = ENV.fetch("PURCHASEKIT_APP_ID", "app_WR48CQHH")
    config.webhook_secret = ENV.fetch("PURCHASEKIT_WEBHOOK_SECRET", "whsec_DEMO1234567890ABCDEFGHIJKLMNOPQR")
    puts "PurchaseKit: Connecting to #{config.api_url}"
  end
end
