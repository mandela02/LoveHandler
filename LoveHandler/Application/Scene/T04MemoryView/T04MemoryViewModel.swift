//
//  T04MemoryViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 12/06/2021.
//

import Foundation
import Combine
import UIKit

class T04MemoryViewModel: BaseViewModel {
    private var navigator: T04MemoryNavigatorType
    private var useCase: T04MemoryUseCaseType
    private var memory: CDMemory?
    
    init(navigator: T04MemoryNavigatorType, useCase: T04MemoryUseCaseType, memory: CDMemory? = nil) {
        self.navigator = navigator
        self.useCase = useCase
        self.memory = memory
    }
    
    func transform(_ input: Input) -> Output {
        let viewPurpose = CurrentValueSubject<Purpose, Never>(memory == nil ? .new : .update(memory: memory!))
        
        let isSaveButtonEnable = CurrentValueSubject<Bool, Never>(false)

        var image: UIImage = UIImage()
        var date: Date = Date()
        var content: String = ""
        
        let id: UUID? = memory == nil ? UUID() : memory?.id
        
        let chooseDateTrigger = input.chooseDateTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Date?, Never> in
                guard let self = self else { return Empty(completeImmediately: false).eraseToAnyPublisher()}
                return self.navigator.datePicker(title: LocalizedString.t04MemoryDatePickerTitle,
                                                 date: Date(),
                                                 minDate: Constant.minDate,
                                                 maxDate: Constant.maxDate)
                    .eraseToAnyPublisher()
            }
            .compactMap { $0 }
            .handleEvents(receiveOutput: {date = $0})
            .eraseToAnyPublisher()
        
        let save = input.saveButtonTrigger
            .map { [weak self]  _ -> DatabaseResponse? in
                guard let self = self else { return nil }
                guard let data = image.jpeg(.low) else { return nil }
                
                switch viewPurpose.value {
                case .new:
                    let result = self.useCase.save(id: id!,
                                                   image: data,
                                                   title: content,
                                                   displayDate: date)
                    return result
                case .update(memory: let memory):
                    memory.image = data
                    memory.title = content
                    memory.displayedDate = date.timeIntervalSince1970
                    memory.updatedDate = Date().timeIntervalSince1970
                    return self.useCase.update(memory: memory)
                }
            }
            .map { _ in }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.navigator.dismiss()
            })
            .eraseToAnyPublisher()
        
        let progressInputImage = input.selectedImageTrigger
            .handleEvents(receiveOutput: {
                image = $0
                isSaveButtonEnable.send(true)
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let progressInputString = input.textFieldString
            .handleEvents(receiveOutput: {
                content = $0
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let noResponse = Publishers.MergeMany([save, progressInputImage, progressInputString])
            .eraseToAnyPublisher()
        
        return Output(image: input.selectedImageTrigger,
                      date: chooseDateTrigger,
                      viewPurpose: viewPurpose.eraseToAnyPublisher(),
                      initialContent: Just(memory).eraseToAnyPublisher(),
                      isSaveButtonEnable: isSaveButtonEnable.eraseToAnyPublisher(),
                      noResponse: noResponse)
    }
    
    struct Input {
        let textFieldString: AnyPublisher<String, Never>
        let saveButtonTrigger: AnyPublisher<Void, Never>
        let chooseDateTrigger: AnyPublisher<Void, Never>
        let selectedImageTrigger: AnyPublisher<UIImage, Never>
    }
    
    struct Output {
        let image: AnyPublisher<UIImage, Never>
        let date: AnyPublisher<Date, Never>
        let viewPurpose: AnyPublisher<Purpose, Never>
        let initialContent: AnyPublisher<CDMemory?, Never>
        let isSaveButtonEnable: AnyPublisher<Bool, Never>
        let noResponse: AnyPublisher<Void, Never>
    }
}

enum Purpose {
    case new
    case update(memory: CDMemory)
}
