# Demo Rails app (without Pay gem)

Demonstrates PurchaseKit integration without the Pay gem:
- Uses `purchasekit` gem (no Pay gem in Gemfile)
- Custom Subscription model for subscription storage
- Event callbacks to handle subscription lifecycle
- Session-based authentication (no Devise)
- Paywall with plan selection

## Quick start

```bash
bin/setup
bin/rails server -p 3001
```

Then run the iOS app in Xcode. Sign in with `user@example.com` / `password`.

## Demo mode

This app uses demo mode - no PurchaseKit account required. Products are defined locally in `config/initializers/purchasekit.rb` and match the iOS app's StoreKit configuration.

## Key files

- `config/initializers/purchasekit.rb` - Demo mode configuration with event callbacks
- `app/models/subscription.rb` - Custom Subscription model
- `app/controllers/paywalls_controller.rb` - Fetches products, requires authentication
- `app/views/paywalls/show.html.erb` - Paywall using the builder pattern
- `app/views/paywalls/_plan_option.html.erb` - Plan option partial with price display

## Event callbacks

Unlike the Pay gem demo, this app handles subscription events via callbacks:

```ruby
# config/initializers/purchasekit.rb
config.on(:subscription_created) do |event|
  user = User.find_by(id: event.customer_id)
  next unless user

  subscription = user.subscriptions.find_or_initialize_by(processor_id: event.subscription_id)
  subscription.update!(
    store: event.store,
    store_product_id: event.store_product_id,
    status: "active",
    current_period_start: event.current_period_start,
    current_period_end: event.current_period_end
  )
end
```

## Paywall pattern

Products are fetched by ID (matching keys in `demo_products`):

```ruby
def show
  @annual = PurchaseKit::Product.find("annual")
  @monthly = PurchaseKit::Product.find("monthly")
end
```

The view uses the builder pattern:

```erb
<%= purchasekit_paywall customer_id: Current.user.id, success_path: paid_path do |paywall| %>
  <%= paywall.plan_option product: @annual, selected: true do %>
    <%= paywall.price %>
  <% end %>
  <%= paywall.submit "Subscribe" %>
<% end %>
```

Note: Uses `Current.user.id` directly since there's no Pay::Customer.

## Resetting purchases

To test the purchase flow again:

1. In Xcode: Debug → StoreKit → Manage Transactions → Delete All
2. Run `bin/rails db:seed:replant` to clear subscriptions and reseed users

## Architecture notes

- Uses `Current.user` for request-local user access
- Authorization via `Authorization` concern (checks `user.subscribed?`)
- Custom Subscription model with enum status (active, canceled, expired)
- No ActionCable - relies on Turbo Stream redirect after demo completion
- SQLite for simplicity
