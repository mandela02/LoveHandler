//
//  T07TutorialContainerViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 28/06/2021.
//

import UIKit
import Combine

class T07TutorialContainerViewController: BaseViewController {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var pageViewController: T07TutorialPageViewController?
    private var cancellables = Set<AnyCancellable>()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == T07TutorialPageViewController.className, let viewController = segue.destination as? T07TutorialPageViewController {
            self.pageViewController = viewController
        }
    }
    
    override func setupView() {
        super.setupView()
        navigationController?.setNavigationBarHidden(true, animated: true)
        backgroundImageView.image = ImageNames.love1.image

    }
    
    override func bindViewModel() {
        super.bindViewModel()
        nextButton.tapPublisher.sink { [weak self] _ in
            self?.pageViewController?.goToNextPage()
        }
        .store(in: &cancellables)
    }
    
    override func dismissView() {
        super.dismissView()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setupTheme() {
        super.setupTheme()
        skipButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .disabled)
        nextButton.backgroundColor = Colors.deepPink
    }
}
