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

    func bind(icon: String, title: String) {
        iconImageView.image = UIImage(named: icon)
        titleLabel.text = title
        iconImageView.tintColor = titleLabel.textColor
    }
    
}
