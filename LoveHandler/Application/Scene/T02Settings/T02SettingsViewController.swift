//
//  T02SettingsViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class T02SettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(title: "Back",
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        closeButton.tintColor = UIColor.white
        return closeButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
        
    var viewModel: T02SettingsViewModel?
    private var dataSource: [T02SettingsViewModel.SectionInfo] = []
    private var disposeBag = DisposeBag()
    
    override func setupView() {
        super.setupView()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
    }
        
    override func setupLocalizedString() {
        super.setupLocalizedString()
        titleLabel.text = "Settings"
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
        
        let didSelectCell =  tableView.rx.itemSelected.asObservable()
            .map {[weak self] indexPath -> T02SettingsViewModel.Cell? in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                return self?.viewModel?.dataSource[safe: indexPath.section]?.cells[safe: indexPath.row]
            }
            .compactMap { $0 }
        
        let input = T02SettingsViewModel.Input(didSelectCell: didSelectCell,
                                               dismissTrigger: closeButton.rx.tap.mapToVoid())
        
        let output = viewModel.transform(input)
        output.noRespone.drive().disposed(by: disposeBag)
        output.dataSource.drive(onNext: { [weak self] dataSource in
            self?.dataSource = dataSource
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension T02SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.dataSource.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dataSource[safe: section]?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let sectionInfo = viewModel.dataSource[safe: indexPath.section]
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
        return cell
        case .withSubTitle(icon: let icon, title: let title, subTitle: let subTitle):
            let cell = tableView.dequeueReusableCell(SettingWithSubTitleTableViewCell.self, for: indexPath)
            cell.bind(icon: icon, title: title, subTitle: subTitle)
            return cell
        }
        
    }
}

extension T02SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
}
