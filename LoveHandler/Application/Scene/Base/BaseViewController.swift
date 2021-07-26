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
        closeButton.tintColor = Theme.current.navigationColor.button
        return closeButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Theme.current.navigationColor.title
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
            if isTitleVisible {
                navigationItem.titleView = titleView
            } else {
                navigationItem.titleView = nil
            }
        }
    }
    
    var isBackButtonVisible: Bool = true {
        didSet {
            if isBackButtonVisible {
                navigationItem.leftBarButtonItem = closeButton
            } else {
                navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    var navigationTitle: String = "" {
        didSet {
            titleLabel.text = navigationTitle
        }
    }
    
    var isKeyboardShow = false

    deinit {
        NotificationCenter.default.removeObserver(self)
        deinitView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = Theme.current.navigationColor.background
        navigationController?.navigationBar.tintColor = Theme.current.navigationColor.button
        navigationController?.navigationBar.barStyle = Theme.current.navigationColor.barStyle
        self.overrideUserInterfaceStyle = .light
        self.navigationController?.overrideUserInterfaceStyle = .light

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeLanguage),
                                               name: NSNotification.Name(Strings.languageChangedObserver),
                                               object: nil)

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
    
    func keyboarDidShow(keyboardHeight: CGFloat) {}
    
    func keyboarDidHide() {}

    func deinitView() {}
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        keyboarDidShow(keyboardHeight: keyboardFrame.size.height + 20)
        isKeyboardShow = true
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        keyboarDidHide()
        isKeyboardShow = false
    }
    
    @objc private func changeLanguage() {
        setupLocalizedString()
    }
}
