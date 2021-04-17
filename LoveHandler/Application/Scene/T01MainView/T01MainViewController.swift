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
    
    
    @IBOutlet weak var firstLoverView: PersonView!
    @IBOutlet weak var secondLoverView: PersonView!
    @IBOutlet weak var loveButton: UIButton!
    
    override func setupView() {
        super.setupView()
        setUpLover()
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
    
    private func setUpLover() {
        firstLoverView.person = Person(name: "Tri TriTriTriTriTriTri", gender: .male, dateOfBirth: Date())
        secondLoverView.person = Person(name: "Lan", gender: .female, dateOfBirth: Date())
    }
}
