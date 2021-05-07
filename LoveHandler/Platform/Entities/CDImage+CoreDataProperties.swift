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
    @NSManaged public var origin: CDNote?

    var wrappedData: Data {
        return data ?? Data()
    }
    
    var wrappedId: UUID {
        return id ?? UUID()
    }
}

extension CDImage: ModelConvertibleType {
    func asModel() -> Image {
        return Image(data: wrappedData,
                     id: wrappedId)
    }
}

extension CDImage : Identifiable {

}
