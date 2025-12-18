import HotwireNative
import PurchaseKit
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureHotwire()
        return true
    }

    private func configureHotwire() {
        Hotwire.loadPathConfiguration(from: [
            .server(baseUrl.appending(path: "configuration/ios.json")),
        ])

        Hotwire.registerBridgeComponents([
            PaywallComponent.self,
        ])
    }
}
