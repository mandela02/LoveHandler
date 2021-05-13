//
//  T04ListNoteUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation

protocol T03CalendarUseCaseType {
    func getAllNote() -> [Note]
}

class T03CalendarUseCase: T03CalendarUseCaseType {
    private let repository: Repository<Note>
    
    init(repository: Repository<Note>) {
        self.repository = repository
    }
    
    func getAllNote() -> [Note] {
        repository.fetchAllData()
    }
}
