# PurchaseKit demo

This Rails application demonstrates the PurchaseKit integration for in-app purchases.

It contains working code for subscription management using the Pay gem, authentication, and authorization based on active subscriptions.

## Quick start

```bash
bin/setup
bin/rails db:seed
bin/rails server
```

Sign in with: `user@example.com` / `password`

## Demo mode vs SaaS mode

By default, the app runs in **demo mode** - purchases complete locally without API calls.

To connect to the local SaaS for end-to-end testing:

```bash
DEMO=0 bin/rails server
```

This requires the SaaS to be running at `http://localhost:3000` with seeded data.

| Mode | Command | Description |
|------|---------|-------------|
| Demo (default) | `bin/rails server` | Local purchases, no API calls |
| SaaS | `DEMO=0 bin/rails server` | Connects to local SaaS |

## Requirements

* Ruby 3.2+
* SQLite
* Rails 8.1+
