# PurchaseKit demo

Demo applications demonstrating the [PurchaseKit](https://purchasekit.dev) integration.

## Quick start

### 1. Start the Rails server

```bash
cd rails
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

## Resetting purchases

To start fresh and test the purchase flow again:

1. **Reset StoreKit transactions** - In Xcode with the app running: Debug → StoreKit → Manage Transactions → Delete All
2. **Reset the Rails database** - Run `bin/rails db:seed:replant` to clear subscriptions and reseed users

## Directory structure

- `rails/` - Demo Rails app with authentication, paywall, and Pay gem integration
- `ios/` - Demo iOS app using the PurchaseKit Swift package

## Production setup

When you're ready to use PurchaseKit in production, see the [documentation](https://purchasekit.dev/docs) for details.
