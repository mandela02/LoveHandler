//
//  LoveInformationPageViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 04/07/2021.
//

import UIKit

class LoveInformationPageViewController: UIPageViewController {
    lazy private var firstViewController: BasePageViewChildController = {
        let viewController = T10HeartViewController.instantiateFromStoryboard()
        viewController.index = 1
        return viewController
    }()
    
    lazy private var secondViewController: BasePageViewChildController = {
        let viewController = T09DateCountViewController.instantiateFromStoryboard()
        viewController.index = 2
        return viewController
    }()

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

extension LoveInformationPageViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension LoveInformationPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? BasePageViewChildController else { return nil}
        if viewController.index == 1 { return nil }
        return firstViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? BasePageViewChildController else { return nil}
        if viewController.index == 2 { return nil }
        return secondViewController
    }
}
