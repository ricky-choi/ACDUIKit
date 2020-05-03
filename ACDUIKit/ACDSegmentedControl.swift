//
//  ACDSegmentedControl.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import UIKit

public protocol HasTitleAndImage {
    var title: String? { get }
    var image: UIImage? { get }
}

struct TitleAndImage: HasTitleAndImage {
    var title: String?
    var image: UIImage?
}

public protocol ACDSegmentedControlProtocol_ {
    var isMomentary: Bool { get set }
    var numberOfSegments: Int { get }
    var selectedSegmentIndex: Int { get set }
    
    func insertSegment(withTitle title: String?, at segment: Int, animated: Bool)
    func insertSegment(with image: UIImage?, at segment: Int, animated: Bool)
    func removeSegment(at segment: Int, animated: Bool)
    func removeAllSegments()
}
public typealias ACDSegmentedControlProtocol = ACDSegmentedControlProtocol_ & UIControl

open class ACDSegmentedControl: UIControl {

    var _stackView: ACDStackView!
        
    open var isMomentary: Bool = false
    
    public var numberOfSegments: Int {
        _stackView.numberOfItems
    }
    
    open var selectedSegmentIndex: Int = -1 {
        didSet {
            invalidateButtonsSelected()
            
            if oldValue != selectedSegmentIndex {
                sendActions(for: .valueChanged)
            }
        }
    }
    
    open func insertSegment(withTitle title: String?, at segment: Int, animated: Bool) {
        insertSegment(withTitleAndImage: TitleAndImage(title: title), at: segment, animated: animated)
    }

    open func insertSegment(with image: UIImage?, at segment: Int, animated: Bool) {
        insertSegment(withTitleAndImage: TitleAndImage(image: image), at: segment, animated: animated)
    }

    open func removeSegment(at segment: Int, animated: Bool) {
        _stackView.removeArrangedSubview(at: segment, animated: animated)
    }
    
    open func removeAllSegments() {
        _stackView.cleanup()
    }
    
    open func insertSegment(withTitleAndImage titleAndImage: HasTitleAndImage?, at segment: Int, animated: Bool) {
        let button = makeButton(titleAndImage: titleAndImage)
        
        _stackView.insertArrangedSubview(button, at: segment)
        
        if segment <= selectedSegmentIndex {
            selectedSegmentIndex += 1
        }
    }
    
    open func setSegment(withTitleAndImages titleAndImages: [HasTitleAndImage], animated: Bool) {
        removeAllSegments()
        
        for (i, titleAndImage) in titleAndImages.enumerated() {
            insertSegment(withTitleAndImage: titleAndImage, at: i, animated: animated)
        }
    }
    
    // MARK: - Stack View Properties
    
    public var alignment: UIStackView.Alignment {
        get {
            _stackView.alignment
        }
        set {
            _stackView.alignment = newValue
        }
    }
    
    public var axis: NSLayoutConstraint.Axis {
        get {
            _stackView.axis
        }
        set {
            _stackView.axis = newValue
        }
    }
    
    public var distribution: UIStackView.Distribution {
        get {
            _stackView.distribution
        }
        set {
            _stackView.distribution = newValue
        }
    }
    
    public var spacing: CGFloat {
        get {
            _stackView.spacing
        }
        set {
            _stackView.spacing = newValue
        }
    }
    
    // MARK: - init
    
    private let makeButtonClosure: () -> ACDButton
    
    convenience public init(items: [Any]?, buttonBuilder: @escaping () -> ACDButton) {
        if let strings = items as? [String] {
            self.init(strings: strings, buttonBuilder: buttonBuilder)
        } else if let images = items as? [UIImage] {
            self.init(images: images, buttonBuilder: buttonBuilder)
        } else if let titleAndImage = items as? [HasTitleAndImage] {
            self.init(titleAndImages: titleAndImage, buttonBuilder: buttonBuilder)
        } else {
            self.init(buttonBuilder: buttonBuilder)
        }
    }
    
    convenience public init(buttonBuilder: @escaping () -> ACDButton) {
        self.init(titleAndImages: [], buttonBuilder: buttonBuilder)
    }
    
    convenience public init(strings: [String], buttonBuilder: @escaping () -> ACDButton) {
        self.init(titleAndImages: strings.map ({ TitleAndImage(title: $0, image: nil)}), buttonBuilder: buttonBuilder)
    }
    
    convenience public init(images: [UIImage], buttonBuilder: @escaping () -> ACDButton) {
        self.init(titleAndImages: images.map ({ TitleAndImage(title: nil, image: $0)}), buttonBuilder: buttonBuilder)
    }
    
    public init(titleAndImages: [HasTitleAndImage], buttonBuilder: @escaping () -> ACDButton) {
        makeButtonClosure = buttonBuilder
        
        super.init(frame: .zero)
        
        let buttons: [UIButton] = titleAndImages.map { makeButton(titleAndImage: $0) }
        
        _stackView = ACDStackView(arrangedSubviews: buttons)
        
        if !titleAndImages.isEmpty {
            selectedSegmentIndex = 0
        }
        
        addSubview(_stackView)
        _stackView.fillToSuperview()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateButtonsSelected()
    }
    
    private func makeButton(titleAndImage: HasTitleAndImage?) -> ACDButton {
        let button = makeButtonClosure()
        
        button.setTitle(titleAndImage?.title, for: .normal)
        button.setImage(titleAndImage?.image, for: .normal)
        
        if let tabBarItem = titleAndImage as? UITabBarItem {
            button.setImage(tabBarItem.selectedImage, for: .selected)
        }
        
        button.addAction(for: .touchUpInside) {
            self.buttonTouched(button: button)
        }
        return button
    }
    
    private func invalidateButtonsSelected() {
        guard !isMomentary else {
            return
        }
        
        for (i, view) in _stackView.arrangedSubviews.enumerated() {
            let button = view as! UIButton
            button.isSelected = i == selectedSegmentIndex
        }
    }
    
    private func buttonTouched(button: UIButton) {
        if let index = _stackView.arrangedSubviews.firstIndex(of: button) {
            selectedSegmentIndex = index
        }
    }

}

extension UITabBarItem: HasTitleAndImage {}

extension ACDSegmentedControl: ACDSegmentedControlProtocol_ {}
extension UISegmentedControl: ACDSegmentedControlProtocol_ {}
