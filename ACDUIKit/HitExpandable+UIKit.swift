//
//  HitExpandable+UIKit.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import UIKit

extension HitExpandable where Self: UIView {
    public func expandedBounds() -> CGRect {
        bounds.insetBy(dx: -hitInset(), dy: -hitInset())
    }
    
    public func containsInExpandedBounds(point: CGPoint) -> Bool {
        expandedBounds().contains(point)
    }
}
