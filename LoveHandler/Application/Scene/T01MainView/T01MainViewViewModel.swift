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
                        
        return Output(noResponser: navigation,
                      heartButtonTapped: input.onHeartButtonTap)
    }
}

extension T01MainViewViewModel {
    struct Input {
        let onButtonTap: AnyPublisher<T01MainButtonType, Never>
        let onHeartButtonTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let noResponser: AnyPublisher<Void, Never>
        let heartButtonTapped: AnyPublisher<Void, Never>
    }
}
