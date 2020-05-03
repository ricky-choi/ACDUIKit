//
//  ACDButton.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import UIKit

open class ACDButton: UIButton, HitExpandable {

    public var useTemplateImage: Bool = false
    
    open var normalTintColor: UIColor?
    open var selectedTintColor: UIColor?
    
    public var titleFont: UIFont? {
        didSet {
            titleLabel?.font = titleFont
        }
    }
    
    public var buttonColor: UIColor? {
        didSet {
            if buttonColorDisabled == nil {
                buttonColorDisabled = buttonColor
            }
            invalidateColors()
        }
    }
    public var buttonColorDisabled: UIColor? {
        didSet {
            invalidateColors()
        }
    }
    public var buttonColorHighlighted: UIColor? {
        didSet {
            invalidateColors()
        }
    }
    
    public var borderColor: UIColor? {
        didSet {
            if borderColorDisabled == nil {
                borderColorDisabled = borderColor
            }
            invalidateColors()
        }
    }
    public var borderColorDisabled: UIColor? {
        didSet {
            invalidateColors()
        }
    }
    
    public var preferredSize: CGSize?
    
    public var imageTitleInset: CGFloat = 0 {
        didSet {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageTitleInset)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleInset, bottom: 0, right: 0)
        }
    }

    public required init() {
        super.init(frame: .zero)
        
        invalidateColors()
        
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        
    }
    
    open override func setImage(_ image: UIImage?, for state: UIControl.State) {
        if useTemplateImage {
            super.setImage(image?.withRenderingMode(.alwaysTemplate), for: state)
        } else {
            super.setImage(image, for: state)
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            if isSelected, let selectedColor = selectedTintColor {
                tintColor = selectedColor
                setTitleColor(selectedColor, for: .selected)
            } else if let normalColor = normalTintColor {
                tintColor = normalColor
                setTitleColor(normalColor, for: .normal)
            }
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            invalidateColors()
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            invalidateColors()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        
        if let size = preferredSize {
            return CGSize.full(size, defaultSize)
        } else {
            return defaultSize
        }
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        let defaultSize = super.sizeThatFits(size)
        
        if let size = preferredSize {
            return CGSize.full(size, defaultSize)
        } else {
            return defaultSize
        }
    }
    
    private func invalidateColors() {
        if borderColor != nil {
            layer.borderWidth = 1
        } else {
            layer.borderWidth = 0
        }
        
        if isEnabled {
            if isHighlighted, let highlightedColor = buttonColorHighlighted {
                backgroundColor = highlightedColor
            } else {
                backgroundColor = buttonColor
            }
            
            layer.borderColor = borderColor?.cgColor
        } else {
            backgroundColor = buttonColorDisabled
            layer.borderColor = borderColorDisabled?.cgColor
        }
    }
    
    // MARK: - HitExpandable
    
    public var isExpandHitArea: Bool = false
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isExpandHitArea, containsInExpandedBounds(point: point) {
            return self
        }
        
        return super.hitTest(point, with: event)
    }
}
