//
//  BackgroundSettingUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 20/06/2021.
//

import Foundation
import Combine
import UIKit

protocol BackgroundSettingUseCaseType {
    func save(image: UIImage) -> DatabaseResponse
    func get() -> [CDBackgroundImage]
    func delete(model: CDBackgroundImage)
    func onDatabaseUpdated() -> AnyPublisher<Void, Never>
}

class BackgroundSettingUseCase: BackgroundSettingUseCaseType {
    private let repository: Repository<CDBackgroundImage>
    
    init(repository: Repository<CDBackgroundImage>) {
        self.repository = repository
    }
    
    
    func save(image: UIImage) -> DatabaseResponse {
        let screenSize = Utilities.getWindowBound().size

        let imageAspectRatio = image.size.width / image.size.height
        let imageSize = CGSize(width: screenSize.height * imageAspectRatio,
                               height: screenSize.height)
        let savedImage = image.resize(targetSize: imageSize)

        let _: CDBackgroundImage = CDBackgroundImage.build(context: PersistenceManager.shared.persistentContainer.viewContext) { object in
            object.id = UUID()
            object.image = savedImage.jpeg(.medium)
        }
        
        return repository.save()
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
