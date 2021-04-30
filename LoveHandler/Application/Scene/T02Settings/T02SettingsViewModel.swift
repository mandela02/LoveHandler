//
//  T02SettingsViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import Foundation

class T02SettingsViewModel: BaseViewModel {    
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
                    return self.navigator.datePicker(title: LocalizedString.t03WeddingDayDatePickerTitle,
                                                     date: Settings.marryDate.value,
                                                     minDate: Settings.relationshipStartDate.value,
                                                     maxDate: Constant.maxDate)
                        .asObservable()
                case .startDatingDateSelection:
                    return self.navigator.datePicker(title: LocalizedString.t03StartDatingDatePickerTitle,
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
            .mapToVoid()
        
        let viewWillAppear = input.viewWillAppear
        
        let dataSource = Observable.merge(viewWillAppear,
                                          dateCellSelected)
            .map { _ in  Section.generateData() }
            .asDriverOnErrorJustComplete()
        
        let dissmiss = input.dismissTrigger.do(onNext: navigator.dismiss)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return Output(dataSource: dataSource,
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
                                                    title: LocalizedString.t03StartDateTitle,
                                                    subTitle: DefaultDateFormatter.string(from: Settings.relationshipStartDate.value,
                                                                                          dateFormat: "d/M/y")))
            case .marryDateSelection:
                return CellInfo(type: .withSubTitle(icon: "",
                                                    title: LocalizedString.t03EndDateTitle,
                                                    subTitle: DefaultDateFormatter.string(from: Settings.marryDate.value,
                                                                                          dateFormat: "d/M/y")))
            case .showProgressWaveBackground:
                return CellInfo(type: .withSwitch(icon: "",
                                                  title: LocalizedString.t02WaveBackgroundTitle,
                                                  isOn: Settings.isShowingBackgroundWave.value))
                
            case .premium:
                return CellInfo(type: .normal(icon: "",
                                              title: LocalizedString.t03PremiumTitle,
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
                return SectionInfo(title: LocalizedString.t03DataHeaderTitle,
                                   cells: [.startDatingDateSelection,
                                           .marryDateSelection])
            case .ui:
                return SectionInfo(title: LocalizedString.t03ViewHeaderitle,
                                   cells: [.showProgressWaveBackground])
            case .premium:
                return SectionInfo(title: LocalizedString.t03PremiumHeaderitle,
                                   cells: [.premium])
            }
        }
        
        static func generateData() -> [SectionInfo] {
            return Self.allCases.map {$0.info}
        }
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let didSelectCell: Observable<Cell>
        let dismissTrigger: Observable<Void>
    }
    
    struct Output {
        let dataSource: Driver<[SectionInfo]>
        let noRespone: Driver<Void>
    }
}
