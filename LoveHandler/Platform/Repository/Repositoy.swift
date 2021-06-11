//
//  Repositoy.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import Foundation
import CoreData

protocol RepositoryType {
    associatedtype T
    var entityName : String { get }
    func countAll() -> Int
    func fetchAllData() -> [T]
    func save(model: T) throws
}

class Repository<T: NSManagedObject>: RepositoryType {
    var container: NSPersistentContainer{
        PersistenceManager.shared.persistentContainer
    }
    
    var entityName: String {
        return NSStringFromClass(T.self).components(separatedBy: ".").last ?? "Unknown"
    }
    
    func countAll() -> Int {
        do {
            let request = NSFetchRequest<T>(entityName: entityName)
            return try container.viewContext.count(for: request)
        } catch {
            return 0
        }
    }
    
    func fetchAllData() -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            return []
        }
    }
    
    func save(model: T) throws {
        try container.viewContext.save()
    }
}
