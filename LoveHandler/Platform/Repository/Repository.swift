//
//  Repository.swift
//  LoveHandler
//
//  Created by LanNTH on 29/04/2021.
//

import Foundation
import CoreData

protocol RepositoryType {
    associatedtype T
    var entityName : String { get }
    func countAll() throws -> Int
    func fetchAllData() -> [T]
    func save(model: T) throws
    func update(model: T, at id: UUID) throws
}

class Repository<T: CoreDataRepresentable>: RepositoryType where T == T.CoreDataType.Model, T.CoreDataType: NSManagedObject  {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    var entityName: String {
        return NSStringFromClass(T.CoreDataType.self).components(separatedBy: ".").last ?? "Unknow"
    }
    
    func countAll() throws -> Int {
        let request = NSFetchRequest<T.CoreDataType>(entityName: entityName)
        return try container.viewContext.count(for: request)
    }
    
    func fetchAllData() -> [T] {
        let fetchRequest = NSFetchRequest<T.CoreDataType>(entityName: entityName)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result.map { $0.asModel() }
        } catch {
            return []
        }
    }
    
    func save(model: T) throws {
        let _ = model.asCoreData(context: container.viewContext)
        try container.viewContext.save()
    }
    
    func update(model: T, at id: UUID) throws {
        let fetchRequest = NSFetchRequest<T.CoreDataType>(entityName: entityName)
        let commitPredicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.predicate = commitPredicate
        let result = try container.viewContext.fetch(fetchRequest)
        if let data = result.first {
            data.updateCoreData(with: model, context: container.viewContext)
            try container.viewContext.save()
        }

    }
}
