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
    var createDate: Double
    var updateDate: Double
    var displayDate: Double
    var title: String
    var images: [Image]
    
    init(id: UUID, createDate: Double, updateDate: Double, displayDate: Double, content: String, title: String, images: [Image]) {
        self.id = id
        self.title = title
        self.createDate = createDate
        self.updateDate = updateDate
        self.displayDate = displayDate
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
            note.createDate = createDate
            note.updateDate = updateDate
            note.displayDate = displayDate
            note.title = title
            note.content = content
            note.addToImages(NSSet(array: images))
        }
    }
}
