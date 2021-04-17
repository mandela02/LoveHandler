//
//  PersonView.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit
import DatePickerDialog

class PersonView: UIView {
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        contentView = view
        
        let zodiacTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        zodiacContanerView.addGestureRecognizer(zodiacTap)
        
        let genderTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        genderContainerView.addGestureRecognizer(genderTap)
        
        genderContainerView.backgroundColor = Colors.pink
        zodiacContanerView.backgroundColor = Colors.deepPink

    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        datePickerTapped()
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func loadPerson(from person: Person) {
        nameLabel.text = person.name
        genderLabel.text = "\(person.gender.symbol) \(person.age) "
        
        if let zodiac = person.zodiacSign {
            zodiacLabel.text = "\(zodiac.symbol) \(zodiac.name)"
        }
    }
}

extension PersonView {
    func datePickerTapped() {
        let dialog = DatePickerDialog(locale: Locale(identifier: Strings.localeIdentifier))
        dialog.show(LocalizedString.t01DatePickerTitleTitle,
                    doneButtonTitle: LocalizedString.t01ConfirmButtonTitle,
                    cancelButtonTitle: LocalizedString.t01CancelButtonTitle,
                    defaultDate: person?.dateOfBirth ?? Date(),
                    maximumDate: Date(),
                    datePickerMode: .date) { [weak self] date in
            guard let self = self else { return }
            if let date = date {
                self.person?.dateOfBirth = date
            }
        }
    }
}
