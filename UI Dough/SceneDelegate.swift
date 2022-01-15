//
//  SceneDelegate.swift
//  UI Dough
//
//  Created by jaeyoung on 2020/05/02.
//  Copyright © 2020 Appcid. All rights reserved.
//

import UIKit
import ACDUIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // tab bar
        /*
        let tabBar = ACDTabBar(buttonBuilder: { () -> ACDButton in
            let button = ACDButton()
            button.normalTintColor = .gray
            button.selectedTintColor = .black
            return button
        })
        tabBar.itemSpacing = 5
        tabBar.preferredSize = .init(width: 100, height: 44)
        
        let tabBarController = ACDTabBarController(tabBar: tabBar)
        tabBarController.tabBarLocation = .top
        tabBarController.viewControllers = [Test1ViewController(),
                                            Test2ViewController()]
        
        window?.rootViewController = tabBarController
        */
        // split view
        
        let splitVC = ACDSplitViewController()
        splitVC.showLeadingView(true)
        splitVC.showTrailingView(true)
        
        splitVC.title = "ACDSplit"
        splitVC.navigationItem.leftBarButtonItem = splitVC.standardLeadingToggleBarButtonItem
        splitVC.navigationItem.rightBarButtonItem = splitVC.standardTrailingToggleBarButtonItem
        
        let cview = UIView()
        cview.backgroundColor = .systemBlue
        let baseView = splitVC.contentView
        baseView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        splitVC.contentView.addSubview(cview)
        cview.translatesAutoresizingMaskIntoConstraints = false
        cview.leadingAnchor.constraint(equalTo: baseView.layoutMarginsGuide.leadingAnchor).isActive = true
        cview.trailingAnchor.constraint(equalTo: baseView.layoutMarginsGuide.trailingAnchor).isActive = true
        cview.topAnchor.constraint(equalTo: baseView.layoutMarginsGuide.topAnchor).isActive = true
        cview.bottomAnchor.constraint(equalTo: baseView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        let nc = UINavigationController(rootViewController: splitVC)
        
        window?.rootViewController = nc
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

