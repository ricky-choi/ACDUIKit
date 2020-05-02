//
//  CGGeometry+.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension CGSize {
    public static func pack(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        return CGSize(width: min(lhs.width, rhs.width), height: min(lhs.height, rhs.height))
    }
    
    public static func full(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        return CGSize(width: max(lhs.width, rhs.width), height: max(lhs.height, rhs.height))
    }
    
    public mutating func addWidth(_ value: CGFloat) {
        width = width + value
    }
    
    public mutating func addHeight(_ value: CGFloat) {
        height = height + value
    }
    
    public func reduce(by inset: UIEdgeInsets) -> CGSize {
        CGSize(width: width - inset.left - inset.right, height: height - inset.top - inset.bottom)
    }
    
    public static func *(lhs: CGSize, scale: CGFloat) -> CGSize {
        CGSize(width: lhs.width * scale, height: lhs.height * scale)
    }
}

extension CGSize {
    public func scaleAspectFit(to size: CGSize) -> CGFloat {
        let widthScale = size.width / width
        let heightScale = size.height / height
        return min(widthScale, heightScale)
    }
}

extension CGPoint {
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

extension CGRect {
    public func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge, padding: CGFloat = 1) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width - padding
        case .minYEdge, .maxYEdge:
            dimension = self.size.height - padding
        }
        
        let distance = (dimension * fraction).rounded(.up)
        var slices = self.divided(atDistance: distance, from: fromEdge)
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += padding
            slices.remainder.size.width -= padding
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += padding
            slices.remainder.size.height -= padding
        }
        
        return (first: slices.slice, second: slices.remainder)
    }
    
    public func dividedIntegral(numerator: Int, denominator: Int, from fromEdge: CGRectEdge, padding: CGFloat = 1) -> (first: CGRect, second: CGRect) {
        assert(denominator > 1)
        assert(numerator > 0)
        assert(numerator <= denominator)
        
        let dimension: CGFloat
        let numberOfPadding = denominator - 1
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width - padding * CGFloat(numberOfPadding)
        case .minYEdge, .maxYEdge:
            dimension = self.size.height - padding * CGFloat(numberOfPadding)
        }
        
        let fraction: CGFloat = CGFloat(numerator) / CGFloat(denominator)
        
        let distance = (dimension * fraction).rounded(.up) + padding * CGFloat(numerator - 1)
        var slices = self.divided(atDistance: distance, from: fromEdge)
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += padding
            slices.remainder.size.width -= padding
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += padding
            slices.remainder.size.height -= padding
        }
        
        return (first: slices.slice, second: slices.remainder)
    }
}

