//
//  T01MainViewViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 19/04/2021.
//

import Foundation
import Combine

enum T01MainButtonType {
    case diary
    case setting
}

class T01MainViewViewModel: BaseViewModel {
    private var navigator: T01MainViewNavigatorType

    init(navigator: T01MainViewNavigatorType) {
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        let navigation = input.onButtonTap.handleEvents(receiveOutput: { [weak self] button in
            guard let self = self else { return }
            switch button {
            case .setting:
                self.navigator.toSettings()
            case .diary:
                self.navigator.toDiaries()
            }
        })
        .map { _ in }
        .eraseToAnyPublisher()
                
        let onSettingChange = input.onSettingChange.share()
        let viewDidAppear = input.viewDidAppear
        
        let recalculate = Publishers.Merge(onSettingChange, viewDidAppear)
            .map { _ in self.calculate() }.share()
        
        let progress = recalculate.map { $0.progress }
            .eraseToAnyPublisher()
        let numberOfDay = recalculate.map { $0.numberOfDay }
            .eraseToAnyPublisher()

        let isShowingWaveBackground = onSettingChange
            .map { _ in Settings.isShowingBackgroundWave.value }
            .eraseToAnyPublisher()

        return Output(noResponser: navigation,
                      progress: progress,
                      numberOfDay: numberOfDay,
                      isShowingWaveBackground: isShowingWaveBackground)
    }
    
    private func calculate() -> (progress: Float, numberOfDay: Int) {
        let dayStartDating = Settings.relationshipStartDate.value
        let dayGettingMarry = Settings.marryDate.value
        let today = Date()
        
        let totalDateDay = Date.countBetweenDate(component: .day, start: dayStartDating, end: dayGettingMarry)
        let currentDateDay = Date.countBetweenDate(component: .day, start: dayStartDating, end: today)
                 
        let progressive = Float(currentDateDay)/Float(totalDateDay)
        return (progressive, currentDateDay)
    }
}

extension T01MainViewViewModel {
    struct Input {
        let onButtonTap: AnyPublisher<T01MainButtonType, Never>
        let viewDidAppear: AnyPublisher<Void, Never>
        let onSettingChange: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let noResponser: AnyPublisher<Void, Never>
        let progress: AnyPublisher<Float, Never>
        let numberOfDay: AnyPublisher<Int, Never>
        let isShowingWaveBackground: AnyPublisher<Bool, Never>
    }
}
