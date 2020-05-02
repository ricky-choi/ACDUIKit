//
//  UIStackView+.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    public func closedSubview(point: CGPoint) -> UIView? {
        
        return arrangedSubviews.sorted { (lview, rview) -> Bool in
            let ldistance = lview.frame.distance(from: point, axis: axis)
            let rdistance = rview.frame.distance(from: point, axis: axis)
            return ldistance < rdistance
        }
        .first
    }
    
    public var numberOfItems: Int {
        arrangedSubviews.filter({ !$0.isHidden }).count
    }
}

extension CGRect {
    fileprivate func distance(from: CGPoint, axis: NSLayoutConstraint.Axis) -> CGFloat {
        guard !contains(from) else {
            return 0
        }
        
        // point is outside of rect
        switch axis {
        case .horizontal:
            return min((from.x - minX).magnitude, (from.x - maxX).magnitude)
        default: // vertical
            return min((from.y - minY).magnitude, (from.y - maxY).magnitude)
        }
    }
}
