//
//  UIWindow+.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    public static var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared
                .connectedScenes
                .compactMap{ $0 as? UIWindowScene }
                .flatMap{ $0.windows }
                .first{ $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    public var visibleViewController: UIViewController? {
        guard let viewController = rootViewController else {
            return nil
        }
        
        var topViewController: UIViewController = viewController
        
        while topViewController.presentedViewController != nil {
            topViewController = topViewController.presentedViewController!
        }
        
        return topViewController.contentViewController
    }
    
    public var visibleView: UIView {
        return visibleViewController?.viewIfLoaded ?? self
    }
}
