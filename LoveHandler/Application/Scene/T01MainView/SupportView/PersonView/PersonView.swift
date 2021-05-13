//
//  PersonView.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit
import DatePickerDialog

class PersonView: UIView, NibLoadable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: RoundImageView!
    @IBOutlet weak var genderContainerView: UIView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var zodiacContanerView: UIView!
    @IBOutlet weak var zodiacLabel: UILabel!
    
    var contentView: UIView?

    var person: Person? {
        didSet {
            if let person = person {
                loadPerson(from: person)
            }
        }
    }

    private var picker: ImagePickerHelper?
    
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
        
        let zodiacTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        zodiacContanerView.addGestureRecognizer(zodiacTap)
        
        let genderTap = UITapGestureRecognizer(target: self, action: #selector(self.handleGenderTap(_:)))
        genderContainerView.addGestureRecognizer(genderTap)
        
        genderContainerView.backgroundColor = Colors.pink
        zodiacContanerView.backgroundColor = Colors.deepPink
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(imageTap)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(self.handleNameTap(_:)))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(nameTap)
        
        picker = ImagePickerHelper(title: LocalizedString.t01ImagePickerTitle,
                                       message: LocalizedString.t01ImagePickerSubTitle)
        
        picker?.delegate = self
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        datePickerTapped()
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
            switch action {
            
            case .chooseGender:
                self?.chooseGender()
            case .chooseDateOfBirth:
                self?.datePickerTapped()
            case .chooseColor:
                self?.chooseGender()
            }
        }
    }
    
    
    @objc private func handleImageTap(_ sender: UITapGestureRecognizer? = nil) {
        picker?.showActionSheet()
    }
        
    private func loadPerson(from person: Person) {
        nameLabel.text = person.name
        genderLabel.text = "\(person.gender.symbol) \(person.age) "
        
        if let zodiac = person.zodiacSign {
            zodiacLabel.text = "\(zodiac.symbol) \(zodiac.name)"
        }
        
        if let image = person.image {
            avatarImageView.layer.borderWidth = 1
            avatarImageView.layer.borderColor = UIColor.white.cgColor
            avatarImageView.image = image
            avatarImageView.contentMode = .scaleAspectFill
        } else {
            avatarImageView.contentMode = .scaleAspectFit
        }
    }
}

extension PersonView {
    private func datePickerTapped() {
        let dialog = DatePickerDialog(locale: Locale(identifier: Strings.localeIdentifier))
        dialog.overrideUserInterfaceStyle = .light
        dialog.datePicker.overrideUserInterfaceStyle = .light
        dialog.show(LocalizedString.t01DatePickerTitleTitle,
                    doneButtonTitle: LocalizedString.t01ConfirmButtonTitle,
                    cancelButtonTitle: LocalizedString.t01CancelButtonTitle,
                    defaultDate: person?.dateOfBirth ?? Date(),
                    minimumDate: Constant.minDate,
                    maximumDate: Date(),
                    datePickerMode: .date) { [weak self] date in
            guard let self = self else { return }
            if let date = date {
                self.person?.dateOfBirth = date
            }
        }
    }
    
    private func chooseGender() {
        UIAlertController.showActionSheet(source: Gender.self,
                                          title: LocalizedString.t01ChooseGenderTitle,
                                          message: LocalizedString.t01ChooseGenderSubTitle) { [weak self] gender in
            self?.person?.gender = gender
        }
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
