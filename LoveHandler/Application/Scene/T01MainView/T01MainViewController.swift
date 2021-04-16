//
//  T01MainViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

class T01MainViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var diaryButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var heartView: HeartView!
    
    @IBOutlet weak var imageBackgroundView: UIImageView!
    @IBOutlet weak var defaultBackgroundView: UIView!
    
    override func setupView() {
        super.setupView()
    }
    
    override func refreshView() {
        super.refreshView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func dismissView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setupLocalizedString() {
        titleLabel.text = "Từng ngày bên nhau"
    }
}
