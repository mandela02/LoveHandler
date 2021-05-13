//
//  T05NoteViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import UIKit
import Combine
import DatePickerDialog

class T05NoteViewController: BaseViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    
    private var saveButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(title: "Save",
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        closeButton.tintColor = UIColor.white
        return closeButton
    }()

    private var editButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(title: "Edit",
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
    
    var viewModel: T05NoteViewModel?
    
    private let defaultDividerSize: CGFloat = 1
    private var picker: ImagePickerHelper?
    private var tapGesture: UITapGestureRecognizer?
    
    private var cancellables = Set<AnyCancellable>()
    private var cameraImage = CurrentValueSubject<UIImage?, Never>(nil)
    private var libraryImage = CurrentValueSubject<[UIImage], Never>([])
    
    private var deletedImage = PassthroughSubject<Int?, Never>()
    private var seletedImage = PassthroughSubject<Int?, Never>()
    private var images = CurrentValueSubject<[UIImage], Never>([])
    
    private var avatar = CurrentValueSubject<UIImage?, Never>(nil)
    
    private var viewDidDisappear = PassthroughSubject<Void, Never>()

    private var refDate = Date()

    deinit {
        cancellables.forEach { $0.cancel() }
        cameraImage.send(completion: .finished)
        libraryImage.send(completion: .finished)
        deletedImage.send(completion: .finished)
        seletedImage.send(completion: .finished)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
            
    override func dismissView() {
        super.dismissView()
        viewDidDisappear.send(Void())
    }
    
    override func setupView() {
        super.setupView()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        picker = ImagePickerHelper(title: "Image", message: "Image", isMultiplePick: true)
        picker?.delegate = self
        
        titleTextField.borderStyle = .none
        contentTextView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        setupNavigationBar()
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
        self.navigationItem.rightBarButtonItem = saveButton
        setupGesture()
    }
    
    private func setupGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action:nil)
        if let tapGesture = tapGesture {
            titleLabel.isUserInteractionEnabled = true
            titleLabel.addGestureRecognizer(tapGesture)
        }
    }

    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = viewModel, let tapGesture = tapGesture else { return }
        
        let textActiveAction = Publishers.Merge(titleTextField.controlEventPublisher(for: .editingDidBegin).eraseToAnyPublisher(),
                                                NotificationCenter.default
                                                    .publisher(for: UITextView.textDidBeginEditingNotification,
                                                               object: contentTextView)
                                                    .receive(on: RunLoop.main)
                                                    .map { _ in }
                                                    .eraseToAnyPublisher())
            .eraseToAnyPublisher()
        
        
        let datePickerAction = tapGesture.tapPublisher
            .flatMap { [weak self] _ -> AnyPublisher<Date?, Never> in
                guard let self = self else {
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
                return self.datePicker(title: "", date: self.refDate, minDate: Constant.minDate, maxDate: Constant.maxDate)
                    .eraseToAnyPublisher()
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let input = T05NoteViewModel.Input(imageButtonPressed: addImageButton.tapPublisher,
                                           cameraImage: cameraImage.eraseToAnyPublisher(),
                                           libraryImages: libraryImage.eraseToAnyPublisher(),
                                           deleteButtonPressed: deletedImage.eraseToAnyPublisher(),
                                           seletedCell: seletedImage.eraseToAnyPublisher(),
                                           saveButtonAction: saveButton.tapPublisher.eraseToAnyPublisher(),
                                           titleTextInputAction: titleTextField.textPublisher.eraseToAnyPublisher(),
                                           contentTextInputAction: contentTextView.textPublisher.eraseToAnyPublisher(),
                                           textActiveAction: textActiveAction,
                                           datePickerAction: datePickerAction,
                                           viewDidDisappear: viewDidDisappear.eraseToAnyPublisher())
        let output = viewModel.transform(input)
        
        output.didPressImageButton
            .sink { [weak self] in
                self?.picker?.showActionSheet()
            }
            .store(in: &cancellables)
        
        output.images
            .sink { [weak self] images in
                guard let self = self else { return }
                self.images.send(images)
                self.deletedImage.send(nil)
                self.cameraImage.send(nil)
                self.libraryImage.send([])
                            
                self.imageCollectionView.reloadData()

            }
            .store(in: &cancellables)
        
        output.avatar
            .sink { [weak self] image in
                guard let self = self else { return }
                UIView.transition(with: self.avatarImageView,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                                    self?.avatarImageView.image = image
                                  },
                                  completion: nil)

                self.avatar.send(image)
                self.imageCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        output.noResponse
            .sink {}
            .store(in: &cancellables)
        
        output.actionResponse
            .sink { result in
                switch result {
                case .failure(error: let error):
                    print(error)
                case .success:
                    print("success")
                }
            }
            .store(in: &cancellables)
        
        output.state
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .display:
                    self.navigationItem.rightBarButtonItem = nil
                    self.view.endEditing(true)
                case .edit:
                    self.navigationItem.rightBarButtonItem =  self.saveButton
                }
            }
            .store(in: &cancellables)
        
        output.initialNote
            .sink { [weak self] note in
                guard let self = self else { return }
                guard let note = note else { return }
                
                self.titleTextField.text = note.title
                self.contentTextView.text = note.content
            }
            .store(in: &cancellables)

        output.displayDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.titleLabel.text = $0.dayMonthYearHourMinuteString
                self.refDate = $0
            }
            .store(in: &cancellables)
        
        output.isSaveButtonEnable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSaveButtonEnable in
                guard let self = self else { return }
                self.saveButton.isEnabled = isSaveButtonEnable;
            }
            .store(in: &cancellables)

    }
        
    override func setupTheme() {
        super.setupTheme()
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        seperatorView.backgroundColor = Colors.hotPink
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        nameTitleLabel.text = "Title"
        titleTextField.placeholder = "Title here "
    }
}

extension T05NoteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T05ImageCollectionViewCell.className, for: indexPath) as? T05ImageCollectionViewCell else { return UICollectionViewCell() }
        guard let image = images.value[safe: indexPath.item] else { return UICollectionViewCell() }
        cell.generateCell(with: image, isAvatar: image == avatar.value)
        cell.buttonTappedAction = { [weak self] in
            self?.deletedImage.send(indexPath.item)
        }
        return cell
    }
}

extension T05NoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = defaultDividerSize * 2 +
            collectionView.safeAreaInsets.top +
            collectionView.safeAreaInsets.bottom
        
        let height = collectionView.bounds.size.height - marginsAndInsets
        
        return CGSize(width: height, height: height)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seletedImage.send(indexPath.item)
    }
}

extension T05NoteViewController: ImagePickerDelegate {
    func cameraHandle(image: UIImage) {
        cameraImage.send(image)
    }
    
    func libraryHandle(images: [UIImage]) {
        libraryImage.send(images)
    }
}

extension T05NoteViewController {
    func datePicker(title: String, date: Date, minDate: Date, maxDate: Date) -> Future<Date?, Never> {
        return Future() { promise in
            let dialog = DatePickerDialog(locale: Locale(identifier: Strings.localeIdentifier))
            dialog.overrideUserInterfaceStyle = .light
            dialog.datePicker.overrideUserInterfaceStyle = .light
            dialog.show(title,
                        doneButtonTitle: LocalizedString.t01ConfirmButtonTitle,
                        cancelButtonTitle: LocalizedString.t01CancelButtonTitle,
                        defaultDate: date,
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        datePickerMode: .dateAndTime) { selectedDate in
                promise(.success(selectedDate))
            }
        }
    }
}
