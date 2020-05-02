//
//  Cleanup.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import UIKit

public protocol Cleanup {
    func cleanup()
}

extension UIStackView: Cleanup {
    public func cleanup() {
        for subview in arrangedSubviews {
            removeArrangedSubviewExplicitly(subview)
        }
    }
    
    public func removeArrangedSubviewExplicitly(_ subview: UIView) {
        removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }
    
    public func removeArrangedSubview(at index: Int, animated: Bool) {
        guard index < arrangedSubviews.count else {
            return
        }
        
        let subview = arrangedSubviews[index]
        
        removeArrangedSubviewExplicitly(subview)
    }
}

extension UIImageView: Cleanup {
    public func cleanup() {
        image = nil
    }
}

extension UIView {
    public func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
