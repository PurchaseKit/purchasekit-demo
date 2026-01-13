plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.serialization)
}

android {
    namespace = "dev.purchasekit.android.demo"
    compileSdk {
        version = release(36)
    }

    defaultConfig {
        applicationId = "dev.purchasekit.android.demo"
        minSdk = 28
        targetSdk = 36
        versionCode = 4
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    signingConfigs {
        create("release") {
            storeFile = file("../keystore.jks")
            storePassword = "password"
            keyAlias = "key0"
            keyPassword = "password"
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("release")
        }
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        jvmToolchain(17)
    }
}

// Check if local PurchaseKit module is included
val useLocalPurchaseKit = rootProject.subprojects.any { it.name == "purchasekit" }

dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.constraintlayout)

    implementation(libs.hotwire.native.core)
    implementation(libs.hotwire.native.navigation)

    if (useLocalPurchaseKit) {
        implementation(project(":purchasekit"))
    } else {
        implementation("com.github.purchasekit:purchasekit-android:0.1.0")
    }
}
