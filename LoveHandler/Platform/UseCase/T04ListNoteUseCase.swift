//
//  T04ListNoteUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation

protocol T04ListNoteUseCaseType {
    func getAllNote() -> [Note]
}

class T04ListNoteUseCase: T04ListNoteUseCaseType {
    private let repository: Repository<Note>
    
    init(repository: Repository<Note>) {
        self.repository = repository
    }
    
    func getAllNote() -> [Note] {
        repository.fetchAllData()
    }
}
