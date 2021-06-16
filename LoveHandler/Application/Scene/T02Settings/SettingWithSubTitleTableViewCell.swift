//
//  SettingWithSubTitleTableViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 21/04/2021.
//

import UIKit

class SettingWithSubTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.tintColor = titleLabel.textColor
    }

    func bind(icon: UIImage, title: String, subTitle: String) {
        iconImageView.image = icon
        titleLabel.text = title
        subTitleLabel.text = subTitle
        iconImageView.tintColor = titleLabel.textColor
    }
}
