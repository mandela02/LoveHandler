//
//  T03CalendarViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 21/04/2021.
//

import UIKit
import CombineCocoa
import Combine

class T03CalendarViewController: BaseViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addNoteButton: UIButton!
    
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()

    private let defaultDividerSize: CGFloat = 1
    var viewModel: T03CalendarViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var viewWillAppear = PassthroughSubject<Void, Never>()
    private var viewDidLoad = PassthroughSubject<Void, Never>()
    private var allDates: [T03CalendarViewModel.DateNote] = []
    private var selectedDateIndexPath = PassthroughSubject<IndexPath, Never>()
    private var selectedNoteIndexPath = PassthroughSubject<IndexPath, Never>()
    private var today: T03CalendarViewModel.DateNote?

    deinit {
        cancellables.forEach { $0.cancel() }
        viewWillAppear.send(completion: .finished)
        viewDidLoad.send(completion: .finished)
    }
    
    override func setupView() {
        super.setupView()
        setupNavigationBar()
        
        viewDidLoad.send(Void())
        
        self.noteTableView.isHidden = true
        self.noDataView.isHidden = true
        
        noDataLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        noteTableView.dataSource = self
        noteTableView.delegate = self
    }
    
    override func refreshView() {
        super.refreshView()
        viewWillAppear.send(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
        
    override func setupTheme() {
        super.setupTheme()
        self.navigationController?.overrideUserInterfaceStyle = .light
        self.overrideUserInterfaceStyle = .light
        calendarCollectionView.backgroundColor = UIColor.gray
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        noDataLabel.text = "No data"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel else { return }
                
        let input = T03CalendarViewModel.Input(backButtonPressed: closeButton.tapPublisher,
                                               addNoteButtonPressed: addNoteButton.tapPublisher,
                                               viewWillAppear: viewWillAppear.eraseToAnyPublisher(),
                                               viewDidLoad: viewDidLoad.eraseToAnyPublisher(),
                                               selectDateAction: selectedDateIndexPath.eraseToAnyPublisher(),
                                               selectNoteAction: selectedNoteIndexPath.eraseToAnyPublisher())
        let output = viewModel.transform(input)
        
        output.noResponse
            .receive(on: DispatchQueue.main)
            .sink {}
            .store(in: &cancellables)
        
        output.datesInMonth
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.allDates = $0
                self.calculateCalendarHeight()
                self.calendarCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        output.refDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.titleLabel.text = "\($0.month)"
            }
            .store(in: &cancellables)
        
        output.todayNotes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notes in
                guard let self = self else { return }
                self.today = notes
                self.calendarCollectionView.reloadData()
                self.noteTableView.reloadData()
                
                if let notes = notes?.notes, notes.isEmpty {
                    self.noteTableView.isHidden = true
                    self.noDataView.isHidden = false
                } else {
                    self.noteTableView.isHidden = false
                    self.noDataView.isHidden = true
                }
            }
            .store(in: &cancellables)
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
        let marginsAndInsets = defaultDividerSize * 2 +
            calendarCollectionView.safeAreaInsets.left +
            calendarCollectionView.safeAreaInsets.right +
            defaultDividerSize *
            CGFloat(7 - 1)
        
        let itemWidth = ((calendarCollectionView.bounds.size.width - marginsAndInsets) / CGFloat(7)).rounded(.down)
        return itemWidth
    }
    
    private func calculateCalendarHeight() {
        let height = calculateCellSize()
        let numberOfRow = CGFloat(allDates.count / 7)
        calendarCollectionViewHeightConstraint.constant = height * numberOfRow + (numberOfRow + 1) * defaultDividerSize
    }
}

extension T03CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T03CalendarCollectionViewCell.className, for: indexPath) as? T03CalendarCollectionViewCell else { return UICollectionViewCell() }
        guard let data = allDates[safe: indexPath.item] else { return UICollectionViewCell() }
        cell.bind(date: data.date, isHavingData: !data.notes.isEmpty, isSelected: today?.date == data.date)
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

extension T03CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = allDates[safe: indexPath.item], data.date.isInSameMonth(as: Date()) else { return }
        selectedDateIndexPath.send(indexPath)
    }
}

extension T03CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedNoteIndexPath.send(indexPath)
    }
}

extension T03CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return today?.notes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: T03CalendarNoteTableViewCell.className, for: indexPath) as? T03CalendarNoteTableViewCell else {
            return UITableViewCell()
        }
        guard let data = today?.notes[safe: indexPath.row] else { return UITableViewCell() }
        cell.setupCell(with: data)
        return cell
    }
}
