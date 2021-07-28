//
//  BaseView.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit

class BaseView: UIView {
    private var didLoad = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObservers()
    }
    
    override func layoutSubviews() {
        if !didLoad {
            setupLocalizedStrings()
            setupTheme()
            didLoad.toggle()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeLanguage),
                                               name: NSNotification.Name(Strings.languageChangedObserver),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeTheme),
                                               name: NSNotification.Name(Strings.themeChangedObserver),
                                               object: nil)
    }
    
    @objc private func changeLanguage() {
        setupLocalizedStrings()
    }
    
    @objc private func changeTheme() {
        setupTheme()
    }
    
    func setupLocalizedStrings() {}
    
    func setupTheme() {}
}
