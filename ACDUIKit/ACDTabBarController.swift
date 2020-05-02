//
//  ACDTabBarController.swift
//  ACDUIKit
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import UIKit

public protocol ACDTabBarControllerProtocol_ {
    var viewControllers: [UIViewController]? { get set }
    func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool)
    var selectedViewController: UIViewController? { get set }
    var selectedIndex: Int { get set }
}

public typealias ACDTabBarControllerProtocol = ACDTabBarControllerProtocol_ & UIViewController

open class ACDTabBarController: UIViewController {

    private var _viewControllers: [UIViewController]?
    
    open var viewControllers: [UIViewController]? {
        get {
            _viewControllers
        }
        set {
            setViewControllers(newValue, animated: false)
        }
    }
    
    open func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        tabBar.setItems(viewControllers?.map({ $0.tabBarItem }), animated: animated)
        
        _viewControllers = viewControllers
        selectedViewController = viewControllers?.first
    }
    
    open override var canBecomeFirstResponder: Bool {
        true
    }
    
    open override var keyCommands: [UIKeyCommand]? {
        var modifierFlags = UIKeyModifierFlags.command
        
        #if targetEnvironment(simulator)
        modifierFlags = .numericPad
        #endif
        
        return viewControllers?.enumerated().map({ (i, vc) -> UIKeyCommand in
            let command = UIKeyCommand(input: "\(i+1)", modifierFlags: modifierFlags, action: #selector(commandSelector(_:)))
            command.discoverabilityTitle = vc.title
            return command
        })
    }
    
    @objc func commandSelector(_ sender: UIKeyCommand) {
        guard let inputString = sender.input, let inputNumber = Int(inputString) else {
            return
        }
        
        let inputIndex = inputNumber - 1
        
        if let targetVC = viewControllers?[inputIndex] {
            selectedViewController = targetVC
        }
        
    }
    
    unowned(unsafe) open var selectedViewController: UIViewController? {
        didSet {
            oldValue?.remove()
            
            if let newVC = selectedViewController {
                addNewViewController(newVC, targetView: _contentView)
            }
            
            invalidateTabBarIndex()
            invalidateTabBarAutoHide()
            
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    open var selectedIndex: Int {
        get {
            if let current = selectedViewController, let index = _viewControllers?.firstIndex(of: current) {
                return index
            }
            
            return -1
        }
        set {
            guard let vcs = viewControllers, (0..<vcs.count).contains(newValue) else {
                return
            }
            
            selectedViewController = vcs[newValue]
        }
    }
    
    public let tabBar: ACDTabBar
    
    public weak var delegate: ACDTabBarControllerDelegate?
        
    public init(tabBar: ACDTabBar) {
        self.tabBar = tabBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let _contentView = UIView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        _contentView.backgroundColor = .systemBackground
        view.addSubview(_contentView)
        _contentView.fillToSuperview()

        tabBar.delegate = self
        view.addSubview(tabBar)
        
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBar.preferredSize.height, right: 0)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBarHidden(false, animated: false)
    }
    
    private func invalidateTabBarIndex() {
        tabBar.segmentedControl.selectedSegmentIndex = selectedIndex
    }
    
    private func viewController(for item: UITabBarItem) -> UIViewController? {
        viewControllers?.first {
            $0.tabBarItem == item
        }
    }
    
    // MARK: -
    
    private var bottomSafeAreaInset: CGFloat = -1
    
    private var _isTabBarBarHidden: Bool = false
    public var isTabBarBarHidden: Bool {
        get {
            _isTabBarBarHidden
        }
        set {
            setTabBarHidden(newValue, animated: false)
        }
    }
    
    public func setTabBarHidden(_ hidden: Bool, animated: Bool, duration: TimeInterval = 0.2) {
        
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                self.makeCustomTabBarBarHidden(hidden)
            }) { (_) in
                
            }
        } else {
            makeCustomTabBarBarHidden(hidden)
        }
    }
    
    private func invalidateCustomTabBar() {
        guard bottomSafeAreaInset >= 0 else {
            return
        }
        
        makeCustomTabBarBarHidden(isTabBarBarHidden)
    }
    
    private func makeCustomTabBarBarHidden(_ isHidden: Bool) {
        
        _isTabBarBarHidden = isHidden
        
        let customtabBarHeight = tabBar.preferredSize.height
        let tabBarHeight = bottomSafeAreaInset + customtabBarHeight
        let tabBarFrame: CGRect
        
        if isHidden {
            tabBarFrame = CGRect(x: 0, y: view.bounds.height, width: view.frame.width, height: customtabBarHeight)
        } else {
            tabBarFrame = CGRect(x: 0, y: view.bounds.height - tabBarHeight, width: view.frame.width, height: customtabBarHeight)
        }
        
        tabBar.frame = tabBarFrame
        tabBar.alpha = isHidden ? 0 : 1
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let window = view.window else {
            return
        }
        
        bottomSafeAreaInset = window.safeAreaInsets.bottom
        invalidateCustomTabBar()
    }
    
    // MARK: -
    
    public var hidesBarsOnScroll: Bool = true {
        didSet {
            invalidateTabBarAutoHide()
        }
    }
    
    private var observation: NSKeyValueObservation?
    
    public func invalidateTabBarAutoHide() {
        guard
            hidesBarsOnScroll,
            let currentViewController = selectedViewController?.contentViewController as? (Scrollable & UIViewController),
            currentViewController.isViewLoaded,
            let scrollView = currentViewController.mainScrollView,
            scrollView.contentSize.height > currentViewController.view.bounds.height
            else {
                
            setTabBarHidden(false, animated: false)
            return
        }
        
        let pan = scrollView.panGestureRecognizer
        pan.addTarget(self, action: #selector(contentViewScrolled(_:)))
        
        observation = scrollView.observe(\.contentOffset, changeHandler: { [weak self] (scrollView, _) in
            guard let self = self else { return }
            
            // 맨 아래 또는 맨 위로 이동하면 탭바는 다시 보여집니다.
            if scrollView.contentBottomRemain <= 10 || scrollView.contentUserInteractionOffset.y <= 0 {
                self.setTabBarHidden(false, animated: true)
            }
        })
    }
    
    @objc func contentViewScrolled(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            let velocity = recognizer.velocity(in: view).y
            guard velocity.magnitude > 500 else {
                break
            }
            if velocity > 0 {
                setTabBarHidden(false, animated: true)
            } else if velocity < 0 {
                setTabBarHidden(true, animated: true)
            }
        default:
            break
        }
    }
}

extension ACDTabBarController: ACDTabBarDelegate {
    public func tabBar(_ tabBar: ACDTabBar, didSelect item: UITabBarItem) {
        guard let selectedVC = viewController(for: item) else {
            return
        }
        
        if selectedViewController != selectedVC {
            let change = delegate?.tabBarController?(self, shouldSelect: selectedVC) ?? true
            
            guard change else {
                // change to before state
                tabBar.undoSelectedItem()
                return
            }
            
            selectedViewController = selectedVC
        } else {
            // select same item
            if let nc = selectedViewController as? UINavigationController, nc.viewControllers.count > 1 {
                nc.popToRootViewController(animated: true)
            } else {
                (selectedViewController?.contentViewController as? Scrollable)?.mainScrollView?.showOrigin()
            }
        }
        
        delegate?.tabBarController?(self, didSelect: selectedVC)
    }
}

@objc public protocol ACDTabBarControllerDelegate : NSObjectProtocol {
    @objc optional func tabBarController(_ tabBarController: ACDTabBarController, shouldSelect viewController: UIViewController) -> Bool
    @objc optional func tabBarController(_ tabBarController: ACDTabBarController, didSelect viewController: UIViewController)
}

extension ACDTabBarController: ACDTabBarControllerProtocol_ {}
extension UITabBarController: ACDTabBarControllerProtocol_ {}
