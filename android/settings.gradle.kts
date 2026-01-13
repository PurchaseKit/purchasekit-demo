pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
    }
}

rootProject.name = "PurchaseKit Demo"
include(":app")

// Use local PurchaseKit module if .purchasekit.local exists
if (file(".purchasekit.local").exists()) {
    include(":purchasekit")
    project(":purchasekit").projectDir = file("../../android/purchasekit")
}
