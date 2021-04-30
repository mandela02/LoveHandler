//
//  CDNote+CoreDataProperties.swift
//  LoveHandler
//
//  Created by LanNTH on 29/04/2021.
//
//

import Foundation
import CoreData


extension CDNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNote> {
        return NSFetchRequest<CDNote>(entityName: "CDNote")
    }

    @NSManaged public var content: String?
    @NSManaged public var id: UUID?
    @NSManaged public var createDate: Double
    @NSManaged public var updateDate: Double
    @NSManaged public var displayDate: Double
    @NSManaged public var title: String?
    @NSManaged public var images: NSSet?
    
    var wrappedTitle: String {
        return title ?? "No Title"
    }
    var wrappedContent: String {
        return content ?? "No Content"
    }

    var wrappedId: UUID {
        return id ?? UUID()
    }
    
    var wrappedImages: [CDImage] {
        guard let set = images as? Set<CDImage> else { return [] }
        return Array(set)
    }
}

extension CDNote: ModelConvertibleType {
    func asModel() -> Note {
        return Note(id: wrappedId,
                    createDate: createDate,
                    updateDate: updateDate,
                    displayDate: displayDate,
                    content: wrappedContent,
                    title: wrappedTitle,
                    images: wrappedImages.map { $0.asModel() })
    }
}

// MARK: Generated accessors for images
extension CDNote {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: CDImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: CDImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

extension CDNote : Identifiable {

}
