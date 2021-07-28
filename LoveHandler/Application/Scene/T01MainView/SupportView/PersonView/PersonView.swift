//
//  PersonView.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit
import DatePickerDialog

class PersonView: BaseView, NibLoadable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: RoundImageView!
    @IBOutlet weak var genderContainerView: UIView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var zodiacContanerView: UIView!
    @IBOutlet weak var zodiacLabel: UILabel!
    
    var contentView: UIView?
    
    let genderColorPicker = UIColorPickerViewController()
    let genderTextColorPicker = UIColorPickerViewController()
    let zodiacColorPicker = UIColorPickerViewController()
    let zodiacTextColorPicker = UIColorPickerViewController()

    var person: Person? {
        didSet {
            if let person = person {
                loadPerson(from: person)
                if let target = target {
                    person.save(forKey: target)
                }
            }
        }
    }
    
    var target: Target?

    private var picker: ImagePickerHelper?
    private var isImageSet = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupFromNib()
        
        genderColorPicker.delegate = self
        genderTextColorPicker.delegate = self
        zodiacColorPicker.delegate = self
        zodiacTextColorPicker.delegate = self

        let zodiacTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        zodiacContanerView.addGestureRecognizer(zodiacTap)
        
        let genderTap = UITapGestureRecognizer(target: self, action: #selector(self.handleGenderTap(_:)))
        genderContainerView.addGestureRecognizer(genderTap)
                
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(imageTap)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(self.handleNameTap(_:)))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(nameTap)
        
        picker = ImagePickerHelper(title: LocalizedString.t01ImagePickerTitle,
                                       message: LocalizedString.t01ImagePickerSubTitle)
        
        picker?.delegate = self
        
        avatarImageView.backgroundColor = .white
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        UIAlertController.showActionSheet(source: BirthdayAction.self,
                                          title: LocalizedString.t01OptionTitle,
                                          message: LocalizedString.t01OptionSubTitle) {[weak self] action in
            guard let self = self else { return }
            switch action {
            case .chooseBirthDay:
                self.datePickerTapped()
            case .chooseColor:
                self.chooseColor(controller: self.zodiacColorPicker)
            case .chooseTextColor:
                self.chooseColor(controller: self.zodiacTextColorPicker)
            }
        }
    }
    
    @objc private func handleNameTap(_ sender: UITapGestureRecognizer? = nil) {
        UIAlertController.inputDialog(currentText: person?.name ?? "",
                                      title: LocalizedString.t01NameTitle,
                                      message: LocalizedString.t01NameSubTitle,
                                      placeholder: LocalizedString.t01NamePlaceholder,
                                      buttonTitle: LocalizedString.t01NameSubmitButtonTitle) { [weak self] string in
            if string == "" {
                self?.person?.name = "Người ấy"
            } else {
                self?.person?.name = string
            }
        }
    }
    
    @objc private func handleGenderTap(_ sender: UITapGestureRecognizer? = nil) {
        UIAlertController.showActionSheet(source: GenderAndAgeButtonAction.self,
                                          title: LocalizedString.t01OptionTitle,
                                          message: LocalizedString.t01OptionSubTitle) {[weak self] action in
            guard let self = self else { return }
            switch action {
            case .chooseGender:
                self.chooseGender()
            case .chooseDateOfBirth:
                self.datePickerTapped()
            case .chooseColor:
                self.chooseColor(controller: self.genderColorPicker)
            case .chooseTextColor:
                self.chooseColor(controller: self.genderTextColorPicker)
            }
        }
    }
    
    @objc private func handleImageTap(_ sender: UITapGestureRecognizer? = nil) {
        picker?.showActionSheet()
    }
        
    private func loadPerson(from person: Person) {
        nameLabel.text = person.name
        genderLabel.text = "\(person.gender?.symbol ?? "") \(person.age) "
        
        if let zodiac = person.zodiacSign {
            zodiacLabel.text = "\(zodiac.symbol) \(zodiac.name)"
        }
        
        if let image = person.image {
            avatarImageView.layer.borderWidth = 1
            avatarImageView.layer.borderColor = Theme.current.commonColor.textColor.cgColor
            avatarImageView.image = image
            avatarImageView.contentMode = .scaleAspectFill
        } else {
            avatarImageView.contentMode = .scaleAspectFit
            avatarImageView.image = person.gender?.defaultImage
        }
        
        genderContainerView.backgroundColor = self.person?.genderColor ?? Colors.pink
        zodiacContanerView.backgroundColor = self.person?.zodiacColor ?? Colors.hotPink
        genderLabel.textColor = self.person?.genderTextColor ?? Colors.mediumVioletRed
        zodiacLabel.textColor = self.person?.zodiacTextColor ?? UIColor.white
    }
    
    override func setupTheme() {
        super.setupTheme()
        avatarImageView.tintColor = Colors.lightPink

        nameLabel.textColor = Theme.current.commonColor.textColor
    }
}

extension PersonView {
    private func datePickerTapped() {
        let dialog = DatePickerDialog(textColor: Colors.paleVioletRed,
                                      buttonColor: Colors.mediumVioletRed,
                                      locale: Locale(identifier: Strings.localeIdentifier))
        
        guard let date = person?.dateOfBirth else {
            return
        }
        
        dialog.overrideUserInterfaceStyle = .light
        dialog.datePicker.overrideUserInterfaceStyle = .light
        
        dialog.show(LocalizedString.t01DatePickerTitleTitle,
                    doneButtonTitle: LocalizedString.t01ConfirmButtonTitle,
                    cancelButtonTitle: LocalizedString.t01CancelButtonTitle,
                    defaultDate: Date(timeIntervalSince1970: date),
                    minimumDate: Constant.minDate,
                    maximumDate: Date(),
                    datePickerMode: .date) { [weak self] date in
            guard let self = self else { return }
            if let date = date {
                self.person?.dateOfBirth = date.timeIntervalSince1970
            }
        }
    }
    
    private func chooseGender() {
        UIAlertController.showActionSheet(source: Gender.self,
                                          title: LocalizedString.t01ChooseGenderTitle,
                                          message: LocalizedString.t01ChooseGenderSubTitle) { [weak self] gender in
            guard let self = self else { return }
            self.person?.gender = gender
            if self.person?.image == nil {
                self.avatarImageView.image = gender.defaultImage
            }
        }
    }
    
    private func chooseColor(controller: UIColorPickerViewController) {
        UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
    }
}

extension PersonView: ImagePickerDelegate {
    func cameraHandle(image: UIImage) {
        self.person?.image = image
    }
    
    func libraryHandle(images: [UIImage]) {
        self.person?.image = images.first
    }
}

extension PersonView: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        switch viewController {
        case genderColorPicker:
            self.person?.genderColor = viewController.selectedColor
        case genderTextColorPicker:
            self.person?.genderTextColor = viewController.selectedColor
        case zodiacColorPicker:
            self.person?.zodiacColor = viewController.selectedColor
        case zodiacTextColorPicker:
            self.person?.zodiacTextColor = viewController.selectedColor
        default:
            return
        }
    }
}
