//
//  T02SettingsViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import UIKit
import Combine

class T02SettingsViewModel: BaseViewModel {    
    private var navigator: T2SettingsNavigatorType
    
    init(navigator: T2SettingsNavigatorType) {
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        var selectedCell: Cell?
        
        let cellSelected = input.didSelectCell
            .handleEvents(receiveOutput: {
                selectedCell = $0
            }).share()
            
        let dateCellSelected = cellSelected
            .filter { Cell.dateSelectionCell.contains($0) }
            .flatMap { [weak self] cell -> AnyPublisher<Date?, Never> in
                guard let self = self else { return Empty(completeImmediately: false).eraseToAnyPublisher()}
                switch cell {
                case .marryDateSelection:
                    return self.navigator.datePicker(title: LocalizedString.t02WeddingDayDatePickerTitle,
                                                     date: Settings.weddingDate.value,
                                                     minDate: Settings.relationshipStartDate.value,
                                                     maxDate: Constant.maxDate)
                        .eraseToAnyPublisher()
                case .startDatingDateSelection:
                    return self.navigator.datePicker(title: LocalizedString.t02StartDatingDatePickerTitle,
                                                     date: Settings.relationshipStartDate.value,
                                                     minDate: Constant.minDate,
                                                     maxDate: Date())
                        .eraseToAnyPublisher()
                default :
                    return Empty(completeImmediately: false).eraseToAnyPublisher()
                }
            }
            .handleEvents(receiveOutput: { date in
                guard let date = date, let cell = selectedCell else { return }
                switch cell {
                case .marryDateSelection:
                    Settings.weddingDate.value = date
                case .startDatingDateSelection:
                    Settings.relationshipStartDate.value = date
                default:
                    break
                }
                selectedCell = nil
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let viewWillAppear = input.viewWillAppear
        
        let onSelectCell = cellSelected
            .handleEvents(receiveOutput: { [weak self] cell in
                guard let self = self else {
                    return
                }
                switch cell {
                case .background:
                    self.navigator.toBackgroundView()
                case .language:
                    self.navigator.toLanguage()
                default:
                    return
                }
            })
            .map { _ in }
            .eraseToAnyPublisher()
        
        let dataSource = Publishers.Merge(viewWillAppear,
                                          dateCellSelected)
            .map { _ in  Section.generateData() }
            .eraseToAnyPublisher()
                
        let dissmiss = input.dismissTrigger.handleEvents(receiveOutput: navigator.dismiss)
            .map { _ in }
            .eraseToAnyPublisher()

        let noReponse = Publishers.MergeMany([dissmiss, onSelectCell])
            .eraseToAnyPublisher()

        return Output(dataSource: dataSource,
                      noRespone: noReponse)
    }
    
    enum CellType {
        case plain(title: String, isDisable: Bool = false)
        case normal(icon: UIImage, title: String, isDisable: Bool = false)
        case withSwitch(icon: UIImage, title: String, isOn: Bool = false)
        case withSubTitle(icon: UIImage, title: String, subTitle: String)
    }
    
    struct CellInfo {
        let type: CellType
    }
    
    struct SectionInfo {
        var title: String = ""
        var footer: String = ""
        var cells: [Cell]
    }
    
    enum Cell {
        case startDatingDateSelection
        case marryDateSelection
        case premium
        case theme
        case background
        case heartAnimation
        case language
        case passcode
        case deleteAll

        var info: CellInfo {
            switch self {
            case .startDatingDateSelection:
                return CellInfo(type: .withSubTitle(icon: SystemImage.faceDashFill.image,
                                                    title: LocalizedString.t02StartDateTitle,
                                                    subTitle: DefaultDateFormatter.string(from: Settings.relationshipStartDate.value,
                                                                                          dateFormat: "d/M/y")))
            case .marryDateSelection:
                return CellInfo(type: .withSubTitle(icon: SystemImage.faceDashFill.image,
                                                    title: LocalizedString.t02EndDateTitle,
                                                    subTitle: DefaultDateFormatter.string(from: Settings.weddingDate.value,
                                                                                          dateFormat: "d/M/y")))                
            case .premium:
                return CellInfo(type: .normal(icon: SystemImage.dollarsignCircleFill.image,
                                              title: LocalizedString.t02PremiumTitle,
                                              isDisable: false))
            case .theme:
                return CellInfo(type: .normal(icon: SystemImage.sunMinFill.image,
                                              title: LocalizedString.t02ThemeCellTitle,
                                              isDisable: false))
            case .language:
                return CellInfo(type: .normal(icon: SystemImage.language.image,
                                              title: LocalizedString.t02LanguageCellTitle,
                                              isDisable: false))
            case .background:
                return CellInfo(type: .normal(icon: SystemImage.background.image,
                                              title: LocalizedString.t02BackgroundCellTitle,
                                              isDisable: false))
            case .heartAnimation:
                return CellInfo(type: .normal(icon: SystemImage.heartCircleFill.image,
                                              title: LocalizedString.t02HeartAnimationCellTitle,
                                              isDisable: false))
            case .passcode:
                return CellInfo(type: .normal(icon: SystemImage.lockFill.image,
                                              title: LocalizedString.t02PasscodeCellTitle,
                                              isDisable: false))
            case .deleteAll:
                return CellInfo(type: .plain(title: LocalizedString.t02DeleteAllCellTitle,
                                              isDisable: false))
            }
        }
        
        static var dateSelectionCell: [Cell] = [.marryDateSelection, .startDatingDateSelection]
        
    }
    
    enum Section: CaseIterable {
        case premium
        case ui
        case dates
        case utilities
        case delete
        
        var info: SectionInfo {
            switch self {
            case .dates:
                return SectionInfo(title: LocalizedString.t02DataHeaderTitle,
                                   cells: [.startDatingDateSelection,
                                           .marryDateSelection,
                                           .background])
            case .ui:
                return SectionInfo(title: LocalizedString.t02ViewHeaderitle,
                                   cells: [.theme,
                                           .heartAnimation])
            case .premium:
                return SectionInfo(title: LocalizedString.t02PremiumHeaderitle,
                                   cells: [.premium])
            case .utilities:
                return SectionInfo(title: "",
                                   cells: [.language,
                                           .passcode])
            case .delete:
                return SectionInfo(title: "",
                                   cells: [.deleteAll])
            }
        }
        
        static func generateData() -> [SectionInfo] {
            return Self.allCases.map {$0.info}
        }
    }
    
    struct Input {
        let viewWillAppear: AnyPublisher<Void, Never>
        let didSelectCell: AnyPublisher<Cell, Never>
        let dismissTrigger: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let dataSource: AnyPublisher<[SectionInfo], Never>
        let noRespone: AnyPublisher<Void, Never>
    }
}
