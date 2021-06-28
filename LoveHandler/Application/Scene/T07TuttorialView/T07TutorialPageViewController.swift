//
//  T07TutorialPageViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 28/06/2021.
//

import UIKit

class T07TutorialPageViewController: UIPageViewController {
    lazy var firstViewController: UIViewController = {
        let viewController = T07TuttorialViewController.instantiateFromStoryboard()
        viewController.tutorialStep = .firstStep
        return viewController
    }()

    lazy var secondViewController: UIViewController = {
        let viewController = T07TuttorialViewController.instantiateFromStoryboard()
        viewController.tutorialStep = .secondStep
        return viewController
    }()

    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        self.setViewControllers([firstViewController],
                                direction: .forward,
                                animated: true,
                                completion: nil)
        
        for view in self.view.subviews where view is UIScrollView {
            if let view = view as? UIScrollView {
                view.isScrollEnabled = false
            }
        }
    }
    
    func goToNextPage() {
        self.setViewControllers([secondViewController],
                                direction: .forward,
                                animated: true,
                                completion: nil)
        for view in self.view.subviews where view is UIScrollView {
            if let view = view as? UIScrollView {
                view.isScrollEnabled = true
            }
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
