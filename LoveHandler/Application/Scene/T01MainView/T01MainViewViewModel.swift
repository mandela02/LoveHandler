//
//  T01MainViewViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 19/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class T01MainViewViewModel: BaseViewModel {
    private var navigator: T01MainViewNavigatorType

    init(navigator: T01MainViewNavigatorType) {
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
    struct Input {}
    struct Output {}
}
