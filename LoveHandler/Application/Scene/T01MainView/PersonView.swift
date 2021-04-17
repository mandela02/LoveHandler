//
//  PersonView.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit

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
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PersonView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func loadPerson(from person: Person) {
        nameLabel.text = person.name
        genderLabel.text = "\(person.gender.symbol) \(person.age) "
        
        if let zodiac = person.zodiacSign {
            zodiacLabel.text = "\(zodiac.symbol) \(zodiac.rawValue)"
        }
    }
}
