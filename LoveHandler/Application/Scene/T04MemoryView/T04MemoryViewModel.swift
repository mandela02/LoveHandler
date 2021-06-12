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
        let viewPurpose = CurrentValueSubject<Purpose, Never>(memory == nil ? .new : .update)
        
        let date = input.chooseDateTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Date?, Never> in
                guard let self = self else { return Empty(completeImmediately: false).eraseToAnyPublisher()}
                return self.navigator.datePicker(title: LocalizedString.t03WeddingDayDatePickerTitle,
                                                 date: Settings.marryDate.value,
                                                 minDate: Settings.relationshipStartDate.value,
                                                 maxDate: Constant.maxDate)
                    .eraseToAnyPublisher()
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()

        return Output(image: input.selectedImageTrigger,
                      date: date,
                      viewPurpose: viewPurpose.eraseToAnyPublisher())
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
    }
}

enum Purpose {
    case new
    case update
}
