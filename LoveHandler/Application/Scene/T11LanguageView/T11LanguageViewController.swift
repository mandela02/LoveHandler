//
//  T11LanguageViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 11/07/2021.
//

import UIKit
import Combine

class T11LanguageViewController: BaseViewController {
    @IBOutlet weak var languageTableView: UITableView!
    
    private var cancellables = Set<AnyCancellable>()

    override func setupView() {
        languageTableView.dataSource = self
        languageTableView.delegate = self
        isBackButtonVisible = false
        isTitleVisible = true
    }
    
    override func setupTheme() {
        super.setupTheme()        
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = LocalizedString.t11LanguageNavigationTitle
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        closeButton.tapPublisher.sink { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        .store(in: &cancellables)
    
    }
}

extension T11LanguageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageCode.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)

        let code = LanguageCode.getLanguageCode(from: indexPath.row)
        cell.textLabel!.text = code.name
        cell.accessoryType = code.rawValue == Settings.appLanguage.value ? .checkmark : .none
        cell.backgroundColor = UIColor(hexString: "FFFFFF")
        return cell
    }
}

extension T11LanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Settings.appLanguage.value = LanguageCode.getLanguageCode(from: indexPath.row).rawValue
        tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Strings.languageChangedObserver), object: nil)
    }
}
