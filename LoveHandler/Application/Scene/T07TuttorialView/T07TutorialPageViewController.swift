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
        viewController.index = 1
        return viewController
    }()
    
    lazy private var secondViewController: UIViewController = {
        let viewController = T07TuttorialViewController.instantiateFromStoryboard()
        viewController.index = 2
        return viewController
    }()
    
    lazy private var thirdViewController: UIViewController = {
        let viewController = T08MemoryDateViewController.instantiateFromStoryboard()
        return viewController
    }()
    
    var currentIndex = 1
    private var currentViewController: UIViewController?
    
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
    }
    
    func goToNextPage() {
        currentIndex += 1
        
        if currentViewController is T08MemoryDateViewController {
            UIAlertController.alertDialog(title: "Your sure?",
                                          message: "last chance",
                                          argument: 0)
                .sink(receiveValue: { [weak self] option in
                    if option == nil { return }
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
            return
        }
        
        guard let currentViewController = currentViewController as? T07TuttorialViewController else { return }
        
        if currentViewController.index == 1 {
            self.setViewControllers([secondViewController],
                                    direction: .forward,
                                    animated: true,
                                    completion: nil)
            self.currentViewController = secondViewController
            if let firstViewController = firstViewController as? T07TuttorialViewController {
                firstViewController.savedPerson.save(forKey: .you)
            }
        } else if currentViewController.index == 2 {
            self.setViewControllers([thirdViewController],
                                    direction: .forward,
                                    animated: true,
                                    completion: nil)
            self.currentViewController = thirdViewController
            
            if let secondViewController = secondViewController as? T07TuttorialViewController {
                secondViewController.savedPerson.save(forKey: .soulmate)
            }
            
            if let thirdViewController = thirdViewController as? T08MemoryDateViewController {
                thirdViewController.setupPerson()
            }
        }
    }
}

extension T07TutorialPageViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex - 1
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentViewController = self.viewControllers?.first
            if let viewController = currentViewController as? T07TuttorialViewController {
                self.currentIndex = viewController.index ?? 0
            } else if let viewController =  currentViewController as? T08MemoryDateViewController {
                self.currentIndex = viewController.index
                viewController.setupPerson()
            }
        }
    }
    
}

extension T07TutorialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? T07TuttorialViewController {
            if viewController.index == 1 { return nil }
            return firstViewController
        } else if viewController is T08MemoryDateViewController {
            return secondViewController
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is T08MemoryDateViewController {
            return nil
        } else if let viewController = viewController as? T07TuttorialViewController {
            if viewController.index == 2 {
                return thirdViewController
            } else if viewController.index == 1 {
                return secondViewController
            } else { return secondViewController }
        } else {
            return nil
        }
    }
}
