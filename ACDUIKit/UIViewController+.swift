//
//  UIViewController+.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public var isPushed: Bool {
        guard let navigationController = navigationController else {
            return false
        }
        
        if let currentNavigationStackIndex = navigationController.viewControllers.firstIndex(of: self) {
            return currentNavigationStackIndex > 0
        }
        
        return false
    }
    
    public func dismissOrPop(animated: Bool) {
        if isPushed {
            navigationController?.popViewController(animated: animated)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    public func addNewViewController(_ childViewController: UIViewController, targetView: UIView? = nil) {
        guard let parentView = targetView ?? view else {
            return
        }
        
        addChild(childViewController)
        
        let childView = childViewController.view!
        parentView.addSubview(childView)
        childView.fillToSuperview()
        
        childViewController.didMove(toParent: self)
    }
    
    public func removeViewController(_ childViewController: UIViewController) {
        childViewController.remove()
    }
    
    public func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    public var acdTabBarController: ACDTabBarController? {
        var target: UIViewController = self
        while let parent = target.parent {
            if let parent = parent as? ACDTabBarController {
                return parent
            }
            target = parent
        }
        
        return nil
    }
    
    public var isModal: Bool {
        presentingViewController != nil
    }
    
    public var isHoverModal: Bool {
        guard isModal else {
            return false
        }
        
        guard let modalVC = presentingViewController?.presentedViewController else {
            return false
        }
        
        return !(modalVC.modalPresentationStyle == .fullScreen || modalVC.modalPresentationStyle == .overFullScreen)
    }
    
    public var contentViewController: UIViewController {
        if let nc = self as? UINavigationController {
            return nc.visibleViewController?.contentViewController ?? self
        } else if let pc = self as? UIPageViewController {
            return pc.viewControllers?.first?.contentViewController ?? self
        } else if let tc = self as? ACDTabBarControllerProtocol_ {
            return tc.selectedViewController?.contentViewController ?? self
        } else {
            return self
        }
    }
}
