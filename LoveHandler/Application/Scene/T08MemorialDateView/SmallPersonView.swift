//
//  SmallPersonView.swift
//  LoveHandler
//
//  Created by LanNTH on 30/06/2021.
//

import UIKit

class SmallPersonView: BaseView, NibLoadable {
    
    @IBOutlet weak var avatarImageView: RoundImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    func setupView(with person: Person) {
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = person.name
        avatarImageView.image = person.image ?? person.gender?.defaultImage
    }
}
