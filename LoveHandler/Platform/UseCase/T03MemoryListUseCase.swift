//
//  T03MemoryListUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import Foundation

protocol T03MemoryListUseCaseType {
    func getAllMemory() -> [CDMemory]
}

class T03MemoryListUseCase: T03MemoryListUseCaseType {
    private let repository: Repository<CDMemory>
    
    init(repository: Repository<CDMemory>) {
        self.repository = repository
    }

    func getAllMemory() -> [CDMemory] {
        return repository.fetchAllData()
    }
}
