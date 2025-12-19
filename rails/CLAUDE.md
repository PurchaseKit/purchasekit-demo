# Example Rails app

Demonstrates PurchaseKit integration with:
- Pay gem for subscription management
- Session-based authentication (no Devise)
- Paywall with plan selection
- ActionCable for real-time redirect after purchase

## Key files

- `app/views/paywalls/show.html.erb` - Paywall using the builder pattern
- `app/views/paywalls/_plan_option.html.erb` - Plan option partial with price display
- `app/controllers/paywalls_controller.rb` - Fetches products, requires authentication
- `app/channels/application_cable/connection.rb` - WebSocket auth via session cookie
- `config/initializers/purchasekit.rb` - Gem configuration
- `config/credentials/development.yml.enc` - API credentials (see below)
- `bin/test_webhook` - Script to test webhook handling locally

## Configuration

Credentials are stored in `config/credentials/development.yml.enc`:

```yaml
purchasekit:
  api_url: http://localhost:3000
  api_key: sk_G4JJ8JQGR56V3PXV7726XQRQ8GC3CX2M
  app_id: app_WR48CQHH
```

These match the SaaS seeds for local development.

## Running locally

Requires both the SaaS and example app running:

```bash
# Terminal 1: Start SaaS on port 3000
cd saas && bin/rails server

# Terminal 2: Start example app on port 3001
cd examples/rails && bin/rails server -p 3001
```

Sign in: `user@example.com` / `password`

## Paywall pattern

Products are fetched from the SaaS in the controller:

```ruby
def show
  @annual = PurchaseKit::Product.find("prod_3VC24F5M")
  @monthly = PurchaseKit::Product.find("prod_28VWPCQ7")
end
```

The view uses the builder pattern with product objects:

```erb
<%= purchasekit_paywall customer: Current.user.payment_processor do |paywall| %>
  <%= paywall.plan_option product: @annual, selected: true do %>
    <%= paywall.price %>
  <% end %>
  <%= paywall.submit "Subscribe" %>
<% end %>
```

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
