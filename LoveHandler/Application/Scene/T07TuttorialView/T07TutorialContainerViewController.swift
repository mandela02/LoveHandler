//
//  T07TutorialContainerViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 28/06/2021.
//

import UIKit

class T07TutorialContainerViewController: BaseViewController {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    override func setupView() {
        super.setupView()
        navigationController?.setNavigationBarHidden(true, animated: true)
        backgroundImageView.image = ImageNames.love1.image
    }
    
    override func setupTheme() {
        super.setupTheme()
        skipButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .disabled)
        nextButton.backgroundColor = Colors.deepPink
    }
}
