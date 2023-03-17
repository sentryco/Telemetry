# 🔬 Telemetry

> Bridge to google analytics. Because sdks are black boxes

### Events
With the Telemetry's event() method, you can monitor any event you want.
```swift
Telemetry.event("Authentication", action: "Sign Up Completed")
```

### Screenviews
You should frequently keep track of the "screens" the user navigates to. Your ViewController's viewDidAppear is a logical place to do that. The Telemetry's screenView() method can be used; it performs the same function as event().
```swift
Telemetry.screenView("Beer")
```

### Sessions
By calling session(start: true) when the user opens the application and session(start: false) when they close it, you can keep track of each user's individual sessions. You can do this in your UIApplicationDelegate application by following the example given here:.

```swift
Telemetry.trackerID = "UA-XXXXX-XX")
Telemetry.session(start: true) // applicationDidBecomeActive
Telemetry.session(start: false) // applicationDidEnterBackground
```

### Gotchas:
- Telemetry will automatically request that Google Analytics anonymize user IPs in order to comply with GDPR.
- Stores a random UUID that uniquely identifies the user/install using the native UserDefaults . standard. The user identifier may be lost if the UserDefaults are cleared or altered in any other way, and the Telemetry will create a new, unique identifier in its place.

### Resources:
- Anonymous GA: https://stackoverflow.com/questions/50392242/how-anonymize-google-analytics-for-ios-for-gdpr-rgpd-purpose
- Guide on fingerprinting in iOS: https://nshipster.com/device-identifiers/
- Guide on identifiers: https://gist.github.com/hujunfeng/6265995

### Todo:
- Rename package to Telemetry? ✅
- add more doc to readme ✅
- Add documentation to this readme on how to setup Google analytics for your google account etc. 👈
- Seems like firebase crashlytics is the way to go now days. Its also free to use etc
- Begin turning the pseudo code into production code 👈 🏀
- improve documentation
