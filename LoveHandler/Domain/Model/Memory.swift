//
//  Memory.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import Foundation
import CoreData

class Memory {
    var id: UUID
    var title: String?
    var createDate: Double
    var updateDate: Double
    var displayDate: Double
    var image: Data
    
    init(id: UUID, title: String, createDate: Double, updateDate: Double, displayDate: Double, image: Data) {
        self.id = id
        self.title = title
        self.createDate = createDate
        self.updateDate = updateDate
        self.displayDate = displayDate
        self.image = image
    }
}
