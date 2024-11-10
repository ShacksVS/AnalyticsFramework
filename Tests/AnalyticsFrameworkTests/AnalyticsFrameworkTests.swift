import XCTest
@testable import AnalyticsFramework

final class AnalyticsFrameworkTests: XCTestCase {
    
    var analyticsFramework: AnalyticsFramework!
    
    override func setUp() {
        super.setUp()
        analyticsFramework = AnalyticsFramework.shared
        analyticsFramework.startTracking()
    }
    
    override func tearDown() {
        analyticsFramework = nil
        super.tearDown()
    }
    
    func testLogScreenAppear() {
        analyticsFramework.removeAll()
        analyticsFramework.logScreenAppear(viewControllerName: "TestViewController")
        
        let logs = analyticsFramework.getLogs()
        XCTAssertEqual(logs.count, 1)
        
        let log = logs.first!
        XCTAssertEqual(log.elementType, "UIViewController")
        XCTAssertEqual(log.actionType, "Screen Appear - TestViewController")
        XCTAssertNil(log.duration)
    }
    
    func testLogScreenDisappearWithDuration() {
        analyticsFramework.removeAll()
        analyticsFramework.logScreenAppear(viewControllerName: "TestViewController")
        
        sleep(1)
        
        analyticsFramework.logScreenDisappear(viewControllerName: "TestViewController")
        
        let logs = analyticsFramework.getLogs()
        XCTAssertEqual(logs.count, 2)
        
        let log = logs.last!
        XCTAssertEqual(log.elementType, "UIViewController")
        XCTAssertEqual(log.actionType, "Screen Disappear - TestViewController")
        XCTAssertNotNil(log.duration)
        
        XCTAssertEqual(log.duration!, 1.0, accuracy: 0.1)
    }
    
    func testLogButtonClick() {
        analyticsFramework.removeAll()
        analyticsFramework.logButtonClick(buttonTitle: "TestButton")
        
        let logs = analyticsFramework.getLogs()
        XCTAssertEqual(logs.count, 1)
        
        let log = logs.first!
        XCTAssertEqual(log.elementType, "UIButton")
        XCTAssertEqual(log.actionType, "Button Click - TestButton")
    }
    
    func testLogSwitchToggle() {
        analyticsFramework.removeAll()
        analyticsFramework.logSwitchToggle(isOn: true)
        
        let logs = analyticsFramework.getLogs()
        XCTAssertEqual(logs.count, 1)
        
        let log = logs.first!
        XCTAssertEqual(log.elementType, "UISwitch")
        XCTAssertEqual(log.actionType, "Switch Toggled - ON")
    }
    
    func testLogSliderChange() {
        analyticsFramework.removeAll()
        analyticsFramework.logSliderChange(value: 0.5)
        
        let logs = analyticsFramework.getLogs()
        XCTAssertEqual(logs.count, 1)
        
        let log = logs.first!
        XCTAssertEqual(log.elementType, "UISlider")
        XCTAssertEqual(log.actionType, "Slider Value Changed - 0.5")
    }
    
    func testLogSegmentedControlChange() {
        analyticsFramework.removeAll()
        analyticsFramework.logSegmentedControlChange(selectedTitle: "TestSegment", selectedIndex: 1)
        
        let logs = analyticsFramework.getLogs()
        XCTAssertEqual(logs.count, 1)
        
        let log = logs.first!
        XCTAssertEqual(log.elementType, "UISegmentedControl")
        XCTAssertEqual(log.actionType, "Segmented Control Changed - TestSegment at index 1")
    }
    
    func testLogDatePickerChange() {
        analyticsFramework.removeAll()
        
        let date = Date()
        analyticsFramework.logDatePickerChange(selectedDate: date)
        
        let logs = analyticsFramework.getLogs()
        XCTAssertEqual(logs.count, 1)
        
        let log = logs.first!
        XCTAssertEqual(log.elementType, "UIDatePicker")
        XCTAssertTrue(log.actionType.starts(with: "Date Picker Changed"))
    }
}

