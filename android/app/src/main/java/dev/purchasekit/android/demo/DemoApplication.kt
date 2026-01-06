package dev.purchasekit.android.demo

import android.app.Application
import dev.hotwire.core.bridge.BridgeComponentFactory
import dev.hotwire.core.bridge.KotlinXJsonConverter
import dev.hotwire.core.config.Hotwire
import dev.hotwire.core.turbo.config.PathConfiguration
import dev.hotwire.navigation.config.registerBridgeComponents
import dev.purchasekit.android.PaywallComponent

class DemoApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        Hotwire.loadPathConfiguration(
            context = this,
            location = PathConfiguration.Location(
                remoteFileUrl = "$baseUrl/configuration/android.json"
            )
        )

        Hotwire.registerBridgeComponents(
            BridgeComponentFactory("paywall", ::PaywallComponent)
        )

        Hotwire.config.jsonConverter = KotlinXJsonConverter()
    }
}
