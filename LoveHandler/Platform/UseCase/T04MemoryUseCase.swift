//
//  T04MemoryUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 12/06/2021.
//

import Foundation

protocol T04MemoryUseCaseType {
    func save(model: CDMemory) -> DatabaseResponse
}

class T04MemoryUseCase: T04MemoryUseCaseType {
    private let repository: Repository<CDMemory>
    
    init(repository: Repository<CDMemory>) {
        self.repository = repository
    }

    func save(model: CDMemory) -> DatabaseResponse {
        return repository.save(model: model)
    }
}
