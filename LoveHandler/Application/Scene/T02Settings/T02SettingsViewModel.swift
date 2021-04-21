//
//  T02SettingsViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class T02SettingsViewModel: BaseViewModel {
    let dataSource = Section.generateData()
    
    private var navigator: T2SettingsNavigatorType
    
    init(navigator: T2SettingsNavigator) {
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        var selectedCell: Cell?
        
        let cellSelected = input.didSelectCell
            .do(onNext: {
                selectedCell = $0
            }).share()
            
            
        let dateCellSelected = cellSelected
            .filter { Cell.dateSelectionCell.contains($0) }
            .flatMap { [weak self] cell -> Observable<Date?> in
                guard let self = self else { return .just(nil)}
                switch cell {
                case .marryDateSelection:
                    return self.navigator.datePicker(title: "",
                                                     date: Settings.marryDate.value,
                                                     minDate: Settings.relationshipStartDate.value,
                                                     maxDate: Constant.maxDate)
                        .asObservable()
                case .startDatingDateSelection:
                    return self.navigator.datePicker(title: "",
                                                     date: Settings.relationshipStartDate.value,
                                                     minDate: Constant.minDate,
                                                     maxDate: Date())
                        .asObservable()
                default :
                    return .just(nil)
                }
            }.do(onNext: { date in
                guard let date = date, let cell = selectedCell else { return }
                switch cell {
                case .marryDateSelection:
                    Settings.marryDate.value = date
                case .startDatingDateSelection:
                    Settings.relationshipStartDate.value = date
                default:
                    break
                }
                selectedCell = nil
            })
            .map { _ in  Section.generateData() }
            .asDriverOnErrorJustComplete()
        
        let dissmiss = input.dismissTrigger.do(onNext: navigator.dismiss)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return Output(dataSource: dateCellSelected,
                      noRespone: dissmiss)
    }
    
    enum CellType {
        case normal(icon: String, title: String, isDisable: Bool = false)
        case withSwitch(icon: String, title: String, isOn: Bool = false)
        case withSubTitle(icon: String, title: String, subTitle: String)
        
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
        case showProgressWaveBackground
        case premium
        
        var info: CellInfo {
            switch self {
            case .startDatingDateSelection:
                return CellInfo(type: .withSubTitle(icon: "",
                                                    title: "Start Date",
                                                    subTitle: DefaultDateFormatter.string(from: Settings.relationshipStartDate.value,
                                                                                          dateFormat: "d/M/y")))
            case .marryDateSelection:
                return CellInfo(type: .withSubTitle(icon: "",
                                                    title: "End Date",
                                                    subTitle: DefaultDateFormatter.string(from: Settings.marryDate.value,
                                                                                          dateFormat: "d/M/y")))
            case .showProgressWaveBackground:
                return CellInfo(type: .withSwitch(icon: "",
                                                  title: "switch",
                                                  isOn: true))
                
            case .premium:
                return CellInfo(type: .normal(icon: "",
                                              title: "Premium",
                                              isDisable: false))
            }
        }
        
        static var dateSelectionCell: [Cell] = [.marryDateSelection, .startDatingDateSelection]
        
    }
    
    enum Section: CaseIterable {
        case premium
        case ui
        case dates
        
        var info: SectionInfo {
            switch self {
            case .dates:
                return SectionInfo(title: "Date Setting",
                                   cells: [.startDatingDateSelection,
                                           .marryDateSelection])
            case .ui:
                return SectionInfo(title: "View Settings",
                                   cells: [.showProgressWaveBackground])
            case .premium:
                return SectionInfo(title: "Premium",
                                   cells: [.premium])
            }
        }
        
        static func generateData() -> [SectionInfo] {
            return Self.allCases.map {$0.info}
        }
    }
    
    struct Input {
        let didSelectCell: Observable<Cell>
        let dismissTrigger: Observable<Void>
    }
    
    struct Output {
        let dataSource: Driver<[SectionInfo]>
        let noRespone: Driver<Void>
    }
}
