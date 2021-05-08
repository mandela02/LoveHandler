//
//  UseCaseProvider.swift
//  LoveHandler
//
//  Created by LanNTH on 04/05/2021.
//

import Foundation

class UseCaseProvider {
    static let defaultProvider = UseCaseProvider()
    
    private lazy var noteRepository = Repository<Note>(container: PersistenceManager.shared.persistentContainer)
    
    private lazy var noteUseCase = T05NoteUseCase(repository: noteRepository)
    private lazy var calendarUseCase = T03CalendarUseCase(repository: noteRepository)

    private init() {}
    
    func getNotesUseCase() -> T05NoteUseCaseType {
        return noteUseCase
    }
    
    func getCalendarUseCase() -> T03CalendarUseCaseType {
        return calendarUseCase
    }
}
