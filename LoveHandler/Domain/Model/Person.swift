//
//  Person.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import Foundation
import UIKit

struct Person {
    var name: String?
    var gender: Gender?
    var dateOfBirth: Date?
    var image: UIImage?
    
    var age: Int {
        guard let dateOfBirth = dateOfBirth else {
            return 0
        }
        let ageComponents = Calendar.gregorian.dateComponents([.year], from: dateOfBirth, to: Date())
        if let age = ageComponents.year {
            return age
        }
        return 0
    }
    
    var zodiacSign: Zodiac? {
        return dateOfBirth?.zodiac
    }
    
    var isACompletePerson: Bool {
        return name != nil && gender != nil && dateOfBirth != nil && image != nil
    }
}
