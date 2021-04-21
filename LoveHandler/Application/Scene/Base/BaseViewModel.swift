//
//  BaseViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 19/04/2021.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) -> Output
}
