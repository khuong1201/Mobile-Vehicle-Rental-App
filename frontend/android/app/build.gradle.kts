import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
println("✅ DEBUG keystoreProperties: $keystoreProperties")
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.frontend"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.vehicle.rental"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // signingConfigs {
    //     create("release") {
    //         keyAlias = keystoreProperties["keyAlias"]?.toString()
    //         keyPassword = keystoreProperties["keyPassword"]?.toString()
    //         storeFile = file(keystoreProperties["storeFile"]?.toString())
    //         storePassword = keystoreProperties["storePassword"]?.toString()
    //     }
    // }

    buildTypes {
    getByName("release") {
        isMinifyEnabled = false
        isShrinkResources = false // 👈 fix lỗi ở đây
        // signingConfig = signingConfigs.getByName("release")
    }
}

}
flutter {
    source = "../.."
}
