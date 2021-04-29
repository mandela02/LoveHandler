//
//  Converter.swift
//  LoveHandler
//
//  Created by LanNTH on 29/04/2021.
//

import Foundation
import CoreData

protocol ModelConvertibleType {
    associatedtype Model
    func asModel() -> Model
}

protocol CoreDataRepresentable {
    associatedtype CoreDataType: ModelConvertibleType
    
    var uid: UUID { get }
    
    func asCoreData(context: NSManagedObjectContext) -> CoreDataType
}
