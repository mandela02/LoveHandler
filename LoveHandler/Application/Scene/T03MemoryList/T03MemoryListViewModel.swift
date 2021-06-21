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
    private var useCase: T03MemoryListUseCaseType
    
    init(navigator: T03MemoryListNavigatorType, useCase: T03MemoryListUseCaseType) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let dismiss = input.dismissTrigger
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.navigator.dismiss()
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let toMemory = input.addButtonTrigger
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.navigator.toMemory()
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let toSelectMemory = input.selectedMemoryTrigger
            .handleEvents(receiveOutput: { [weak self] model in
                self?.navigator.toMemory(model: model)
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let onDatabaseChange = useCase.onDatabaseUpdated()
            .map { _ in }
            .eraseToAnyPublisher()
        
        let refreshDataTrigger = Publishers.Merge(input.viewDidAppear, onDatabaseChange)
        let searchTrigger = input.searchString.debounce(for: 0.25,
                                                        scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        let memories = Publishers.CombineLatest(refreshDataTrigger, searchTrigger)
            .map { [weak self] _, searchString -> [CDMemory] in
                guard let self = self else { return [] }
                
                if searchString.isEmpty {
                    return self.useCase.getAllMemory()
                } else {
                    return self.useCase.search(value: searchString)
                }
            }
            .eraseToAnyPublisher()
        
        let noResponse = Publishers.MergeMany([dismiss,
                                               toMemory,
                                               toSelectMemory,
                                               onDatabaseChange])
            .eraseToAnyPublisher()
        
        return Output(noRespone: noResponse,
                      memories: memories)
    }
    
    struct Input {
        let viewDidAppear: AnyPublisher<Void, Never>
        let dismissTrigger: AnyPublisher<Void, Never>
        let addButtonTrigger: AnyPublisher<Void, Never>
        let selectedMemoryTrigger: AnyPublisher<CDMemory, Never>
        let searchString: AnyPublisher<String, Never>
    }
    
    struct Output {
        let noRespone: AnyPublisher<Void, Never>
        let memories: AnyPublisher<[CDMemory], Never>
    }
}
