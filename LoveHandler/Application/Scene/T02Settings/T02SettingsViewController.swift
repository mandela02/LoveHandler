//
//  T02SettingsViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import UIKit
import Combine
import CombineCocoa

class T02SettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var tableFooterViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = getFooter()
        return label
    }()

    var viewModel: T02SettingsViewModel?
    private var dataSource: [T02SettingsViewModel.SectionInfo] = []
    private var cancellables = Set<AnyCancellable>()
    
    private var onCellSelected = PassthroughSubject<IndexPath, Never>()
    private var onReloadNeeded = PassthroughSubject<Void, Never>()
    private var onViewWillAppearSignal = PassthroughSubject<Void, Never>()

    override func deinitView() {
        onCellSelected.send(completion: .finished)
        onViewWillAppearSignal.send(completion: .finished)
        onReloadNeeded.send(completion: .finished)
        cancellables.forEach { $0.cancel() }
    }
    
    override func setupView() {
        super.setupView()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
        tableView.tableFooterView = getTableFooterView()
    }
    
    override func refreshView() {
        super.refreshView()
        onViewWillAppearSignal.send(Void())
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = LocalizedString.t02SettingsTitle
        tableFooterViewLabel.text = getFooter()
    }
    
    private func setupNavigationBar() {
        isTitleVisible = true
        isBackButtonVisible = true
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel else { return }
        
        let didSelectCell =  onCellSelected
            .map {[weak self] indexPath -> T02SettingsViewModel.Cell? in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                return self?.dataSource[safe: indexPath.section]?.cells[safe: indexPath.row]
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let input = T02SettingsViewModel.Input(reloadDataNeeded: onReloadNeeded.eraseToAnyPublisher(),
                                               viewWillAppear: onViewWillAppearSignal.eraseToAnyPublisher(),
                                               didSelectCell: didSelectCell,
                                               dismissTrigger: closeButton.tapPublisher)
        
        let output = viewModel.transform(input)
        
        output.noRespone.sink(receiveValue: {}).store(in: &cancellables)
        
        output.dataSource.sink(receiveValue: { [weak self] dataSource in
            self?.dataSource = dataSource
            self?.tableView.reloadData()
        })
        .store(in: &cancellables)
    }
    
    override func setupTheme() {
        super.setupTheme()
        self.tableView.backgroundColor = Theme.current.tableViewColor.background
        self.tableView.indicatorStyle = Theme.current.tableViewColor.indicatorStyle
    }
    
    private func getFooter() -> String {
        return "\(LocalizedString.appName) \(Utilities.version)"
    }
    
    private func getTableFooterView() -> UIView {
        let footer = UIView()
        footer.backgroundColor = .clear
        footer.addSubview(tableFooterViewLabel)
        [tableFooterViewLabel.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
         tableFooterViewLabel.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 20)]
            .forEach { $0.isActive = true }
        return footer
    }
    
    override func didPurchaseSomething(isSuccess: Bool) {
        super.didPurchaseSomething(isSuccess: isSuccess)
        let title = isSuccess ? "Sucess" : "Error"
        let message = isSuccess ? "All ads is removed" : "Something happende"
        
        UIAlertController.alertDialog(title: title, message: message, argument: 0)
            .sink(receiveValue: { _ in })
            .store(in: &cancellables)
    }
}

extension T02SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[safe: section]?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionInfo = dataSource[safe: indexPath.section]
        else { return UITableViewCell() }
        let row = sectionInfo.cells[indexPath.row]
        switch row.info.type {
        case .normal(let icon, let title, _):
            let cell = tableView.dequeueReusableCell(NormalSettingTableViewCell.self, for: indexPath)
            cell.bind(icon: icon, title: title)
            return cell
        case .withSwitch(let icon, let title, let isOn):
            let cell = tableView.dequeueReusableCell(SettingWithSwitchTableViewCell.self, for: indexPath)
            cell.bind(icon: icon, title: title, isOn: isOn)
            cell.didValueChange = { isSwitchOn in
                Settings.isUsingPasscode.value = isSwitchOn
                if isSwitchOn {
                    PasscodeHelper.create(at: self)
                }
            }
            return cell
        case .withSubTitle(icon: let icon, title: let title, subTitle: let subTitle):
            let cell = tableView.dequeueReusableCell(SettingWithSubTitleTableViewCell.self, for: indexPath)
            cell.bind(icon: icon, title: title, subTitle: subTitle)
            return cell
        case .plain(title: let title, isDisable: _):
            let cell = T02PlainTableViewCell()
            cell.setupCell(title: title)
            return cell
        }
        
    }
}

extension T02SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellSelected.send(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let sectionInfo = dataSource[safe: indexPath.section]
        else { return false }
        let row = sectionInfo.cells[indexPath.row]
        switch row.info.type {
        case .withSwitch(icon: _, title: _, isOn: _):
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.getHeaderViewForSection(with: dataSource[safe: section]?.title ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let title = dataSource[safe: section]?.title, !title.isEmpty else { return 0 }
        return 34
    }
}
