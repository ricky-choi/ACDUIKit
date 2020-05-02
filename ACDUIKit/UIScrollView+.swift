//
//  UIScrollView+.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    public var contentBottomRemain: CGFloat {
        contentSize.height - contentOffset.y - frame.height + adjustedContentInset.bottom
    }
    
    public var contentUserInteractionOffset: CGPoint {
        contentOffset - CGPoint(x: contentInset.left, y: contentInset.top)
    }
    
    public func showOrigin(animated: Bool = true) {
        let offset = CGPoint(x: -adjustedContentInset.left, y: -adjustedContentInset.top)
        setContentOffset(offset, animated: animated)
    }
}
