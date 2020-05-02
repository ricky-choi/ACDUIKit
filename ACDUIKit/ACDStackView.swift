//
//  ACDStackView.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import UIKit

open class ACDStackView: UIStackView, HitExpandable {
    
    public var isExpandHitArea: Bool = false
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isExpandHitArea, containsInExpandedBounds(point: point), let targetSubview = closedSubview(point: point) {
            return targetSubview
        }
        
        return super.hitTest(point, with: event)
    }

}
