//
//  T03CalendarViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation
import Combine

class T03CalendarViewModel: BaseViewModel {
    private var navigator: T03CalendarNavigator

    init(navigator: T03CalendarNavigator) {
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        let noResponse = input.backButtonPressed
            .handleEvents(receiveOutput: { [weak self] in
                self?.navigator.dissmiss()
            })
            .eraseToAnyPublisher()
        return Output(noResponse: noResponse)
    }
    
    struct Input {
        let backButtonPressed: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let noResponse: AnyPublisher<Void, Never>
    }
}
