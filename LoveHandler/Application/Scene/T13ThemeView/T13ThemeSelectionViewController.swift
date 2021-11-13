//
//  T13ThemeSelectionViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 28/07/2021.
//

import UIKit

class T13ThemeSelectionViewController: BaseViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var pageController: CustomPageControl!
    @IBOutlet weak var themeImageView: UIImageView!
    
    override func setupView() {
        isBackButtonVisible = false
        isTitleVisible = true
        
        themeImageView.viewCornerRadius = 20
        
        setupPageController()
        addGestureRecognizers()
    }
    
    override func setupTheme() {
        super.setupTheme()
        backgroundView.backgroundColor = Theme.current.tableViewColor.background
        themeImageView.backgroundColor = Theme.current.navigationColor.background
    }
    
    private func setupPageController() {
        pageController.initView(numberOfPages: Theme.allCases.count,
                                currentPage: Settings.themeId.value)
    }
    
    private func addGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        themeImageView.isUserInteractionEnabled = true
        themeImageView.addGestureRecognizer(swipeLeft)
        themeImageView.addGestureRecognizer(swipeRight)
    }
    private func swipeDownToDismiss(isEnabled: Bool) {
        navigationController?.presentationController?.presentedView?.gestureRecognizers?.forEach({$0.isEnabled = isEnabled})
    }
    
    @objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .began {
            swipeDownToDismiss(isEnabled: false)
        }
        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.left:
            pageController.move(to: .left)
        case UISwipeGestureRecognizer.Direction.right:
            pageController.move(to: .right)
        default:
            break
        }
        
        Theme.post(themeId: pageController.currentPage)
        
        if sender.state == .ended {
            swipeDownToDismiss(isEnabled: true)
        }
    }
}
