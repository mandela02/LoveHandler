//
//  BaseViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocalizedString()
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
}
