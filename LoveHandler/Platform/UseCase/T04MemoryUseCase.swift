//
//  T04MemoryUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 12/06/2021.
//

import Foundation

protocol T04MemoryUseCaseType {
    func save(id: UUID, image: Data, title: String, displayDate: Date) -> DatabaseResponse
    func update(memory: CDMemory) -> DatabaseResponse
}

class T04MemoryUseCase: T04MemoryUseCaseType {
    private let repository: Repository<CDMemory>
    
    init(repository: Repository<CDMemory>) {
        self.repository = repository
    }

    func save(id: UUID, image: Data, title: String, displayDate: Date) -> DatabaseResponse {
        let model: CDMemory = CDMemory.build(context: PersistenceManager.shared.persistentContainer.viewContext) { object in
            object.id = id
            object.image = image
            object.title = title
            object.displayedDate = displayDate.timeIntervalSince1970
            object.createdDate = Date().timeIntervalSince1970
            object.updatedDate = Date().timeIntervalSince1970
        }
        
        return repository.save(model: model)
    }
    
    func update(memory: CDMemory) -> DatabaseResponse {
        return repository.save(model: memory)
    }
}
