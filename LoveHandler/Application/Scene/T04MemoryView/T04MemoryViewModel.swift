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
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
    struct Input {
        let textFieldString: AnyPublisher<String, Error>
        let saveButtonTrigger: AnyPublisher<Void, Error>
        let chooseDateTrigger: AnyPublisher<Void, Error>
        let selectedImageTrigger: AnyPublisher<UIImage, Error>
    }
    
    struct Output {
        
    }
}
