//
//  CDMemory+CoreDataProperties.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//
//

import Foundation
import CoreData

extension CDMemory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMemory> {
        return NSFetchRequest<CDMemory>(entityName: "CDMemory")
    }

    @NSManaged public var createdDate: Double
    @NSManaged public var updatedDate: Double
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var image: Data?
    @NSManaged public var displayedDate: Double

}

extension CDMemory: Identifiable {

}

extension CDMemory {
    static func create(createdDate: Double, updatedDate: Double, displayedDate: Double, title: String, image: Data ) -> CDMemory {
        return CDMemory.build(context: PersistenceManager.shared.persistentContainer.viewContext) { memory in
            memory.createdDate = createdDate
            memory.updatedDate = updatedDate
            memory.displayedDate = displayedDate
            memory.id = UUID()
            memory.image = image
            memory.title = title
        }
    }
}
