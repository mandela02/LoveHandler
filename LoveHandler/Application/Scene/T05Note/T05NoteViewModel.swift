//
//  T05NoteViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation
import Combine
import UIKit

class T05NoteViewModel: BaseViewModel {
    func transform(_ input: Input) -> Output {
        let didPressImageButton = input.imageButtonPressed.eraseToAnyPublisher()
        var isSettingAvatar = false
        let bigImage = CurrentValueSubject<UIImage?, Never>(nil)
        
        var totalImages: [UIImage] = []
        
        let allImages = Publishers.CombineLatest(input.cameraImage, input.libraryImages)
            .map { image, images -> [UIImage] in
                if let image = image {
                    totalImages.append(image)
                } else {
                    totalImages.append(contentsOf: images)
                }
                return totalImages
            }
            .handleEvents(receiveOutput: { images in
                if !isSettingAvatar && !images.isEmpty {
                    bigImage.send(images.first)
                }
            })
            .share()
            .eraseToAnyPublisher()
        
        let avatar = input.seletedCell
            .combineLatest(allImages)
            .filter { $0.0 != nil }
            .handleEvents(receiveOutput: { _, _ in
                isSettingAvatar = true
            })
            .map { cell, images in
                return images[safe: cell!] ?? images.first
            }
            .handleEvents(receiveOutput: { image in
                bigImage.send(image)
            })
            .map { _ in }
            .eraseToAnyPublisher()

        let deleteImageAction = input.deleteButtonPressed
            .filter { $0 != nil }
            .handleEvents(receiveOutput: { index in
                guard let index = index,
                      let image = totalImages[safe: index],
                      let avatar = bigImage.value  else { return }
                if avatar == image {
                    if totalImages.count > 0 {
                        bigImage.send(totalImages.first)
                    } else {
                        bigImage.send(nil)
                    }
                }
                
            })
            .map { index -> [UIImage] in
                totalImages.remove(at: index!)
                return totalImages
            }
            .eraseToAnyPublisher()

        let images = Publishers.Merge(allImages, deleteImageAction)
            .eraseToAnyPublisher()

        return Output(images: images,
                      didPressImageButton: didPressImageButton,
                      avatar: bigImage.eraseToAnyPublisher(),
                      noResponse: avatar)
    }
}

extension T05NoteViewModel {
    struct Input {
        let imageButtonPressed: AnyPublisher<Void, Never>
        let cameraImage: AnyPublisher<UIImage?, Never>
        let libraryImages: AnyPublisher<[UIImage], Never>
        let deleteButtonPressed: AnyPublisher<Int?, Never>
        let seletedCell: AnyPublisher<Int?, Never>
    }
    
    struct  Output {
        let images: AnyPublisher<[UIImage], Never>
        let didPressImageButton: AnyPublisher<Void, Never>
        let avatar: AnyPublisher<UIImage?, Never>
        let noResponse: AnyPublisher<Void, Never>
    }
}
