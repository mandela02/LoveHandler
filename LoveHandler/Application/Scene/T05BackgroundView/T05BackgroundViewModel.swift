//
//  T05BackgroundViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 20/06/2021.
//

import Foundation
import Combine
import UIKit

class T05BackgroundViewModel: BaseViewModel {
    private var useCase: BackgroundSettingUseCaseType
    
    init(useCase: BackgroundSettingUseCaseType) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let backgroundImageModels = CurrentValueSubject<[CDBackgroundImage], Never>([])
        let selectedImageIndexPath = CurrentValueSubject<Int, Never>(0)

        let viewWillAppearHandle = input.viewWillAppear
            .map(self.useCase.get)
            .handleEvents(receiveOutput: { models in
                backgroundImageModels.send(models)
                if let data = Settings.background.value,
                   let index = models.map({ $0.image }).firstIndex(of: data) {
                    selectedImageIndexPath.send(index)
                }
            })
            .map { _ in }
            .eraseToAnyPublisher()

        let selectedImagehandler = input.selectedIndex
            .handleEvents(receiveOutput: { index in
                guard let model = backgroundImageModels.value[safe: index] else { return }
                Settings.background.value = model.image
                selectedImageIndexPath.send(index)
            })
            .map { _ in }
            .eraseToAnyPublisher()

        let images = backgroundImageModels
            .map { $0.compactMap { $0.image }.map { UIImage(data: $0) }.compactMap { $0 } }
            .eraseToAnyPublisher()
        
        let selectedImage = selectedImageIndexPath
            .map { index -> UIImage in
            guard let model = backgroundImageModels.value[safe: index],
                  let data = model.image,
                  let image = UIImage(data: data)
            else { return UIImage() }
            return image
        }
        .eraseToAnyPublisher()
        
        let noResponse = Publishers.MergeMany ([viewWillAppearHandle,
                                                selectedImagehandler])
            .eraseToAnyPublisher()
        
        return Output(images: images,
                      selectedImage: selectedImage,
                      selectedIndex: selectedImageIndexPath
                        .eraseToAnyPublisher(),
                      noResponse: noResponse)
    }
    
    struct Input {
        let viewWillAppear: AnyPublisher<Void, Never>
        let selectedIndex: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let images: AnyPublisher<[UIImage], Never>
        let selectedImage: AnyPublisher<UIImage, Never>
        let selectedIndex: AnyPublisher<Int, Never>
        let noResponse: AnyPublisher<Void, Never>
    }
}
