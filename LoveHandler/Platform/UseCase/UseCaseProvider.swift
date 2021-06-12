//
//  UseCaseProvider.swift
//  LoveHandler
//
//  Created by LanNTH on 12/06/2021.
//

import Foundation

class UseCaseProvider {
    static let defaultProvider = UseCaseProvider()
    
    private lazy var memoryRepository = Repository<CDMemory>()
    
    private lazy var memoryUseCase = T04MemoryUseCase(repository: memoryRepository)
    private lazy var memoryListUseCase = T03MemoryListUseCase(repository: memoryRepository)

    private init() {}
    
    func getMemoryUseCase() -> T04MemoryUseCaseType {
        return memoryUseCase
    }
    
    func getMemoryListUseCase() -> T03MemoryListUseCaseType {
        return memoryListUseCase
    }
}
