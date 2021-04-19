//
//  ImageAction.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit

protocol EnumName {
    func getName() -> String
}

enum ImageAction: CaseIterable, EnumName {
    case library
    case camera
    
    func getName() -> String {
        switch self {
        case .camera:
            return LocalizedString.t01ImagePickerCamera
        case .library:
            return LocalizedString.t01ImagePickerLibrary
        }
    }
}
