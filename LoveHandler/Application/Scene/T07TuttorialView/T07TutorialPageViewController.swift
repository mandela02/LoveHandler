//
//  T07TutorialPageViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 28/06/2021.
//

import UIKit
import Combine

class T07TutorialPageViewController: UIPageViewController {
    lazy private var firstViewController: BasePageViewChildController = {
        let viewController = T07TuttorialViewController.instantiateFromStoryboard()
        viewController.index = 1
        return viewController
    }()
    
    lazy private var secondViewController: BasePageViewChildController = {
        let viewController = T07TuttorialViewController.instantiateFromStoryboard()
        viewController.index = 2
        return viewController
    }()
    
    lazy private var thirdViewController: BasePageViewChildController = {
        let viewController = T08MemoryDateViewController.instantiateFromStoryboard()
        viewController.index = 3
        return viewController
    }()
    
    var currentIndex = CurrentValueSubject<Int, Never>(1)
    private var currentViewController: BasePageViewChildController?
    
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
    
    private func savePerson() {
        if let firstViewController = firstViewController as? T07TuttorialViewController {
            firstViewController.savedPerson.save(forKey: .you)
        }
        
        if let secondViewController = secondViewController as? T07TuttorialViewController {
            secondViewController.savedPerson.save(forKey: .soulmate)
        }
    }
    
    func goToNextPage() {
        currentIndex.send(currentIndex.value + 1)
        guard let index = currentViewController?.index else { return }
        
        switch index {
        case 1:
            self.setViewControllers([secondViewController],
                                    direction: .forward,
                                    animated: true,
                                    completion: nil)
            self.currentViewController = secondViewController
            savePerson()
        case 2:
            self.setViewControllers([thirdViewController],
                                    direction: .forward,
                                    animated: true,
                                    completion: nil)
            self.currentViewController = thirdViewController
            
            savePerson()
            if let thirdViewController = thirdViewController as? T08MemoryDateViewController {
                thirdViewController.setupPerson()
            }
        case 3:
            UIAlertController.alertDialog(title: LocalizedString.t08CompleteDialogTitle,
                                          message: LocalizedString.t08CompleteDialogSubTitle,
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
        default:
            return
        }
    }
}

extension T07TutorialPageViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex.value - 1
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let viewController = self.viewControllers?.first as? BasePageViewChildController {
                self.currentViewController = viewController
            }
            self.currentIndex.send(currentViewController?.index ?? 0)
            savePerson()
            if let viewController =  currentViewController as? T08MemoryDateViewController {
                viewController.setupPerson()
            }
        }
    }
}

extension T07TutorialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? BasePageViewChildController,
              let index = viewController.index else {
            return nil
        }
        
        switch index {
        case 1:
            return nil
        case 2:
            return firstViewController
        case 3:
            return secondViewController
        default:
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewController = viewController as? BasePageViewChildController,
              let index = viewController.index else {
            return nil
        }
        
        switch index {
        case 1:
            return secondViewController
        case 2:
            return thirdViewController
        case 3:
            return nil
        default:
            return nil
        }
    }
}
