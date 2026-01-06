# PurchaseKit demo

Demo applications demonstrating the [PurchaseKit](https://purchasekit.dev) integration.

## Quick start

### 1. Start the Rails server

```bash
cd rails-pay
bin/setup
bin/rails server -p 3001
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

## Resetting purchases

### iOS

1. **Reset StoreKit transactions** - In Xcode with the app running: Debug → StoreKit → Manage Transactions → Delete All
2. **Reset the Rails database** - Run `bin/rails db:seed:replant` to clear subscriptions and reseed users

### Android

1. **Cancel test subscriptions** - In Google Play Console: Order management → Find the subscription → Cancel
2. **Reset the Rails database** - Run `bin/rails db:seed:replant` to clear subscriptions and reseed users

## Directory structure

- `rails-pay/` - Demo Rails app with Pay gem integration
- `rails-core/` - Demo Rails app without Pay gem (custom subscription handling)
- `ios/` - Demo iOS app using the PurchaseKit Swift package
- `android/` - Demo Android app using Google Play Billing

## Test credentials

| Email | Password | Subscription |
|-------|----------|--------------|
| `user@example.com` | `password` | None |
| `customer@example.com` | `password` | Active |

## Production setup

When you're ready to use PurchaseKit in production, see the [documentation](https://purchasekit.dev/docs) for details.
