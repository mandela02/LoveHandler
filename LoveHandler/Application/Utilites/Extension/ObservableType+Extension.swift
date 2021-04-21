//
//  ObservableType+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 19/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
