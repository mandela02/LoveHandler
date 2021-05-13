//
//  T05NoteUseCase.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation

enum Result {
    case success
    case failure(error: String)
}

protocol T05NoteUseCaseType {
    func save(note: Note) -> Result
    func update(note: Note) -> Result
}


class T05NoteUseCase: T05NoteUseCaseType {
    private let repository: Repository<Note>
    
    init(repository: Repository<Note>) {
        self.repository = repository
    }
    
    func save(note: Note) -> Result {
        do {
            try repository.save(model: note)
            return .success
        } catch let error {
            return .failure(error: error.localizedDescription)
        }
    }
    
    func update(note: Note) -> Result {
        let id = note.id
        do {
            try repository.update(model: note, at: id)
            return .success
        } catch let error {
            return .failure(error: error.localizedDescription)
        }
    }
}


