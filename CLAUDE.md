# Demo directory

This directory contains demo applications demonstrating PurchaseKit integration.

## Structure

| Directory | Description |
|-----------|-------------|
| `rails/pay/` | Demo Rails app with Pay gem - automatic Pay::Subscription creation |
| `rails/standalone/` | Demo Rails app without Pay - custom Subscription model + callbacks |
| `ios/` | Demo iOS app using PurchaseKit Swift package (remote by default) |
| `android/` | Demo Android app using PurchaseKit from JitPack (remote by default) |

## Quick start

### Pay gem demo

Uses `purchasekit` gem with Pay gem for automatic Pay::Subscription creation:

```bash
cd rails/pay && bin/setup && bin/dev
```

### Standalone demo

Uses `purchasekit` gem without Pay - demonstrates custom subscription handling via event callbacks:

```bash
cd rails/standalone && bin/setup && bin/dev
```

Both demos run on port 3000 by default.

### iOS demo

Open `ios/PurchaseKitDemo.xcodeproj` in Xcode and run on a simulator.

### Android demo

Open `android/` in Android Studio and run on an emulator or device. The app uses Hotwire Native with a PurchaseKit bridge component for Google Play Billing.

**Note:** Android purchases require:
- A linked Google Play Console account with license testers configured
- The app published to internal testing track (or use real device for local testing)
- Service account credentials uploaded to PurchaseKit at `/account/integrations`

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

| Feature | rails/pay | rails/standalone |
|---------|-----------|------------------|
| Gem | `purchasekit` | `purchasekit` |
| Pay gem | Yes | No |
| Subscription model | Pay::Subscription | Custom Subscription |
| Webhook handling | Automatic via Pay | Event callbacks |
| Redirect after purchase | ActionCable broadcast | Turbo Stream |

### rails/pay approach

Pay gem is in the Gemfile, so PurchaseKit automatically:
- Creates Pay::Subscription records from webhooks
- Broadcasts Turbo Stream redirects via ActionCable

### rails/standalone approach

No Pay gem, so the app handles subscriptions via event callbacks:

```ruby
# config/initializers/purchasekit.rb
config.on(:subscription_created) do |event|
  user = User.find_by(id: event.customer_id)
  subscription = user.subscriptions.find_or_initialize_by(processor_id: event.subscription_id)
  subscription.update!(store: event.store, status: "active", ...)
end
```

## Web paywall modal

The paywall pages show a modal overlay when viewed on web (non-Hotwire Native). This informs visitors that in-app purchases require the native app. Uses Bootstrap's static modal with no JavaScript - just CSS classes.

```erb
<%# app/views/paywalls/show.html.erb %>
<%= render "native_app_modal" unless hotwire_native_app? %>
```

The `hotwire_native_app?` helper detects Hotwire Native apps via User-Agent.

## Platform differences

### iOS (Xcode StoreKit)

- Uses Xcode StoreKit Configuration for testing without a real App Store account
- Clear sandbox/production separation
- Demo mode supported (completes locally without PurchaseKit SaaS)

### Android (Google Play)

- Requires real Google Play Console account even for testing
- No separate sandbox environment (uses license testers instead)
- `testPurchase` flag only appears for configured license tester accounts
- Service account permissions can take up to 24 hours to propagate after linking in Play Console

## Local development (contributors)

By default, demo apps use remote packages (RubyGems, GitHub, JitPack). To develop against local packages:

### Rails and Android

```bash
# From demo/ directory
bin/use-local
cd rails/pay && bundle install
```

To switch back:

```bash
bin/use-remote
cd rails/pay && bundle install
```

This creates `.purchasekit.local` marker files:
- Rails: Gemfile checks `../.purchasekit.local`
- Android: settings.gradle.kts checks `.purchasekit.local`

### iOS (manual)

**To use local package:**
1. Open the project in Xcode
2. Project → Package Dependencies → select `purchasekit-ios` → click `-` to remove
3. File → Add Package Dependencies → click "Add Local..." → select the `ios/` folder

**To use remote package:**
1. Remove the local `PurchaseKit` package from the Project Navigator (right-click → Delete → Remove Reference)
2. File → Add Package Dependencies → enter `https://github.com/purchasekit/purchasekit-ios`

## Server URL configuration

Both native apps default to `localhost:3000` for local development. To test against the deployed server (e.g., for webhook testing), swap the commented URLs:

- **iOS**: `demo/ios/App/SceneDelegate.swift`
- **Android**: `demo/android/app/src/main/java/dev/purchasekit/android/demo/MainActivity.kt`

Android uses `10.0.2.2:3000` which is the emulator's alias for the host machine's localhost.
