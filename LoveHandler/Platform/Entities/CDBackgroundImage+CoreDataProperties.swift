//
//  CDBackgroundImage+CoreDataProperties.swift
//  LoveHandler
//
//  Created by LanNTH on 20/06/2021.
//
//

import Foundation
import CoreData


extension CDBackgroundImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBackgroundImage> {
        return NSFetchRequest<CDBackgroundImage>(entityName: "CDBackgroundImage")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?

}

extension CDBackgroundImage : Identifiable {

}
