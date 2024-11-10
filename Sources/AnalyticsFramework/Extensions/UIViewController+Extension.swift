//
//  UIViewController+Extension.swift
//  
//
//  Created by Viktor Sovyak on 11/3/24.
//

import UIKit

extension UIViewController {
    
    static let swizzleViewDidAppear: Void = {
        let originalSelector = #selector(UIViewController.viewDidAppear(_:))
        let swizzledSelector = #selector(UIViewController.myViewDidAppear(_:))

        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }()

    static let swizzleViewWillDisappear: Void = {
        let originalSelector = #selector(UIViewController.viewWillDisappear(_:))
        let swizzledSelector = #selector(UIViewController.myViewWillDisappear(_:))

        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }()

    @objc func myViewDidAppear(_ animated: Bool) {
        self.myViewDidAppear(animated)
        AnalyticsFramework.shared.logScreenAppear(viewControllerName: String(describing: type(of: self)))
    }
    
    @objc func myViewWillDisappear(_ animated: Bool) {
        self.myViewWillDisappear(animated)
        AnalyticsFramework.shared.logScreenDisappear(viewControllerName: String(describing: type(of: self)))
    }
}
