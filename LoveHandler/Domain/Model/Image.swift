//
//  Image.swift
//  LoveHandler
//
//  Created by LanNTH on 29/04/2021.
//

import Foundation
import CoreData

class Image {
    var data: Data
    var id: UUID
    var origin: Note?
    
    init(data: Data, id: UUID, origin: Note?) {
        self.data = data
        self.id = id
        self.origin = origin
    }
}

extension Image: CoreDataRepresentable {
    var uid: UUID {
        return id
    }
    
    func asCoreData(context: NSManagedObjectContext) -> CDImage {
        return CDImage.build(context: context) { image in
            image.data = data
            image.id = id
            image.origin = origin?.asCoreData(context: context)
        }
    }
}
