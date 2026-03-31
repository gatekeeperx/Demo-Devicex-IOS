# Foodhub - DeviceX iOS Demo

A demonstration iOS application showcasing the integration of **GatekeeperX DeviceX iOS SDK** for device fingerprinting and event tracking.

---

## Quick Integration Guide

### 1. Installation via SPM
Add DeviceX to your Xcode project using Swift Package Manager (`File > Add Package Dependencies...`):
- **URL**: `https://github.com/gatekeeperx/devicex-ios-distribution.git`
- **Dependency Rule**: Up to Next Major Version (`1.0.10`+)

### 2. Initialization
Import `DeviceX` and configure it globally when your app starts (e.g., in your `App` struct or `AppDelegate`):

```swift
import DeviceX

@main
struct YourApp: App {
    init() {
        Task {
            do {
                try await Devicex.configureGloballyAsync { config in
                    config.setApiKey("YOUR_API_KEY")
                    config.setTenant("YOUR_TENANT")
                    config.setEnvironment(.sandbox) // Use .production for live tracking
                }
                if let version = try? Devicex.instance.version {
                    print("Devicex initialized correctly - version: \(version)")
                }
            } catch {
                print("Error initializing Devicex: \(error.localizedDescription)")
            }
        }
    }
    // ...
}
```

### 3. Track Events
Retrieve the instance and send an event asynchronously from anywhere in your code:

```swift
// Check that Devicex is configured and instance exists
guard Devicex.hasInstance, let dx = try? Devicex.instance else {
    print("❌ DeviceX not configured")
    return
}

// Send event
dx.sendEventAsync(name: "item_click", properties: [
    "item_name": "Noodles"
]) { result in
    switch result {
    case .success(let successData):
        print("✅ Event tracked. Device ID: \(successData.deviceXId)")
    case .failure(let errorData):
        print("❌ Event failed: \(errorData.errorMessage)")
    }
}
```

> **Note on Concurrency**: 
> - **Initialization** (`Devicex.configureGloballyAsync`) requires a `Task {}` block because it is an `async` function and must be called from an asynchronous context, such as outside of the main `App` initializer.
> - **Event Tracking** (`sendEventAsync`) is executed synchronously and returns via a completion handler. Therefore, it **does not** need to be wrapped in a `Task {}`.
