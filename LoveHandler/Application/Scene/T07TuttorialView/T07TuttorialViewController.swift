//
//  T07TuttorialViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 24/06/2021.
//

import UIKit
import Combine
import Mantis

class T07TuttorialViewController: BaseTuttorialViewController {
    @IBOutlet weak var avatarImageView: RoundImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let tapGesture = UITapGestureRecognizer(target: self, action: nil)

    private var cancellables = Set<AnyCancellable>()
    private var picker: ImagePickerHelper?
    private var person = CurrentValueSubject<Person, Never>(Person())
        
    var namePlaceHolder: String {
        switch index {
        case 1:
            return "your name"
        case 2:
            return "your parter name"
        default:
            return ""
        }
    }
    
    var datePlaceHolder: String {
        switch index {
        case 1:
            return "your birthday"
        case 2:
            return "your parter birthday"
        default:
            return ""
        }
    }

    var savedPerson: Person {
        return self.person.value
    }

    private var isSettingViewController = true
    
    override func refreshView() {
        super.refreshView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func setupView() {
        avatarImageView.image = Gender.female.defaultImage
        dateTextField.isUserInteractionEnabled = false
        person.value.gender = index == 1 ? .female : .male
        setupDatePicker()
        addPicker()
        setupAvatarUserInteraction()
        if let step = index {
            setupPlaceholder(step: step)
        }
    }
    
    override func setupTheme() {
        super.setupTheme()
        genderButton.setTitleColor(UIColor.white, for: .normal)
        avatarImageView.backgroundColor = UIColor.white
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        datePicker.datePublisher.sink { [weak self] date in
            guard let self = self else { return }
            if self.isSettingViewController {
                self.isSettingViewController = false
            } else {
                self.person.value.dateOfBirth = date.timeIntervalSince1970
            }
            self.datePicker.date = date
        }
        .store(in: &cancellables)

        nameTextField.textPublisher.sink { [weak self] value in
            self?.person.value.name = value == "" ? nil : value
        }
        .store(in: &cancellables)
                
        tapGesture.tapPublisher.sink { [weak self] _ in
            self?.picker?.showActionSheet()
        }
        .store(in: &cancellables)
        
        genderButton.tapPublisher.sink {  [weak self] _ in
            UIAlertController.showActionSheet(source: Gender.self,
                                              title: LocalizedString.t01ChooseGenderTitle,
                                              message: LocalizedString.t01ChooseGenderSubTitle) { [weak self] gender in
                guard let self = self else { return }
                self.person.value.gender = gender
            }
        }
        .store(in: &cancellables)
        
        person.sink { [weak self] person in
            guard let self = self else { return }
            
            if let gender = person.gender {
                self.genderButton.setTitle(gender.getName(), for: .normal)
                if person.image == nil {
                    self.avatarImageView.image = gender.defaultImage
                }
            }
            
            if let dateOfBirth = person.dateOfBirth {
                self.dateTextField.text = Date(timeIntervalSince1970: dateOfBirth).dayMonthYearString
            }
            
            if let image = person.image {
                self.avatarImageView.image = image
            }
        }
        .store(in: &cancellables)
    }
}

extension T07TuttorialViewController {
    func setupPlaceholder(step: Int) {
        nameTextField.placeholder = namePlaceHolder
        dateTextField.placeholder = datePlaceHolder
    }
    
    private func setupDatePicker() {
        datePicker.locale = Locale(identifier: Strings.localeIdentifier)
        datePicker.calendar = Calendar.gregorian
        datePicker.maximumDate = Constant.maxDate
        datePicker.minimumDate = Constant.minDate
        datePicker.datePickerMode = .date
    }
    
    private func setupAvatarUserInteraction() {
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    private func addPicker() {
        picker = ImagePickerHelper(title: LocalizedString.t01ImagePickerTitle,
                                   message: LocalizedString.t01ImagePickerSubTitle)
        
        picker?.delegate = self
    }
}

// MARK: - ImagePickerDelegate
extension T07TuttorialViewController: ImagePickerDelegate {
    func cameraHandle(image: UIImage) {
        cropImage(image: image)
    }
    
    func libraryHandle(images: [UIImage]) {
        if !images.isEmpty {
            cropImage(image: images.first!)
        }
    }
    
    private func cropImage(image: UIImage) {
        var config = Mantis.Config()
        config.cropShapeType = .circle(maskOnly: true)
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true)
    }
}

extension T07TuttorialViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        self.dismiss(animated: true) { [weak self] in
            self?.person.value.image = cropped
        }
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true) { [weak self] in
            self?.person.value.image = original
        }
    }
    
}
