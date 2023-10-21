![mit](https://img.shields.io/badge/License-MIT-brightgreen.svg)
![platform](https://img.shields.io/badge/Platform-iOS/macOS-blue.svg)
![Lang](https://img.shields.io/badge/Language-Swift%205-orange.svg)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift)
[![Tests](https://github.com/sentryco/Telemetry/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/Telemetry/actions/workflows/Tests.yml)
[![codebeat badge](https://codebeat.co/badges/5785dd6c-aa75-48a6-a222-0874b2b93e2c)](https://codebeat.co/projects/github-com-sentryco-telemetry-main)

# 🔬 Telemetry

> Telemetry is an open-source SDK for Google Analytics. We believe in transparency and security, hence the open-source approach.

## Installation
You can add Telemetry to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/sentryco/Telemetry", from: "1.0.0")
]
```

### Why Use Telemetry?
- 🤖 Google Analytics (GA) provides valuable insights into user engagement and traction. Telemetry helps you leverage these insights to improve your application.
- 🐛 GA is an excellent tool for error and crash reporting. Stay ahead of UX issues by receiving notifications about bugs.
- 🌍 GA helps you understand the geographical distribution of your app's users.

> **Warning**  
> We currently use the GA3 API, which will be deprecated in July. We plan to migrate to GA4 before then.

### Event Tracking
With Telemetry's `event()` method, you can monitor any event of interest.
```swift
Telemetry.event("Authorize", action: "Access granted")
```

### Screenviews
It's important to track the "screens" that users navigate to. A logical place to do this is in your ViewController's `viewDidAppear` method. Use Telemetry's `screenView()` method for this purpose.
```swift
Telemetry.screenView("Cheers")
```

### Sessions
By calling `session(start: true)` when the application opens and `session(start: false)` when it closes, you can track individual user sessions. Here's an example of how to do this in your `UIApplicationDelegate` application:

```swift
Telemetry.trackerID = "UA-XXXXX-XX")
Telemetry.session(start: true) // applicationDidBecomeActive
Telemetry.session(start: false) // applicationDidEnterBackground
```

### Exception
Use the `exception` method to report warnings and errors.
```swift
Telemetry.exception("Error - database not available", isFatal: false)
```

### Timing
This example tracks the time to fetch user data from a database. The 'category' parameter denotes the operation type ("Database"). The 'variable' parameter specifies the operation ("Fetch"). The 'time' parameter records elapsed time in milliseconds. The optional 'label' parameter can provide additional details.

```swift
// Start the timer
let startTime = Date()

// Perform some operation
// ...

// Calculate the elapsed time
let elapsedTime = Date().timeIntervalSince(startTime)

// Log the timing event
Telemetry.timing(category: "Database", variable: "Fetch", time: elapsedTime, label: "User data fetch")
```

### Gotchas:
- Telemetry automatically requests Google Analytics to anonymize user IPs to comply with GDPR.
- Obtain the token from the admin page of the tracked Google Analytics entity.
- While Firebase Crashlytics is a popular choice, it can be complex due to the need to use their SDK. Sometimes, simplicity is key.
- When setting up your Google Analytics account, ensure to use the legacy `Universal Analytics property` and not GA4. This legacy option is under the advanced menu during account setup.
- Why are closed-source SDKs a concern? According to Apple's app-review guidelines: `Ensure that all software frameworks and dependencies also adhere to the App Store Review Guidelines`.

### Resources:
- Anonymous GA: https://stackoverflow.com/questions/50392242/how-anonymize-google-analytics-for-ios-for-gdpr-rgpd-purpose
- Guide on fingerprinting in iOS: https://nshipster.com/device-identifiers/
- Guide on identifiers: https://gist.github.com/hujunfeng/6265995
- Noteworthy tracker project: https://github.com/kafejo/Tracker-Aggregator
- Another noteworthy tracker project: https://github.com/devxoul/Umbrella
- Using Google Analytics for Tracking SaaS: https://reflectivedata.com/using-google-analytics-for-tracking-saas/

### Todo:
- Add info to this readme on how to setup Google analytics for your google account etc 🚧
