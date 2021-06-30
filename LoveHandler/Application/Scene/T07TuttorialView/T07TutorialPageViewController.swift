//
//  T07TutorialPageViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 28/06/2021.
//

import UIKit
import Combine

class T07TutorialPageViewController: UIPageViewController {
    lazy private var firstViewController: UIViewController = {
        let viewController = T07TuttorialViewController.instantiateFromStoryboard()
        viewController.tutorialStep = .firstStep
        return viewController
    }()

    lazy private var secondViewController: UIViewController = {
        let viewController = T07TuttorialViewController.instantiateFromStoryboard()
        viewController.tutorialStep = .secondStep
        return viewController
    }()

    var index = 1
    var currentViewController: UIViewController?
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        self.setViewControllers([firstViewController],
                                direction: .forward,
                                animated: true,
                                completion: nil)
        currentViewController = firstViewController
        for view in self.view.subviews where view is UIScrollView {
            if let view = view as? UIScrollView {
                view.isScrollEnabled = false
            }
        }
    }
    
    func goToNextPage() {
        guard let currentViewController = currentViewController as? T07TuttorialViewController else { return }
        
        if currentViewController.tutorialStep == .firstStep {
            self.setViewControllers([secondViewController],
                                    direction: .forward,
                                    animated: true,
                                    completion: nil)
            self.currentViewController = secondViewController
            for view in self.view.subviews where view is UIScrollView {
                if let view = view as? UIScrollView {
                    view.isScrollEnabled = true
                }
            }
            
            if let firstViewController = firstViewController as? T07TuttorialViewController {
                firstViewController.savedPerson.save(forKey: .you)
            }
            
        } else {
            UIAlertController.alertDialog(title: "Your sure?",
                                          message: "last chance",
                                          argument: 0)
                .sink(receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    if let firstViewController = self.firstViewController as? T07TuttorialViewController {
                        firstViewController.savedPerson.save(forKey: .you)
                    }
                    if let secondViewController = self.secondViewController as? T07TuttorialViewController {
                        secondViewController.savedPerson.save(forKey: .soulmate)
                    }
                    Settings.isCompleteSetting.value = true
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    appDelegate.navigator?.setRootViewController()
                })
                .store(in: &cancellables)
        }
        
    }
}

extension T07TutorialPageViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return index - 1
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentViewController = self.viewControllers?.first
        }
    }
    
}

extension T07TutorialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? T07TuttorialViewController {
            if viewController.tutorialStep == .firstStep { return nil }
            return firstViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? T07TuttorialViewController {
            if viewController.tutorialStep == .secondStep { return nil }
            return secondViewController
        }
        return nil
    }
}
