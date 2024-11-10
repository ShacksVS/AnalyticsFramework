# AnalyticsFramework

**AnalyticsFramework** is a comprehensive, lightweight, and easy-to-use Swift framework designed to help iOS developers track and log user interactions within their applications.

## Features
- **Singleton Access**: Use `AnalyticsFramework.shared` to easily access and manage logging.
- **Automatic View Tracking**: Automatically tracks when view controllers appear and disappear, logging their durations.
- **UI Interaction Logging**: Logs a variety of user interactions, such as button clicks, table cell selections, switch toggles, slider value changes, segmented control updates, and date picker changes.
- **Custom Logging**: Supports logging custom UI control interactions with specified descriptions.
- **Log Management**: Easily display all logs in the console or clear them as needed.

## Installation

### Swift Package Manager (SPM)
1. In Xcode, go to **File > Add Packages**.
2. Enter the following URL: https://github.com/ShacksVS/AnalyticsFramework
3. Select the desired version and add it to your project.

### CocoaPods
1. Add `AnalyticsFramework` to your `Podfile`:
```ruby
pod 'AnalyticsFrameworkUnderhood', '~> 0.0.1'
```
2. For more information visit: https://cocoapods.org/pods/AnalyticsFrameworkUnderhood
   
### Manual Installation
1. **Download** or **clone** the repository.
2. **Add** the `AnalyticsFramework` folder to your Xcode project.

## Usage

### Start Tracking
To begin logging interactions and screen appearances (UIKit):
```swift
AnalyticsFramework.shared.startTracking()
```

Unfortunately, underhood tracking currently is not working in SwiftUI. So you need to log it manually.
```swift
AnalyticsFramework.shared.logButtonClick(buttonTitle: "Button title")
```

### Get logs
To get all logs use:
```swift
AnalyticsFramework.shared.getLogs()
```

### Display logs
To print all logs use:
```swift
AnalyticsFramework.shared.displayLogs()
```

## Requirements
- **iOS**: 13.0+
- **Swift**: 5.10+

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.


**Happy Tracking!**
