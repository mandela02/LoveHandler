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
        pageViewController?.currentIndex.sink(receiveValue: { [weak self] index in
            guard let self = self else { return }
            let title = index == 3 ? "Complete" : "Next"
            self.nextButton.setTitle(title, for: .normal)
        })
        .store(in: &cancellables)

        nextButton.tapPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            self.pageViewController?.goToNextPage()
        }
        .store(in: &cancellables)

        skipButton.tapPublisher.flatMap { _ in
            UIAlertController.alertDialog(title: "Your sure?",
                                          message: "last chance",
                                          argument: 0)
        }
        .sink(receiveValue: { option in
            if option == nil { return }
            Person().save(forKey: .you)
            Person().save(forKey: .soulmate)
            Settings.isCompleteSetting.value = true
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.navigator?.setRootViewController()
        })
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
