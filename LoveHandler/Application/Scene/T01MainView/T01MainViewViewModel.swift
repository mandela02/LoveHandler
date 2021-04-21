//
//  T01MainViewViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 19/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

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
        let navigation = input.onButtonTap.do(onNext: { [weak self] button in
            guard let self = self else { return }
            switch button {
            case .setting:
                self.navigator.toSettings()
            case .diary:
                self.navigator.toDiaries()
            }
        }).mapToVoid()
        .asDriverOnErrorJustComplete()
                
        let onSettingChange = input.onSettingChange.share()
        let viewDidAppear = input.viewDidAppear
        
        let recalculate = Observable.merge(onSettingChange, viewDidAppear)
            .map { _ in self.calculate() }.share()
        
        let progress = recalculate.map { $0.progress }.asDriverOnErrorJustComplete()
        let numberOfDay = recalculate.map { $0.numberOfDay }.asDriverOnErrorJustComplete()
        let isShowingWaveBackground = onSettingChange
            .map { _ in Settings.isShowingBackgroundWave.value }.asDriverOnErrorJustComplete()

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
        let onButtonTap: Observable<T01MainButtonType>
        let viewDidAppear: Observable<Void>
        let onSettingChange: Observable<Void>
    }
    
    struct Output {
        let noResponser: Driver<Void>
        let progress: Driver<Float>
        let numberOfDay: Driver<Int>
        let isShowingWaveBackground: Driver<Bool>
    }
}
