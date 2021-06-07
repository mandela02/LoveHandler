//
//  CDImage+CoreDataProperties.swift
//  LoveHandler
//
//  Created by LanNTH on 29/04/2021.
//
//

import Foundation
import CoreData


extension CDImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDImage> {
        return NSFetchRequest<CDImage>(entityName: "CDImage")
    }

    @NSManaged public var data: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var isAvatar: NSNumber
    @NSManaged public var origin: CDNote?

    var wrappedData: Data {
        return data ?? Data()
    }
    
    var wrappedId: UUID {
        return id ?? UUID()
    }
    
    var isAvatarValue: Bool {
        get {
            return Bool(truncating: isAvatar)
        }
        set {
            isAvatar = NSNumber(value: newValue)
        }
    }
}

extension CDImage: ModelConvertibleType {
    func asModel() -> Image {
        return Image(data: wrappedData,
                     id: wrappedId,
                     isAvatar: isAvatarValue)
    }
    
    func updateCoreData(with model: Image, context: NSManagedObjectContext) {
        self.data = model.data
    }
}

extension CDImage : Identifiable {

}
