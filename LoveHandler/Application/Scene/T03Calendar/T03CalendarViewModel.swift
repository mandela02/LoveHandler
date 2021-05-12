//
//  T03CalendarViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation
import Combine

class T03CalendarViewModel: BaseViewModel {
    private var navigator: T03CalendarNavigatorType
    private var useCase: T03CalendarUseCaseType

    init(navigator: T03CalendarNavigatorType, useCase: T03CalendarUseCaseType) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let refDate = CurrentValueSubject<Date, Never>(Date())
        var canGo = true

        let backButtonPressed = input.backButtonPressed
            .handleEvents(receiveOutput: { [weak self] in
                self?.navigator.dissmiss()
            })
            .eraseToAnyPublisher()
        
        let gesture = input.swipeAction
            .handleEvents(receiveOutput: { direction in
                switch direction {
                case .left: refDate.send(refDate.value.nextMonth)
                case .right: refDate.send(refDate.value.previousMonth)
                }
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let dates = input.viewWillAppear
            .combineLatest(refDate.eraseToAnyPublisher())
            .map { $1.getAllDateInMonth() }
            .map { [weak self] dates -> [DateNote] in
                guard let self = self else { return [] }
                let notes = self.groupData()
                var dateNotes: [DateNote] = []
                for date in dates {
                    if notes.contains(where: { date.isInSameDay(as: $0.key) }) {
                        dateNotes.append(DateNote(date: date.startOfDay, notes: notes[date.startOfDay] ?? []))
                    } else {
                        dateNotes.append(DateNote(date: date.startOfDay, notes: []))
                    }
                }
                return dateNotes
            }
            .share()
            .eraseToAnyPublisher()
        
        let dateSelectAction = input.selectDateAction
            .combineLatest(dates)
            .map { path, datas -> DateNote?  in
                if let path = path {
                    return datas[safe: path.row]
                } else {
                    return datas.first(where: { $0.date.isInSameDay(as: Date()) })
                }
            }
            .share()
            .eraseToAnyPublisher()
        
        
        let addNoteButtonPressed = input.addNoteButtonPressed
            .handleEvents(receiveOutput: { _ in
                canGo = true
            })
            .combineLatest(dateSelectAction)
            .handleEvents(receiveOutput: { [weak self] _, date in
                guard let date = date else {
                    self?.navigator.toNote()
                    return
                }
                if canGo {
                    canGo = false
                    self?.navigator.toNote(with: date.date.setTime(hour: Date().hour, minutes: Date().minute) ?? Date())
                }
            })
            .map { _ in }
            .eraseToAnyPublisher()
        

        let noteSelectAction = input.selectNoteAction
            .handleEvents(receiveOutput: { _ in
                canGo = true
            })
            .combineLatest(dateSelectAction)
            .map { path, data in
                return data?.notes[safe: path.row]
            }
            .handleEvents(receiveOutput: { [weak self] note in
                guard let note = note else { return }
                if canGo {
                    canGo = false
                    self?.navigator.toNote(with: note)
                }
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let noResponse = Publishers.MergeMany([addNoteButtonPressed,
                                               backButtonPressed,
                                               noteSelectAction,
                                               gesture])
            .eraseToAnyPublisher()
                

        return Output(noResponse: noResponse,
                      datesInMonth: dates,
                      refDate: refDate.eraseToAnyPublisher(),
                      todayNotes: dateSelectAction)
    }
    
    private func groupData() -> [Date: [Note]] {
        let notes = useCase.getAllNote()
        let groupedNote = Dictionary(grouping: notes, by: { Date(timeIntervalSince1970: $0.displayDate).startOfDay })
        return groupedNote
    }
}

extension T03CalendarViewModel {
    struct Input {
        let backButtonPressed: AnyPublisher<Void, Never>
        let addNoteButtonPressed: AnyPublisher<Void, Never>
        let viewWillAppear: AnyPublisher<Void, Never>
        let viewDidLoad: AnyPublisher<Void, Never>
        let selectDateAction: AnyPublisher<IndexPath?, Never>
        let selectNoteAction: AnyPublisher<IndexPath, Never>
        let swipeAction: AnyPublisher<Direction, Never>
    }
    
    struct Output {
        let noResponse: AnyPublisher<Void, Never>
        let datesInMonth: AnyPublisher<[DateNote], Never>
        let refDate: AnyPublisher<Date, Never>
        let todayNotes: AnyPublisher<DateNote?, Never>
    }
    
    struct DateNote {
        let date: Date
        let notes: [Note]
    }
    
    enum Direction {
        case left
        case right
    }
}
