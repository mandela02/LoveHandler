//
//  T03MemoryListViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import Foundation
import Combine

class T03MemoryListViewModel: BaseViewModel {
    private var navigator: T03MemoryListNavigatorType
    
    init(navigator: T03MemoryListNavigatorType) {
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        let dismiss = input.dismissTrigger.handleEvents(receiveOutput: navigator.dismiss)
            .map { _ in }
            .eraseToAnyPublisher()
        
        return Output(noRespone: dismiss)
    }
    

    struct Input {
        let viewWillAppear: AnyPublisher<Void, Never>
        let dismissTrigger: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let noRespone: AnyPublisher<Void, Never>
    }
}
