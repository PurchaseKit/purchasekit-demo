# PurchaseKit iOS demo

Demo iOS app demonstrating [PurchaseKit](https://purchasekit.dev) integration with Hotwire Native and StoreKit.

## Requirements

- Xcode 15.0+
- iOS 16.0+ simulator or device

No Apple Developer account required - purchases work locally using Xcode StoreKit testing.

## Setup

### 1. Start the Rails server

```bash
cd ../rails-pay
bin/setup
bin/rails server -p 3001
```

### 2. Run the app

1. Open `PurchaseKitDemo.xcodeproj` in Xcode
2. Select a simulator or device
3. Product → Run

### 3. Test a purchase

1. Sign in with `user@example.com` / `password`
2. Tap "View Paid Content" to see the paywall
3. Select a plan and tap Subscribe
4. Complete the StoreKit test purchase
5. See "You have access!" appear

## How it works

The app uses Xcode's StoreKit Configuration file (`App/Config/PurchaseKit.storekit`) for local testing. Purchases are completed immediately without Apple webhooks - the gem's demo mode handles fulfillment locally.

## Local development

The app points to `http://localhost:3001` by default. To change:

1. Update `baseURL` in `SceneDelegate.swift`
2. Rebuild and run

## Resetting purchases

1. In Xcode with the app running: Debug → StoreKit → Manage Transactions → Delete All
2. In Rails: `bin/rails db:seed:replant`

## Project structure

```
App/
├── AppDelegate.swift    # Bridge component registration
├── SceneDelegate.swift  # Hotwire Native setup and navigation
└── Config/
    └── PurchaseKit.storekit  # StoreKit test products
```

The app uses the PurchaseKit Swift package from `../../ios/` as a local dependency.

## Testing with real Apple webhooks

For production-like testing with real Apple webhooks:

1. Use a real iOS device (not simulator)
2. Create a sandbox Apple ID in App Store Connect
3. Configure webhook URL in App Store Connect
4. Make the Rails server accessible from the internet (ngrok)

See the [documentation](https://purchasekit.dev/docs/ios/testing) for details.
