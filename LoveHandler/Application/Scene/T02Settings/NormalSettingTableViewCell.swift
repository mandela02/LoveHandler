//
//  NormalSettingTableViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import UIKit

class NormalSettingTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.tintColor = titleLabel.textColor
    }

    func bind(icon: UIImage, title: String) {
        iconImageView.image = icon
        titleLabel.text = title
        iconImageView.tintColor = titleLabel.textColor
    }
}
