//
//  Note.swift
//  LoveHandler
//
//  Created by LanNTH on 29/04/2021.
//

import Foundation
import CoreData

class Note {
    var id: UUID
    var content: String
    var time: Double
    var title: String
    var images: [Image]
    
    init(id: UUID, time: Double, content: String, title: String, images: [Image]) {
        self.id = id
        self.title = title
        self.time = time
        self.content = content
        self.images = images
    }
}

extension Note: CoreDataRepresentable {
    var uid: UUID {
        return id
    }
    
    func asCoreData(context: NSManagedObjectContext) -> CDNote {
        CDNote.build(context: context) { note in
            note.id = id
            note.time = time
            note.title = title
            note.content = content
            note.addToImages(NSSet(array: images))
        }
    }
}
