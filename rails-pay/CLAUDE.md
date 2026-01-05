# Demo Rails app (with Pay gem)

Demonstrates PurchaseKit integration with the Pay gem:
- Uses `purchasekit` gem with Pay gem in Gemfile
- Automatic Pay::Subscription creation from webhooks
- Session-based authentication (no Devise)
- Paywall with plan selection
- ActionCable for real-time redirect after purchase

## Quick start

```bash
bin/setup
bin/rails server -p 3001
```

Then run the iOS app in Xcode. Sign in with `user@example.com` / `password`.

## Demo mode

This app uses demo mode - no PurchaseKit account required. Products are defined locally in `config/initializers/purchasekit.rb` and match the iOS app's StoreKit configuration.

## Key files

- `config/initializers/purchasekit.rb` - Demo mode configuration with local products
- `app/controllers/paywalls_controller.rb` - Fetches products, requires authentication
- `app/views/paywalls/show.html.erb` - Paywall using the builder pattern
- `app/views/paywalls/_plan_option.html.erb` - Plan option partial with price display
- `app/channels/application_cable/connection.rb` - WebSocket auth via session cookie

## Paywall pattern

Products are fetched by ID (matching keys in `demo_products`):

```ruby
def show
  @annual = PurchaseKit::Product.find("annual")
  @monthly = PurchaseKit::Product.find("monthly")
end
```

The view subscribes to Turbo Stream for real-time redirects and uses the builder pattern:

```erb
<%= turbo_stream_from dom_id(Current.user.payment_processor) %>

<%= purchasekit_paywall customer_id: Current.user.payment_processor.id, success_path: paid_path do |paywall| %>
  <%= paywall.plan_option product: @annual, selected: true do %>
    <%= paywall.price %>
  <% end %>
  <%= paywall.submit "Subscribe" %>
<% end %>
```

## Resetting purchases

To test the purchase flow again:

1. In Xcode: Debug → StoreKit → Manage Transactions → Delete All
2. Run `bin/rails db:seed:replant` to clear subscriptions and reseed users

## Architecture notes

- Uses `Current.user` for request-local user access
- Authorization via `Authorization` concern (checks `user.subscribed?`)
- ActionCable broadcasts redirect after webhook completes (30-second fallback if not connected)
- No mailer or background job setup (uses async adapter)
- SQLite for simplicity
