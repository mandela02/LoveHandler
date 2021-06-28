//
//  T07TutorialPageViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 28/06/2021.
//

import UIKit

class T07TutorialPageViewController: UIPageViewController {
    
    lazy var firstViewController: UIViewController = {
        let mainViewController = T07TuttorialViewController.instantiateFromStoryboard()
        return mainViewController
    }()

    lazy var secondViewController: UIViewController = {
        let mainViewController = T07TuttorialViewController.instantiateFromStoryboard()
        return mainViewController
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
        if index == 1 { return nil }
        index -= 1
        return firstViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if index == 2 { return nil }
        index += 1
        return secondViewController
    }
}
