//
//  T10HeartViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 04/07/2021.
//

import UIKit
import Combine

class T10HeartViewController: BasePageViewChildController {
    @IBOutlet weak var heartView: LoveProgressView!

    private var cancellables = Set<AnyCancellable>()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let progress = calculate()
        self.heartView.progress = progress.progress
        self.heartView.numberOfDay = progress.numberOfDay
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let onSettingChange = Publishers.Merge(SettingsHelper.weddingDate
                                                    .map { _ in }.eraseToAnyPublisher(),
                                                SettingsHelper.relationshipStartDate
                                                    .map { _ in }.eraseToAnyPublisher())
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .map { _ in }
            .eraseToAnyPublisher()

        onSettingChange
            .map(calculate)
            .sink { [weak self] (progress, numberOfDay) in
                self?.heartView.progress = progress
                self?.heartView.numberOfDay = numberOfDay
            }
            .store(in: &cancellables)
    }
        
    private func calculate() -> (progress: Float, numberOfDay: Int) {
        let dayStartDating = Settings.relationshipStartDate.value
        let dayGettingMarry = Settings.weddingDate.value
        let today = Date()
        
        let totalDateDay = Date.countBetweenDate(component: .day, start: dayStartDating, end: dayGettingMarry)
        let currentDateDay = Date.countBetweenDate(component: .day, start: dayStartDating, end: today)
                 
        let progressive = Float(currentDateDay)/Float(totalDateDay)
        return (progressive, currentDateDay)
    }
}
