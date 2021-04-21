//
//  BaseNavigationController.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

class BaseNavigationController: UINavigationController {
    private var statusBarStyle: UIStatusBarStyle = .default
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        setupView()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupView()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
