# Demo directory

This directory contains demo applications demonstrating PurchaseKit integration.

## Structure

| Directory | Description |
|-----------|-------------|
| `rails-pay/` | Demo Rails app with Pay gem - automatic Pay::Subscription creation |
| `rails-core/` | Demo Rails app without Pay - custom Subscription model + callbacks |
| `ios/` | Demo iOS app using the PurchaseKit Swift package from `/ios` |

## Quick start

### Pay gem demo

Uses `purchasekit` gem with Pay gem for automatic Pay::Subscription creation:

```bash
cd rails-pay && bin/setup && bin/dev
```

### Core gem demo

Uses `purchasekit` gem without Pay - demonstrates custom subscription handling via event callbacks:

```bash
cd rails-core && bin/setup && bin/dev
```

Both demos run on port 3001 by default.

### iOS demo

Open `ios/PurchaseKitDemo.xcodeproj` in Xcode and run on a simulator.

## Test credentials

Both apps use the same test users:

| Email | Password | Subscription |
|-------|----------|--------------|
| `user@example.com` | `password` | None |
| `customer@example.com` | `password` | Active |

## Purpose

These demos serve as:
1. Development testbeds for the gem
2. Reference implementations for developers
3. Documentation through working code

## Comparison

Both demos use the same `purchasekit` gem. The gem auto-detects whether Pay is present via `defined?(::Pay)`.

| Feature | rails-pay | rails-core |
|---------|----------|-----------|
| Gem | `purchasekit` | `purchasekit` |
| Pay gem | Yes | No |
| Subscription model | Pay::Subscription | Custom Subscription |
| Webhook handling | Automatic via Pay | Event callbacks |
| Redirect after purchase | ActionCable broadcast | Turbo Stream |

### rails-pay approach

Pay gem is in the Gemfile, so PurchaseKit automatically:
- Creates Pay::Subscription records from webhooks
- Broadcasts Turbo Stream redirects via ActionCable

### rails-core approach

No Pay gem, so the app handles subscriptions via event callbacks:

```ruby
# config/initializers/purchasekit.rb
config.on(:subscription_created) do |event|
  user = User.find_by(id: event.customer_id)
  subscription = user.subscriptions.find_or_initialize_by(processor_id: event.subscription_id)
  subscription.update!(store: event.store, status: "active", ...)
end
```

## Future demos

- `android/` - Android app with Hotwire Native and PurchaseKit bridge component
