# Example Rails app

Demonstrates PurchaseKit integration with:
- Pay gem for subscription management
- Session-based authentication (no Devise)
- Paywall with plan selection
- ActionCable for real-time redirect after purchase

## Key files

- `app/views/paywalls/show.html.erb` - Paywall using the builder pattern
- `app/controllers/paywalls_controller.rb` - Requires authentication, checks subscription
- `app/channels/application_cable/connection.rb` - WebSocket auth via session cookie
- `config/initializers/purchasekit.rb` - Gem configuration
- `bin/test_webhook` - Script to test webhook handling locally

## Running locally

```bash
bin/setup
bin/rails db:seed
bin/rails server
```

Sign in: `user@example.com` / `password`

## Testing webhooks

```bash
bin/test_webhook created    # Test subscription.created
bin/test_webhook updated    # Test subscription.updated
bin/test_webhook canceled   # Test subscription.canceled
bin/test_webhook expired    # Test subscription.expired
```

Environment variables:
- `CUSTOMER_ID` - Override Pay::Customer ID
- `SUCCESS_PATH` - Override redirect path (default: /paid)

## Architecture notes

- Uses `Current.user` for request-local user access
- Authorization via `Authorization` concern (checks `user.subscribed?`)
- No mailer or background job setup (uses async adapter)
- SQLite for simplicity
