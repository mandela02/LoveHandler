//
//  T03MemoryListUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import Foundation
import Combine

protocol T03MemoryListUseCaseType {
    func getAllMemory() -> [CDMemory]
    func search(value: String) -> [CDMemory]
    func onDatabaseUpdated() -> AnyPublisher<Void, Never>
}

class T03MemoryListUseCase: T03MemoryListUseCaseType {
    private let repository: Repository<CDMemory>
    
    init(repository: Repository<CDMemory>) {
        self.repository = repository
    }

    func getAllMemory() -> [CDMemory] {
        let response = repository.fetchAllData()
        switch response {
        case .success(data: let data):
            if let data = data as? [CDMemory] {
                return data
            } else {
                return []
            }
        case .error(error: let error):
            return []
        }
    }
    
    func search(value: String) -> [CDMemory] {
        let response = repository.fetchRequest(predicate: "title", value: value)
        switch response {
        case .success(data: let data):
            if let data = data as? [CDMemory] {
                return data
            } else {
                return []
            }
        case .error(error: let error):
            return []
        }
    }
    
    func onDatabaseUpdated() -> AnyPublisher<Void, Never> {
        return repository.publisher()
    }
}
