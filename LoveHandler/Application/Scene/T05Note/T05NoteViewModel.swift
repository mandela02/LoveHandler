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
    
    let useCase: T05NoteUseCaseType
    let note: Note?
    let date: Date?
    
    init(note: Note? = nil, date: Date? = nil, useCase: T05NoteUseCaseType) {
        self.note = note
        self.useCase = useCase
        self.date = date
    }
    
    func transform(_ input: Input) -> Output {
        let didPressImageButton = input.imageButtonPressed.eraseToAnyPublisher()
        
        var isSettingAvatar = false
        let bigImage = CurrentValueSubject<UIImage?, Never>(nil)
        
        let content = CurrentValueSubject<String?, Never>(nil)
        let title = CurrentValueSubject<String?, Never>(nil)

        var note = self.note
        
        let displayDate = CurrentValueSubject<Date, Never>(date ?? Date())
        
        if let note = note {
            displayDate.send(Date(timeIntervalSince1970: TimeInterval(note.displayDate)))
        }
        
        var totalImages: [UIImage] = note?
            .images
            .map { UIImage(data: $0.data) }
            .compactMap { $0 } ?? []
        
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
                    isSettingAvatar = true
                }
            })
            .share()
            .eraseToAnyPublisher()
        
        let avatar = input.seletedCell
            .filter { $0 != nil }
            .handleEvents(receiveOutput: { _ in
                isSettingAvatar = true
            })
            .map { cell in
                return totalImages[safe: cell!] ?? totalImages.first
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
                totalImages.remove(at: index)
                if avatar == image {
                    if totalImages.count > 0 {
                        bigImage.send(totalImages.first)
                    } else {
                        bigImage.send(nil)
                    }
                }
            })
            .map { index -> [UIImage] in
                return totalImages
            }
            .handleEvents(receiveOutput: { images in
                if images.isEmpty {
                    isSettingAvatar = false
                }
            })
            .eraseToAnyPublisher()

        let images = Publishers.Merge(allImages, deleteImageAction)
            .eraseToAnyPublisher()

        let titleSyncAction = input.titleTextInputAction
            .handleEvents(receiveOutput: { string in
                title.send(string)
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let contentSyncAction = input.contentTextInputAction
            .handleEvents(receiveOutput: { string in
                content.send(string)
            })
            .map { _ in }
            .eraseToAnyPublisher()

        let saveActionTriggered = input
            .saveButtonAction
            .map { _ -> Note in
                let dataImages = totalImages
                    .map { $0.pngData() }
                    .compactMap { $0 }
                    .map { Image(data: $0, id: UUID()) }
                
                let noteToSave = Note(id: note?.id ?? UUID(),
                                      createDate: note?.createDate ?? Double(Date().timeIntervalSince1970),
                                      updateDate: Double(Date().timeIntervalSince1970),
                                      displayDate: Double(displayDate.value.timeIntervalSince1970),
                                      content: content.value,
                                      title: title.value,
                                      images: dataImages)
                
                return noteToSave
            }
            .handleEvents(receiveOutput: { newNote in
                note = newNote
            })
            .map { [weak self] newNote -> Result in
                guard let self = self else { return Result.failure(error: "Unexpected Error") }
                if let _ = note {
                    return self.useCase.update(note: newNote)
                } else {
                    return self.useCase.save(note: newNote)
                }
            }
            .share()
            .eraseToAnyPublisher()
        
        let datePickerAction = input.datePickerAction.share()
        
        let saveState = saveActionTriggered.map { _ in State.display }.eraseToAnyPublisher()
        let initState = note == nil ? Just(State.edit).eraseToAnyPublisher() : Just(State.display).eraseToAnyPublisher()
        let textChangeState = input.textActiveAction.map { State.edit }.eraseToAnyPublisher()
        let imageState = input.imageButtonPressed.map { State.edit }.eraseToAnyPublisher()
        let deleteImageState = input.deleteButtonPressed.map { _ in State.edit }.eraseToAnyPublisher()
        let datePickState = datePickerAction.map { _ in State.edit }.eraseToAnyPublisher()

        let state = Publishers.MergeMany([saveState, initState, textChangeState, imageState, deleteImageState, datePickState]).eraseToAnyPublisher()
        
        let noResponse = Publishers.MergeMany([avatar,
                                               titleSyncAction,
                                               contentSyncAction])
            .eraseToAnyPublisher()
        
        let datePickerEvent = datePickerAction.handleEvents(receiveOutput: { date in
            displayDate.send(date)
        })
        
        let changeDisplayDateAction = Publishers.Merge(displayDate.eraseToAnyPublisher(), datePickerEvent)
        
        return Output(images: images,
                      didPressImageButton: didPressImageButton,
                      avatar: bigImage.eraseToAnyPublisher(),
                      noResponse: noResponse,
                      actionResponse: saveActionTriggered,
                      state: state,
                      initialNote: Just(note).eraseToAnyPublisher(),
                      displayDate: changeDisplayDateAction.eraseToAnyPublisher())
    }
}

extension T05NoteViewModel {
    struct Input {
        let imageButtonPressed: AnyPublisher<Void, Never>
        let cameraImage: AnyPublisher<UIImage?, Never>
        let libraryImages: AnyPublisher<[UIImage], Never>
        let deleteButtonPressed: AnyPublisher<Int?, Never>
        let seletedCell: AnyPublisher<Int?, Never>
        let saveButtonAction: AnyPublisher<Void, Never>
        let titleTextInputAction: AnyPublisher<String?, Never>
        let contentTextInputAction: AnyPublisher<String?, Never>
        let textActiveAction: AnyPublisher<Void, Never>
        let datePickerAction: AnyPublisher<Date, Never>
    }
    
    struct  Output {
        let images: AnyPublisher<[UIImage], Never>
        let didPressImageButton: AnyPublisher<Void, Never>
        let avatar: AnyPublisher<UIImage?, Never>
        let noResponse: AnyPublisher<Void, Never>
        let actionResponse: AnyPublisher<Result, Never>
        let state: AnyPublisher<State, Never>
        let initialNote: AnyPublisher<Note?, Never>
        let displayDate: AnyPublisher<Date, Never>
    }
    
    enum State {
        case display
        case edit
    }
}
