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
        let noResponser = input.onButtonTap.do(onNext: { [weak self] button in
            guard let self = self else { return }
            switch button {
            case .setting:
                self.navigator.toSettings()
            case .diary:
                self.navigator.toDiaries()
            }
        }).mapToVoid()
        .asDriverOnErrorJustComplete()
        
        return Output(noResponser: noResponser)
    }
    
    struct Input {
        let onButtonTap: Observable<T01MainButtonType>
    }
    
    struct Output {
        let noResponser: Driver<Void>
    }
}
