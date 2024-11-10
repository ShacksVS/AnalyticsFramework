//
//  UIControl+Extention.swift
//  
//
//  Created by Viktor Sovyak on 11/3/24.
//

import UIKit

extension UIControl {
    
    static func swizzle() {
        if let originalMethod = class_getInstanceMethod(UIControl.self, #selector(sendAction(_:to:for:))),
           let swizzledMethod = class_getInstanceMethod(UIControl.self, #selector(swizzled_sendAction)) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    @objc func swizzled_sendAction(_ action: Selector,
                                   to target: Any?,
                                   for event: UIEvent?) {
        swizzled_sendAction(action, to: target, for: event)
        
        switch self {
        case let button as UIButton:
            let buttonTitle = button.titleLabel?.text ?? ""
            AnalyticsFramework.shared.logButtonClick(buttonTitle: buttonTitle)
            
        case let toggleSwitch as UISwitch:
            AnalyticsFramework.shared.logSwitchToggle(isOn: toggleSwitch.isOn)
            
        case let slider as UISlider:
            AnalyticsFramework.shared.logSliderChange(value: slider.value)
            
        case let segmentedControl as UISegmentedControl:
            let selectedIndex = segmentedControl.selectedSegmentIndex
            let selectedTitle = segmentedControl.titleForSegment(at: selectedIndex) ?? ""
            AnalyticsFramework.shared.logSegmentedControlChange(
                selectedTitle: selectedTitle,
                selectedIndex: selectedIndex
            )
            
        case let datePicker as UIDatePicker:
            AnalyticsFramework.shared.logDatePickerChange(selectedDate: datePicker.date)
            
        default:
            AnalyticsFramework.shared.logOtherUIControl(type: type(of: self))
        }
    }
}
