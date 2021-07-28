//
//  T02SettingsViewModel.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import UIKit
import Combine
import StoreKit

class T02SettingsViewModel: BaseViewModel {
    private lazy var appUrl = "https://apps.apple.com/app/id\(AppConfig.appID)?mt=8"

    private var navigator: T2SettingsNavigatorType
    
    init(navigator: T2SettingsNavigatorType) {
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        let onSelectCell = input.didSelectCell
            .handleEvents(receiveOutput: { [weak self] cell in
                guard let self = self else {
                    return
                }
                switch cell {
                case .background:
                    self.navigator.toBackgroundView()
                case .language:
                    self.navigator.toLanguage()
                case .dateSetup:
                    self.navigator.toAnniversary()
                case .appStoreRate:
                    self.rateOnAppStore()
                case .shareToFriend:
                    self.navigator.shareAppToFriend(appUrl: self.appUrl)
                case .theme:
                    self.navigator.toThemeSetting()
                default:
                    return
                }
            })
            .map { _ in }
            .eraseToAnyPublisher()

        let viewWillAppear = input.viewWillAppear
        
        let reloadDataNeeded = input.reloadDataNeeded
        
        let dataSource = Publishers.Merge(viewWillAppear, reloadDataNeeded)
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
    
    private func rateOnAppStore() {
        SKStoreReviewController.requestReviewInCurrentScene()
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
        case dateSetup
        case premium
        case theme
        case background
        case language
        case passcode
        case deleteAll
        case appStoreRate
        case shareToFriend

        var info: CellInfo {
            switch self {
            case .dateSetup:
                return CellInfo(type: .normal(icon: SystemImage.language.image,
                                              title: LocalizedString.t02MemoDateCellTitle,
                                              isDisable: false))
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
            case .passcode:
                return CellInfo(type: .withSwitch(icon: SystemImage.lockFill.image,
                                              title: LocalizedString.t02PasscodeCellTitle,
                                              isOn: Settings.isUsingPasscode.value))
            case .deleteAll:
                return CellInfo(type: .plain(title: LocalizedString.t02DeleteAllCellTitle,
                                              isDisable: false))
            case .appStoreRate:
                return CellInfo(type: .normal(icon: SystemImage.handThumsUpFill.image,
                                              title: LocalizedString.t02AppStoreRateTitle,
                                              isDisable: false))
            case .shareToFriend:
                return CellInfo(type: .normal(icon: SystemImage.clapSparklesFill.image,
                                              title: LocalizedString.t02ShareTitle,
                                              isDisable: false))
            }
        }
    }
    
    enum Section: CaseIterable {
        case premium
        case ui
        case dates
        case utilities
        case share
        case delete
        
        var info: SectionInfo {
            switch self {
            case .dates:
                return SectionInfo(title: LocalizedString.t02DataHeaderTitle,
                                   cells: [.dateSetup,
                                           .background])
            case .ui:
                return SectionInfo(title: LocalizedString.t02ViewHeaderitle,
                                   cells: [.theme])
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
            case .share:
                return SectionInfo(title: "",
                                   cells: [.appStoreRate,
                                           .shareToFriend])
            }
        }
        
        static func generateData() -> [SectionInfo] {
            return Self.allCases.map {$0.info}
        }
    }
    
    struct Input {
        let reloadDataNeeded: AnyPublisher<Void, Never>
        let viewWillAppear: AnyPublisher<Void, Never>
        let didSelectCell: AnyPublisher<Cell, Never>
        let dismissTrigger: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let dataSource: AnyPublisher<[SectionInfo], Never>
        let noRespone: AnyPublisher<Void, Never>
    }
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            requestReview(in: scene)
        }
    }
}
