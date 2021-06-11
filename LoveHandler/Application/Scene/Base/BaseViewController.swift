//
//  BaseViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(image: SystemImage.xMark.image,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        closeButton.tintColor = UIColor.white
        return closeButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()

    private lazy var titleView: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.layoutIfNeeded()
        view.sizeToFit()
        
        return view
    }()
    
    var isTitleVisible: Bool = true {
        didSet {
            navigationItem.titleView = titleView
        }
    }
    
    var isBackButtonVisible: Bool = true {
        didSet {
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    var navigationTitle: String = "" {
        didSet {
            titleLabel.text = navigationTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = Colors.deepPink
        self.overrideUserInterfaceStyle = .light
        self.navigationController?.overrideUserInterfaceStyle = .light

        setupView()
        setupLocalizedString()
        setupTheme()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissView()
    }
    
    func setupView() {}
    
    func refreshView() {}
    
    func dismissView() {}
    
    func setupLocalizedString() {}
    
    func setupTheme() {}
    
    func bindViewModel() {}
}
