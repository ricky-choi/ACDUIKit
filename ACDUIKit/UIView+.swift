//
//  UIView+.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import UIKit

public typealias SelfView = UIView
public typealias SuperView = UIView
public typealias ChildView = UIView

extension UIView {
    public func activateConstraints(_ constraints: (SelfView, SuperView) -> [NSLayoutConstraint]) {
        assert(superview != nil)
        
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(constraints(self, superview))
    }
    
    public func centerToSuperview() {
        activateConstraints {
            [
                $0.centerXAnchor.constraint(equalTo: $1.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor)
            ]
        }
    }
    
    public func fillToSuperview(directionalInsets: NSDirectionalEdgeInsets = .zero) {
        activateConstraints {
            [
                $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor, constant: directionalInsets.leading),
                $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor, constant: -directionalInsets.trailing),
                $0.topAnchor.constraint(equalTo: $1.topAnchor, constant: directionalInsets.top),
                $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor, constant: -directionalInsets.bottom)
            ]
        }
    }
    
    public func fillToSuperviewMargin(directionalInsets: NSDirectionalEdgeInsets = .zero) {
        activateConstraints {
            [
                $0.leadingAnchor.constraint(equalTo: $1.layoutMarginsGuide.leadingAnchor, constant: directionalInsets.leading),
                $0.trailingAnchor.constraint(equalTo: $1.layoutMarginsGuide.trailingAnchor, constant: -directionalInsets.trailing),
                $0.topAnchor.constraint(equalTo: $1.layoutMarginsGuide.topAnchor, constant: directionalInsets.top),
                $0.bottomAnchor.constraint(equalTo: $1.layoutMarginsGuide.bottomAnchor, constant: -directionalInsets.bottom)
            ]
        }
    }
    
    public func fillToSuperviewSafeArea(directionalInsets: NSDirectionalEdgeInsets = .zero) {
        activateConstraints {
            [
                $0.leadingAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.leadingAnchor, constant: directionalInsets.leading),
                $0.trailingAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.trailingAnchor, constant: -directionalInsets.trailing),
                $0.topAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.topAnchor, constant: directionalInsets.top),
                $0.bottomAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.bottomAnchor, constant: -directionalInsets.bottom)
            ]
        }
    }
    
    public func fillSafeAssistance(directionalInsets: NSDirectionalEdgeInsets = .zero) {
        activateConstraints {
            [
                $0.leadingAnchor.constraint(greaterThanOrEqualTo: $1.layoutMarginsGuide.leadingAnchor, constant: directionalInsets.leading),
                $0.trailingAnchor.constraint(lessThanOrEqualTo: $1.layoutMarginsGuide.trailingAnchor, constant: -directionalInsets.trailing),
                $0.topAnchor.constraint(greaterThanOrEqualTo: $1.layoutMarginsGuide.topAnchor, constant: directionalInsets.top),
                $0.bottomAnchor.constraint(lessThanOrEqualTo: $1.layoutMarginsGuide.bottomAnchor, constant: -directionalInsets.bottom)
            ]
        }
    }
    
    public func fit(to size: CGSize, require: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        if require {
            requiredSize()
        }
    }
    
    public func requiredSize() {
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
        
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)

    }
    
}

extension UIView {
    
    @discardableResult
    public func addSubview(constraints: (ChildView, SelfView) -> [NSLayoutConstraint]) -> UIView {
        let childView = ChildView()
        addSubview(childView)
        childView.activateConstraints { return constraints($0, $1) }
        
        return childView
    }
    
    public func addLine(edge: UIRectEdge, color: UIColor, width: CGFloat = 1) {
        if edge.contains(.top) {
            addSubview {
                $0.backgroundColor = color
                return [$0.leftAnchor.constraint(equalTo: $1.leftAnchor),
                        $0.rightAnchor.constraint(equalTo: $1.rightAnchor),
                        $0.topAnchor.constraint(equalTo: $1.topAnchor),
                        $0.heightAnchor.constraint(equalToConstant: width)
                ]
            }
        }
        if edge.contains(.bottom) {
            addSubview {
                $0.backgroundColor = color
                return [$0.leftAnchor.constraint(equalTo: $1.leftAnchor),
                        $0.rightAnchor.constraint(equalTo: $1.rightAnchor),
                        $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),
                        $0.heightAnchor.constraint(equalToConstant: width)
                ]
            }
        }
        if edge.contains(.left) {
            addSubview {
                $0.backgroundColor = color
                return [$0.leftAnchor.constraint(equalTo: $1.leftAnchor),
                        $0.topAnchor.constraint(equalTo: $1.topAnchor),
                        $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),
                        $0.widthAnchor.constraint(equalToConstant: width)
                ]
            }
        }
        if edge.contains(.right) {
            addSubview {
                $0.backgroundColor = color
                return [$0.rightAnchor.constraint(equalTo: $1.rightAnchor),
                        $0.topAnchor.constraint(equalTo: $1.topAnchor),
                        $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),
                        $0.widthAnchor.constraint(equalToConstant: width)
                ]
            }
        }
    }
}
