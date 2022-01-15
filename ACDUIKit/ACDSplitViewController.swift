//
//  ACDSplitViewController.swift
//  ACDUIKit
//
//  Created by Jaeyoung Choi on 2022/01/14.
//  Copyright © 2022 Appcid. All rights reserved.
//

import UIKit

public class ACDSplitViewController: UIViewController {
    
    public let contentView = UIView()
    
    public let leadingContentView = UIView()
    
    public let trailingContentView = UIView()
    
    
    private var isShowLeadingView: Bool = false {
        didSet { invalidateViewLayout(animated: true) }
    }
    
    private var shouldShowLeadingView: Bool {
        return true
    }
    
    @discardableResult
    public func showLeadingView(_ show: Bool) -> Bool {
        isShowLeadingView = show && shouldShowLeadingView
        return isShowLeadingView
    }
    
    @discardableResult
    public func toggleLeadingView() -> Bool {
        showLeadingView(!isShowLeadingView)
    }
    
    
    private var isShowTrailingView: Bool = false {
        didSet { invalidateViewLayout(animated: true) }
    }
    
    private var shouldShowTrailingView: Bool {
        return true
    }
    
    @discardableResult
    public func showTrailingView(_ show: Bool) -> Bool {
        isShowTrailingView = show && shouldShowTrailingView
        return isShowTrailingView
    }
    
    @discardableResult
    public func toggleTrailingView() -> Bool {
        showTrailingView(!isShowTrailingView)
    }
    
    
    public var leadingViewWidth: CGFloat = 300 {
        didSet { invalidateViewLayout(animated: true) }
    }
    
    public var trailingViewWidth: CGFloat = 300 {
        didSet { invalidateViewLayout(animated: true) }
    }
    
    public var minimumContentViewWidth: CGFloat = 400 {
        didSet { invalidateViewLayout(animated: true) }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = .systemBackground
        leadingContentView.backgroundColor = .secondarySystemBackground
        trailingContentView.backgroundColor = .secondarySystemBackground

        view.addSubview(contentView)
        
        view.addSubview(leadingContentView)
        
        view.addSubview(trailingContentView)
        
        invalidateViewLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        invalidateViewLayout()
    }
    
    public func invalidateViewLayout(animated: Bool = false) {
        guard isViewLoaded else { return }
        
        let viewWidth: CGFloat = view.bounds.width
        let viewHeight: CGFloat = view.bounds.height
        
        let leadingContentViewFrame: CGRect
        let trailingContentViewFrame: CGRect
        let contentViewFrame: CGRect
        
        // leading view
        
        let leadingViewSize = CGSize(width: leadingViewWidth, height: viewHeight)
        
        if isShowLeadingView {
            leadingContentViewFrame = CGRect(origin: .zero, size: leadingViewSize)
        } else {
            leadingContentViewFrame = CGRect(origin: CGPoint(x: -leadingViewWidth, y: 0), size: leadingViewSize)
        }
        
        // trailing view
        
        let trailingViewSize = CGSize(width: trailingViewWidth, height: viewHeight)
        
        if isShowTrailingView {
            trailingContentViewFrame = CGRect(origin: CGPoint(x: viewWidth - trailingViewWidth, y: 0), size: trailingViewSize)
        } else {
            trailingContentViewFrame = CGRect(origin: CGPoint(x: viewWidth, y: 0), size: trailingViewSize)
        }
        
        // content view
        
        switch (isShowLeadingView, isShowTrailingView) {
        case (false, false):
            contentViewFrame = view.bounds
        case (true, false):
            contentViewFrame = CGRect(x: leadingViewWidth, y: 0, width: viewWidth - leadingViewWidth, height: viewHeight)
        case (false, true):
            contentViewFrame = CGRect(x: 0, y: 0, width: viewWidth - trailingViewWidth, height: viewHeight)
        case (true, true):
            contentViewFrame = CGRect(x: leadingViewWidth, y: 0, width: viewWidth - leadingViewWidth - trailingViewWidth, height: viewHeight)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.leadingContentView.frame = leadingContentViewFrame
                self.trailingContentView.frame = trailingContentViewFrame
                self.contentView.frame = contentViewFrame
            }
        } else {
            leadingContentView.frame = leadingContentViewFrame
            trailingContentView.frame = trailingContentViewFrame
            contentView.frame = contentViewFrame
        }
    }
}

extension ACDSplitViewController {
    public var standardLeadingToggleBarButtonItem: UIBarButtonItem {
        .init(title: "Toggle Leading Sidabar", image: .init(systemName: "sidebar.leading"), primaryAction: .init(handler: { [weak self] _ in
            self?.toggleLeadingView()
        }), menu: nil)
    }
    
    public var standardTrailingToggleBarButtonItem: UIBarButtonItem {
        .init(title: "Toggle Trailing Sidebar", image: .init(systemName: "sidebar.trailing"), primaryAction: .init(handler: { [weak self] _ in
            self?.toggleTrailingView()
        }), menu: nil)
    }
}
