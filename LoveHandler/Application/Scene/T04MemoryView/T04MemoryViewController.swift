//
//  T04MemoryViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 12/06/2021.
//

import UIKit

class T04MemoryViewController: BaseViewController {
    @IBOutlet weak var bigContainerView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollableContentView: UIView!
    
    override func setupView() {
        setupTransitionAnimation()
        setupTapBackground()
    }
    
    override func setupTheme() {
        super.setupTheme()
        saveButton.backgroundColor = Colors.hotPink
        saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    private func setupTransitionAnimation() {
        saveButton.hero.id = HeroIdentifier.addButtonIdentifier
        bigContainerView.hero.modifiers = [.cornerRadius(10),
                                           .forceAnimate,
                                           .spring(stiffness: 250, damping: 25)]
        backgroundView.hero.modifiers = [.fade]
    }
    
    private func setupTapBackground() {
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    @objc private func onTap() {
        dismiss(animated: true, completion: nil)
    }
}
