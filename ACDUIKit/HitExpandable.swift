//
//  HitExpandable.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol HitExpandable {
    var isExpandHitArea: Bool { get }
    func hitInset() -> CGFloat
}

extension HitExpandable {
    public func hitInset() -> CGFloat {
        20
    }
}
