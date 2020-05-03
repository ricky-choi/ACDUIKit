//
//  Test2ViewController.swift
//  UI Dough
//
//  Created by jaeyoung on 2020/05/03.
//  Copyright © 2020 Appcid. All rights reserved.
//

import UIKit
import ACDUIKit

class Test2ViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        _setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        _setup()
    }
    
    private func _setup() {
        tabBarItem = UITabBarItem(title: "Person", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        
        let safeView = UIView()
        safeView.backgroundColor = .systemBackground
        view.addSubview(safeView)
        safeView.fillToSuperviewSafeArea()
    }

}
