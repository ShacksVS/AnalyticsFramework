// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

/// `AnalyticsFramework` is a singleton class that provides an easy-to-use framework for tracking 
/// user interactions and screen appearances in an iOS application.
/// It logs interactions such as button clicks, screen appearances, table cell selections, and other UI control events.
final public class AnalyticsFramework {
    
    /// A private struct that defines element types as constants for consistent logging.
    private struct ElementTypes {
        
        /// Constant representing a table view cell.
        static let UITableViewCell = "UITableViewCell"
        /// Constant representing a view controller.
        static let UIViewController = "UIViewController"
        /// Constant representing a button.
        static let UIButton = "UIButton"
        /// Constant representing a switch control.
        static let UISwitch = "UISwitch"
        /// Constant representing a slider control.
        static let UISlider = "UISlider"
        /// Constant representing a segmented control.
        static let UISegmentedControl = "UISegmentedControl"
        /// Constant representing a date picker.
        static let UIDatePicker = "UIDatePicker"
    }
    
    /// The shared instance of `AnalyticsFramework`.
    static public let shared = AnalyticsFramework()
    
    /// Initializes a new instance of `AnalyticsFramework`.
    /// - Note: This initializer is public to allow instantiation, but `shared` should generally be used.
    public init() {}
    
    /// An array to store logged user interactions.
    private var logs = [LogInfo]()
    
    /// A dictionary to store the timestamps of view appearances, using view controller names as keys.
    private var viewAppearTimestamps = [String: Date]()
    
    /// Starts tracking user interactions by applying method swizzling.
    /// - This includes tracking when view controllers appear or disappear, 
    /// and logging interactions with various UI controls.
    public func startTracking() {
        UIViewController.swizzleViewDidAppear
        UIViewController.swizzleViewWillDisappear
        UIControl.swizzle()
    }
    
    /// Displays all logged user interactions in the console.
    /// - This includes timestamps, element types, and action descriptions.
    /// - If available, the duration of screen appearances is also printed.
    public func displayLogs() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        print("\n--- User Interaction Logs ---\n")
        
        if logs.isEmpty {
            print("No logs available.")
        } else {
            for (index, log) in logs.enumerated() {
                let formattedTime = dateFormatter.string(from: log.time)
                let durationText = log.duration != nil ?
                " | Duration: \(String(format: "%.2f", log.duration!)) seconds" :
                ""
                print("\(index + 1). [\(formattedTime)] \(log.elementType): \(log.actionType)\(durationText)")
            }
        }
        
        print("\n--- End of Logs ---\n")
    }
    
    /// Returns all logged user interactions.
    /// - Returns: An array of `LogInfo` objects containing details of each logged event.
    public func getLogs() -> [LogInfo] {
        return self.logs
    }
    
    /// Logs the selection of a table view cell.
    /// - Parameters:
    ///   - tableName: The name of the table view.
    ///   - rowNumber: The row number of the selected cell.
    public func logTableCellSelection(tableName: String, rowNumber: Int) {
        addLog(
            elementType: ElementTypes.UITableViewCell,
            actionType: "Cell Selected - \(tableName) Row \(rowNumber)"
        )
    }
    
    /// Adds a log entry to the logs array.
    /// - Parameters:
    ///   - elementType: The type of the UI element being logged.
    ///   - actionType: A description of the action performed.
    ///   - duration: An optional duration of the action, if applicable.
    private func addLog(elementType: String, actionType: String, duration: TimeInterval? = nil) {
        let logEntry = LogInfo(elementType: elementType, actionType: actionType, time: Date(), duration: duration)
        logs.append(logEntry)
    }
    
    /// Logs when a screen appears.
    /// - Parameter viewControllerName: The name of the view controller that appeared.
    public func logScreenAppear(viewControllerName: String) {
        let currentTime = Date()
        viewAppearTimestamps[viewControllerName] = currentTime
        addLog(
            elementType: ElementTypes.UIViewController,
            actionType: "Screen Appear - \(viewControllerName)",
            duration: nil
        )
    }
    
    /// Logs when a screen disappears.
    /// - Parameter viewControllerName: The name of the view controller that disappeared.
    /// - If the duration of the screen appearance can be calculated, it will be logged.
    public func logScreenDisappear(viewControllerName: String) {
        guard let startTime = viewAppearTimestamps[viewControllerName] else {
            addLog(
                elementType: ElementTypes.UIViewController,
                actionType: "Screen Disappear - \(viewControllerName)",
                duration: nil
            )
            return
        }
        
        let duration = Date().timeIntervalSince(startTime)
        viewAppearTimestamps.removeValue(forKey: viewControllerName)
        
        addLog(
            elementType: ElementTypes.UIViewController,
            actionType: "Screen Disappear - \(viewControllerName)",
            duration: duration
        )
    }
    
    /// Logs a button click event.
    /// - Parameter buttonTitle: The title of the clicked button.
    public func logButtonClick(buttonTitle: String) {
        addLog(
            elementType: ElementTypes.UIButton,
            actionType: "Button Click - \(buttonTitle)"
        )
    }
    
    /// Logs a toggle event for a UISwitch.
    /// - Parameter isOn: A boolean indicating the new state of the switch (ON/OFF).
    public func logSwitchToggle(isOn: Bool) {
        addLog(
            elementType: ElementTypes.UISwitch,
            actionType: "Switch Toggled - \(isOn ? "ON" : "OFF")"
        )
    }
    
    /// Logs a value change for a UISlider.
    /// - Parameter value: The new value of the slider.
    public func logSliderChange(value: Float) {
        addLog(
            elementType: ElementTypes.UISlider,
            actionType: "Slider Value Changed - \(value)"
        )
    }
    
    /// Logs a change in a UISegmentedControl.
    /// - Parameters:
    ///   - selectedTitle: The title of the selected segment.
    ///   - selectedIndex: The index of the selected segment.
    public func logSegmentedControlChange(selectedTitle: String, selectedIndex: Int) {
        addLog(
            elementType: ElementTypes.UISegmentedControl,
            actionType: "Segmented Control Changed - \(selectedTitle) at index \(selectedIndex)"
        )
    }
    
    /// Logs a date change for a UIDatePicker.
    /// - Parameter selectedDate: The new date selected by the user.
    public func logDatePickerChange(selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: selectedDate)
        addLog(elementType: ElementTypes.UIDatePicker, actionType: "Date Picker Changed - \(formattedDate)")
    }
    
    /// Logs interactions with other UI controls.
    /// - Parameters:
    ///   - type: The type of the UI control.
    ///   - actionDescription: A description of the action performed. Default is "Tap".
    public func logOtherUIControl(type: UIControl.Type, actionDescription: String = "Tap") {
        let elementType = String(describing: type)
        addLog(elementType: elementType, actionType: actionDescription)
    }
    
    /// Clears all logged data.
    /// - This method removes all logs from the framework.
    func removeAll() {
        logs = []
    }
}
