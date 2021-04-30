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
    
    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(title: "Back",
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        return closeButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
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
    private var onViewWillAppearSignal = PassthroughSubject<Void, Never>()

    deinit {
        onCellSelected.send(completion: .finished)
        onViewWillAppearSignal.send(completion: .finished)
        
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
        titleLabel.text = LocalizedString.t03SettingsTitle
        tableFooterViewLabel.text = getFooter()
    }
    
    private func setupNavigationBar() {
        let view = UIView()
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.layoutIfNeeded()
        view.sizeToFit()
        
        navigationItem.titleView = view
        navigationItem.leftBarButtonItem = closeButton
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
        
        let input = T02SettingsViewModel.Input(viewWillAppear: onViewWillAppearSignal.eraseToAnyPublisher(),
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
        self.overrideUserInterfaceStyle = .light
        self.navigationController?.overrideUserInterfaceStyle = .light
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
}

extension T02SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[safe: section]?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionInfo = dataSource[safe: indexPath.section]
        else { return UITableViewCell() }
        let row = sectionInfo.cells[indexPath.row]
        switch row.info.type {
        case .normal(let icon, let title, let isDisable):
            let cell = tableView.dequeueReusableCell(NormalSettingTableViewCell.self, for: indexPath)
            cell.bind(icon: icon, title: title)
            return cell
        case .withSwitch(let icon, let title, let isOn):
            let cell = tableView.dequeueReusableCell(SettingWithSwitchTableViewCell.self, for: indexPath)
            cell.bind(icon: icon, title: title, isOn: isOn)
            cell.didValueChange = { value in
                if row == .showProgressWaveBackground {
                    Settings.isShowingBackgroundWave.value = value
                }
            }
            return cell
        case .withSubTitle(icon: let icon, title: let title, subTitle: let subTitle):
            let cell = tableView.dequeueReusableCell(SettingWithSubTitleTableViewCell.self, for: indexPath)
            cell.bind(icon: icon, title: title, subTitle: subTitle)
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
        let cell = dataSource[indexPath.section].cells[indexPath.row]
        if cell == .showProgressWaveBackground {
            return false
        } else {
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
