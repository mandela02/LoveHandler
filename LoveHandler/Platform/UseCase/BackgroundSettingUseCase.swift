//
//  BackgroundSettingUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 20/06/2021.
//

import Foundation
import UIKit

protocol BackgroundSettingUseCaseType {
    func get() -> [CDBackgroundImage]
}

class BackgroundSettingUseCase: BackgroundSettingUseCaseType {
    private let repository: Repository<CDBackgroundImage>
    
    init(repository: Repository<CDBackgroundImage>) {
        self.repository = repository
    }
    
    func get() -> [CDBackgroundImage] {
        let result = repository.fetchAllData()
        switch result {
        case .success(data: let datas):
            guard let datas = datas as? [CDBackgroundImage] else {
                return []
            }
            return datas
        default:
            return []
        }
    }
}
