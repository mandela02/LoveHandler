//
//  Repositoy.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import Foundation
import CoreData

enum DatabaseResponse {
    case success(data: Any?)
    case error(error: Error)
}

protocol RepositoryType {
    associatedtype T
    var entityName : String { get }
    func countAll() -> DatabaseResponse
    func fetchAllData() -> DatabaseResponse
    func save(model: T) -> DatabaseResponse
}

class Repository<T: NSManagedObject>: RepositoryType {
    var container: NSPersistentContainer{
        PersistenceManager.shared.persistentContainer
    }
    
    var entityName: String {
        return NSStringFromClass(T.self).components(separatedBy: ".").last ?? "Unknown"
    }
    
    func countAll() -> DatabaseResponse {
        do {
            let request = NSFetchRequest<T>(entityName: entityName)
            let result = try container.viewContext.count(for: request)
            return .success(data: result)
        } catch let error {
            return .error(error: error)
        }
    }
    
    func fetchAllData() -> DatabaseResponse {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return .success(data: result)
        } catch let error {
            return .error(error: error)
        }
    }
    
    func save(model: T) -> DatabaseResponse {
        do {
            try container.viewContext.save()
            return .success(data: nil)
        } catch let error {
            return .error(error: error)
        }

    }
}
