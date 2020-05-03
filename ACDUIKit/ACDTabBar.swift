//
//  ACDTabBar.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import UIKit

public protocol ACDTabBarProtocol_ {
    var items: [UITabBarItem]? { get set }
    var selectedItem: UITabBarItem? { get set }
    func setItems(_ items: [UITabBarItem]?, animated: Bool)
    
    var isTranslucent: Bool { get set }
    var itemSpacing: CGFloat { get set }
}

public typealias ACDTabBarProtocol = ACDTabBarProtocol_ & UIView

open class ACDTabBar: UIView {

    // MARK: - GLTTabBarProtocol
    weak open var delegate: ACDTabBarDelegate?
    open var items: [UITabBarItem]? {
        get {
            return _items
        }
        set {
            setItems(newValue, animated: false)
        }
    }
    weak open var selectedItem: UITabBarItem? {
        get {
            return _selectedItem
        }
        set {
            _selectedItem = newValue
        }
    }
    
    // will fade in or out or reorder and adjust spacing
    open func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        _items = items
        _selectedItem = items?.first
        
        guard let items = items else {
            return
        }
        
        segmentedControl.setSegment(withTitleAndImages: items, animated: animated)
    }
    
    open var barTintColor: UIColor?
    @NSCopying open var unselectedItemTintColor: UIColor? // <-> tintColor
    
    open var isTranslucent: Bool = true
    
    public var itemSpacing: CGFloat {
        get {
            segmentedControl.spacing
        }
        set {
            segmentedControl.spacing = newValue
        }
    }
    
    public var alignment: UIStackView.Alignment {
        get {
            segmentedControl.alignment
        }
        set {
            segmentedControl.alignment = newValue
        }
    }
    
    public var axis: NSLayoutConstraint.Axis {
        get {
            segmentedControl.axis
        }
        set {
            segmentedControl.axis = newValue
        }
    }
    
    public var distribution: UIStackView.Distribution {
        get {
            segmentedControl.distribution
        }
        set {
            segmentedControl.distribution = newValue
        }
    }
    
    // MARK: -
    open var preferredSize: CGSize = CGSize(width: 55, height: 55)
    
    private var _items: [UITabBarItem]?
    private weak var _selectedItem: UITabBarItem? {
        willSet {
            _oldSelectedItem = _selectedItem
        }
        didSet {
            if let item = _selectedItem, let index = _items?.firstIndex(of: item) {
                segmentedControl.selectedSegmentIndex = index
            }
        }
    }
    
    private weak var _oldSelectedItem: UITabBarItem?
    
    func undoSelectedItem() {
        _selectedItem = _oldSelectedItem
    }
        
    public private(set) lazy var segmentedControl = ACDSegmentedControl(buttonBuilder: makeButtonClosure)
    
    private let makeButtonClosure: () -> ACDButton
    
    public init(buttonBuilder: @escaping () -> ACDButton) {
        makeButtonClosure = buttonBuilder
        
        super.init(frame: .zero)
        
        segmentedControl.addAction(for: .valueChanged) { [weak self] in
            guard let self = self else { return }
            
            guard let items = self._items else { return }
            
            let index = self.segmentedControl.selectedSegmentIndex
            guard index < self.segmentedControl.numberOfSegments else { return }
            
            let tabBarItem = items[index]
            
            self._selectedItem = tabBarItem
            
            self.delegate?.tabBar?(self, didSelect: tabBarItem)
        }
        
        addSubview(segmentedControl)
        segmentedControl.centerToSuperview()
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event), hitView === self {
            return nil
        }
        
        return super.hitTest(point, with: event)
    }

}

@objc public protocol ACDTabBarDelegate : NSObjectProtocol {
    @objc optional func tabBar(_ tabBar: ACDTabBar, didSelect item: UITabBarItem) // called when a new view is selected by the user (but not programatically)
}

extension ACDTabBar: ACDTabBarProtocol_ {}
extension UITabBar: ACDTabBarProtocol_ {}
