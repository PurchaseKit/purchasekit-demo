# PurchaseKit Android demo

Demo Android app demonstrating [PurchaseKit](https://purchasekit.dev) integration with Hotwire Native and Google Play Billing.

## Requirements

- Android Studio
- Google Play Console account with payments profile
- App uploaded to internal testing track

**Note:** Unlike iOS, Android requires a real Play Store listing to test purchases - there's no local-only testing mode.

## Setup

### 1. Start the Rails server

```bash
cd ../rails-pay
bin/setup
bin/rails server -p 3001
```

### 2. Build and upload to Play Console

1. Open this directory in Android Studio
2. Sync Gradle files
3. Build → Generate Signed App Bundle / APK
4. Use the existing keystore at `keystore.jks` (password: `password`)
5. Upload the release AAB to Play Console → Testing → Internal testing

### 3. Configure Play Console

1. Create subscription products in Monetize → Subscriptions
2. Add your Google account to Settings → License testing
3. Share the internal testing opt-in link with testers

### 4. Install and test

1. On your device, accept the internal testing opt-in
2. Install the app **from Play Store** (not Android Studio)
3. Sign in with `user@example.com` / `password`
4. Tap "View Paid Content" to see the paywall
5. Select a plan and tap Subscribe
6. Complete the Google Play test purchase

## Local development

To point the app at your local Rails server:

1. Make your server accessible from the device (use your machine's IP or ngrok)
2. Update `baseUrl` in `app/src/main/java/dev/purchasekit/demo/MainActivity.kt`
3. Rebuild and reinstall

## Why Play Store installation is required

Google Play Billing only works with apps signed by the same key registered in Play Console. Debug builds use a different signing key, so billing calls fail even for license testers.

The workflow is:
1. Build signed release AAB
2. Upload to internal testing
3. Install from Play Store
4. Test purchases with license tester account

## Resetting purchases

1. In Google Play Console: Order management → Find the subscription → Cancel
2. In Rails: `bin/rails db:seed:replant`

## Project structure

```
app/src/main/java/dev/purchasekit/demo/
├── MainActivity.kt      # Hotwire Native setup and navigation
└── DemoApplication.kt   # Bridge component registration
```

The app uses the PurchaseKit library from `../../android/purchasekit/` as a local module.
