//
//  PersistenceManager.swift
//  LoveHandler
//
//  Created by LanNTH on 29/04/2021.
//

import Foundation
import CoreData
import UIKit

struct DatabaseConstants {
    static var name = "LoveMemoryDataModel"
    static var urlPath = "group.com.qtcorp.LoveHandler"
}

class PersistenceManager {
    static let shared = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DatabaseConstants.name)
        let storeURL = URL.storeURL(for: DatabaseConstants.urlPath, databaseName: DatabaseConstants.name)
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification
        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            if self.persistentContainer.viewContext.hasChanges {
                try? self.persistentContainer.viewContext.save()
            }
        }
    }
}

public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

extension NSManagedObject {
    static func build<O: NSManagedObject>(context: NSManagedObjectContext,
                                          _ builder: (O) -> Void) -> O {
        let object = O(context: context)
        builder(object)
        return object
    }
}
