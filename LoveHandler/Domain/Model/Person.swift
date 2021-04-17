//
//  Person.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import Foundation

struct Person {
    var name: String
    var gender: Gender
    var dateOfBirth: Date
    
    var age: Int {
        let ageComponents = Calendar.gregorian.dateComponents([.year], from: dateOfBirth, to: Date())
        if let age = ageComponents.year {
            return age
        }
        return 0
    }
    
    var zodiacSign: Zodiac? {
        return dateOfBirth.zodiac
    }
}
