//
//  UIControl+.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import UIKit


fileprivate final class ClosureSleeve {
    let closure: () -> Void
    
    init (_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    public func addAction(for controlEvents: UIControl.Event, _ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
