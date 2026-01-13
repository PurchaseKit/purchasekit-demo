# PurchaseKit demo

Demo applications demonstrating the [PurchaseKit](https://purchasekit.dev) integration.

## Quick start

### 1. Start the Rails server

```bash
cd rails/pay
bin/setup
bin/dev
```

### 2. Run the iOS app

Open `ios/PurchaseKitDemo.xcodeproj` in Xcode and run on a simulator (Product → Run).

### 3. Test a purchase

1. Sign in with `user@example.com` / `password`
2. Tap "View Paid Content" to see the paywall
3. Select a plan and tap Subscribe
4. Complete the StoreKit test purchase
5. See "You have access!" appear

No PurchaseKit account or Apple Developer account required - everything runs locally using StoreKit testing and demo mode.

## Android setup

The Android demo requires a Google Play Console account and an app uploaded to internal testing before you can test purchases.

<details>
<summary>Android setup instructions</summary>

### Prerequisites

- Android Studio
- Google Play Console account with payments profile set up
- App uploaded to internal testing track

### Building the app

1. Open `android/` in Android Studio
2. Sync Gradle files
3. Build → Generate Signed App Bundle / APK
4. Select the existing keystore at `android/keystore.jks` (password: `password`)
5. Build the release AAB for upload to Play Console

### Google Play Console setup

1. Create an app in Google Play Console
2. Upload the signed AAB to Testing → Internal testing
3. Create subscription products in Monetize → Subscriptions
4. Add your Google account to Settings → License testing

### Running on device

1. On your device, open the internal testing opt-in link and accept
2. Install the app **from Play Store** (not Android Studio) - billing requires the signed release build
3. Run the Rails server accessible from the device (update `baseUrl` in `MainActivity.kt`)
4. The Google Play billing UI will appear for test purchases

**Note:** Running from Android Studio uses debug signing which doesn't work for Google Play Billing, even with license testers. Always install from Play Store for purchase testing.

</details>

## Resetting purchases

### iOS

1. **Reset StoreKit transactions** - In Xcode with the app running: Debug → StoreKit → Manage Transactions → Delete All
2. **Reset the Rails database** - Run `bin/rails db:seed:replant` to clear subscriptions and reseed users

### Android

1. **Cancel test subscriptions** - In Google Play Console: Order management → Find the subscription → Cancel
2. **Reset the Rails database** - Run `bin/rails db:seed:replant` to clear subscriptions and reseed users

## Directory structure

- `rails/pay/` - Demo Rails app with Pay gem integration
- `rails/standalone/` - Demo Rails app without Pay gem (custom subscription handling)
- `ios/` - Demo iOS app using the PurchaseKit Swift package
- `android/` - Demo Android app using Google Play Billing

## Rails demos comparison

Both demos use the same `purchasekit` gem. The gem auto-detects whether Pay is present.

| Feature | rails/pay | rails/standalone |
|---------|-----------|------------------|
| Pay gem | Yes | No |
| Subscription model | `Pay::Subscription` | Custom `Subscription` |
| Webhook handling | Automatic | Event callbacks |

**rails/pay**: Pay gem handles subscription records automatically. PurchaseKit creates `Pay::Subscription` from webhooks.

**rails/standalone**: You handle subscriptions via event callbacks in the initializer:

```ruby
config.on(:subscription_created) do |event|
  user = User.find_by(id: event.customer_id)
  user.subscriptions.create!(store: event.store, status: "active", ...)
end
```

## Demo mode vs SaaS mode

By default, the Rails apps run in **demo mode** - purchases complete locally without API calls.

To connect to the local SaaS for end-to-end testing:

```bash
DEMO=0 bin/dev
```

This requires the SaaS to be running at `http://localhost:3000` with seeded data.

| Mode | Command | Description |
|------|---------|-------------|
| Demo (default) | `bin/dev` | Local purchases, no API calls |
| SaaS | `DEMO=0 bin/dev` | Connects to local SaaS |

## Requirements

* Ruby 3.2+
* SQLite
* Rails 8.1+

## Test credentials

| Email | Password | Subscription |
|-------|----------|--------------|
| `user@example.com` | `password` | None |
| `customer@example.com` | `password` | Active |

## Production setup

When you're ready to use PurchaseKit in production, see the [documentation](https://purchasekit.dev/docs) for details.
