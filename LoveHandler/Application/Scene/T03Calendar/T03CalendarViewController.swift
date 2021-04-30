//
//  T03CalendarViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 21/04/2021.
//

import UIKit

class T03CalendarViewController: BaseViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonView: UIButton!
    
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

    private let defaultDividerSize: CGFloat = 1
    
    private let allDates = Date().getAllDateInMonth()
    
    var viewModel: T03CalendarViewModel?
    
    override func setupView() {
        super.setupView()
        setupNavigationBar()
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
    }
    
    override func refreshView() {
        super.refreshView()
        let height = calculateCellSize()
        let numberOfRow = CGFloat(allDates.count / 7)
        calendarCollectionViewHeightConstraint.constant = height * numberOfRow + (numberOfRow + 1) * defaultDividerSize
    }
    
    override func setupTheme() {
        super.setupTheme()
        self.navigationController?.overrideUserInterfaceStyle = .light
        self.overrideUserInterfaceStyle = .light
        calendarCollectionView.backgroundColor = UIColor.gray
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        titleLabel.text = LocalizedString.t03SettingsTitle
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
    
    private func calculateCellSize() -> CGFloat {
        let marginsAndInsets = defaultDividerSize * 2 + calendarCollectionView.safeAreaInsets.left + calendarCollectionView.safeAreaInsets.right + defaultDividerSize * CGFloat(7 - 1)
        let itemWidth = ((calendarCollectionView.bounds.size.width - marginsAndInsets) / CGFloat(7)).rounded(.down)
        return itemWidth
    }
}

extension T03CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T03CalendarCollectionViewCell.className, for: indexPath) as? T03CalendarCollectionViewCell else { return UICollectionViewCell() }
        cell.bind(date: allDates[indexPath.item], isHavingData: true)
        return cell
    }
}


extension T03CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = calculateCellSize()
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return defaultDividerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return defaultDividerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: defaultDividerSize, left: defaultDividerSize, bottom: defaultDividerSize, right: defaultDividerSize)
    }
}
