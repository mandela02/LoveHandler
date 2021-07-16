//
//  AppUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 20/06/2021.
//

import Foundation
import UIKit

protocol AppUseCaseType {
    func save() -> DatabaseResponse
}

class AppUseCase: AppUseCaseType {
    private let repository: Repository<CDBackgroundImage>
    
    init(repository: Repository<CDBackgroundImage>) {
        self.repository = repository
    }
    
    func save() -> DatabaseResponse {
        let screenSize = Utilities.getWindowBound().size
        let images = [ImageNames.love1.image,
                      ImageNames.love2.image,
                      ImageNames.love3.image,
                      ImageNames.love4.image,
                      ImageNames.love5.image,
                      ImageNames.love6.image,
                      ImageNames.love7.image,
                      ImageNames.love8.image]
            .compactMap { $0 }
            .map { image -> UIImage in
                let imageAspectRatio = image.size.width / image.size.height
                let imageSize = CGSize(width: screenSize.height * imageAspectRatio,
                                       height: screenSize.height)
                return image
                    .resize(targetSize: imageSize)
            }
            
        images.forEach { image in
                let _: CDBackgroundImage = CDBackgroundImage.build(context: PersistenceManager.shared.persistentContainer.viewContext) { object in
                    object.id = UUID()
                    object.image = image.jpeg(.medium)
                }
            }
        if SettingsHelper.backgroundImage.value == nil {
            Settings.background.value = images.first?.jpeg(.medium)
        }
        
        let result = repository.save()
        return result
    }
}
