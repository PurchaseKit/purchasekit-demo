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

  # Event handlers for subscription lifecycle
  # These are called when webhooks are received from PurchaseKit

  config.on(:subscription_created) do |event|
    user = User.find_by(id: event.customer_id)
    next unless user

    subscription = user.subscriptions.find_or_initialize_by(processor_id: event.subscription_id)
    subscription.update!(
      store: event.store,
      store_product_id: event.store_product_id,
      status: "active",
      current_period_start: event.current_period_start,
      current_period_end: event.current_period_end,
      ends_at: event.ends_at
    )

    Rails.logger.info "[PurchaseKit] Subscription created for user #{user.id}: #{subscription.processor_id}"
  end

  config.on(:subscription_updated) do |event|
    subscription = Subscription.find_by(processor_id: event.subscription_id)
    next unless subscription

    subscription.update!(
      status: event.status,
      current_period_start: event.current_period_start,
      current_period_end: event.current_period_end,
      ends_at: event.ends_at
    )

    Rails.logger.info "[PurchaseKit] Subscription updated: #{subscription.processor_id} -> #{event.status}"
  end

  config.on(:subscription_canceled) do |event|
    subscription = Subscription.find_by(processor_id: event.subscription_id)
    next unless subscription

    subscription.update!(status: "canceled", ends_at: event.ends_at)

    Rails.logger.info "[PurchaseKit] Subscription canceled: #{subscription.processor_id}"
  end

  config.on(:subscription_expired) do |event|
    subscription = Subscription.find_by(processor_id: event.subscription_id)
    next unless subscription

    subscription.update!(status: "expired")

    Rails.logger.info "[PurchaseKit] Subscription expired: #{subscription.processor_id}"
  end
end
