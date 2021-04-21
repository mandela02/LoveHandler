//
//  SettingWithSwitchTableViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import UIKit

class SettingWithSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.tintColor = titleLabel.textColor
    }
    
    var didValueChange: ((Bool) -> Void)?
    
    func bind(icon: String, title: String, isOn: Bool) {
        iconImageView.image = UIImage(named: icon)
        titleLabel.text = title
        switchButton.isOn = isOn
        switchButton.addTarget(self, action: #selector(didSwitchChange), for: .valueChanged)
        iconImageView.tintColor = titleLabel.textColor
    }
    
    @objc private func didSwitchChange(switchButton: UISwitch) {
        didValueChange?(switchButton.isOn)
    }

}
