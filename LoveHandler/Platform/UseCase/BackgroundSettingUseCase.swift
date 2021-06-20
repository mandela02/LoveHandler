//
//  BackgroundSettingUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 20/06/2021.
//

import Foundation
import Combine

protocol BackgroundSettingUseCaseType {
    func get() -> [CDBackgroundImage]
    func delete(model: CDBackgroundImage)
    func onDatabaseUpdated() -> AnyPublisher<Void, Never>
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
    
    func delete(model: CDBackgroundImage) {
        repository.delete(model: model)
        _ = repository.save()
    }
    
    func onDatabaseUpdated() -> AnyPublisher<Void, Never> {
        return repository.publisher()
    }
}
