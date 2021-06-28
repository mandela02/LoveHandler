//
//  Person.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import Foundation
import UIKit

enum Target: String {
    case you
    case soulmate
    
    var personKey: String {
        rawValue + "Person"
    }
}

struct Person {
    var name: String?
    var gender: Gender?
    var dateOfBirth: Double?
    var image: UIImage?
        
    var age: Int {
        guard let date = dateOfBirth else {
            return 0
        }
        let dateOfBirth = Date(timeIntervalSince1970: date)
        let ageComponents = Calendar.gregorian.dateComponents([.year], from: dateOfBirth, to: Date())
        if let age = ageComponents.year {
            return age
        }
        return 0
    }
    
    var zodiacSign: Zodiac? {
        return Date(timeIntervalSince1970: dateOfBirth ?? 0.0).zodiac
    }
    
    var isACompletePerson: Bool {
        return name != nil && gender != nil && dateOfBirth != nil && image != nil
    }
}

extension Person {
    init(object: JsonObjectPerson) {
        self.name = object.name
        self.gender = Gender.getGender(from: object.gender)
        self.dateOfBirth = object.dateOfBirth
        self.image = UIImage(data: object.image)
    }
    
    func toObject() -> JsonObjectPerson {
        return JsonObjectPerson(name: self.name ?? "",
                                 gender: self.gender?.rawValue ?? 0,
                                 dateOfBirth: self.dateOfBirth ?? 00,
                                 image: self.image?.jpeg(.medium) ?? Data())
    }
    
    func save(forKey key: Target) {
        let savedObject = self.toObject()
        
        let encoder = JSONEncoder()
        let defaults = UserDefaults.standard
        if let encoded = try? encoder.encode(savedObject) {
            defaults.set(encoded, forKey: key.personKey)
        }
        UserDefaults.standard.synchronize()
    }
    
    static func get(fromKey key: Target) -> Person {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: key.personKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(JsonObjectPerson.self, from: savedPerson) {
                return Person(object: loadedPerson)
            }
        }
        return Person()
    }
}

struct JsonObjectPerson: Codable {
    var name: String
    var gender: Int
    var dateOfBirth: Double
    var image: Data
}
