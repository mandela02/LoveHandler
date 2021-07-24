//
//  AnimatedSettingTableViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 24/07/2021.
//

import UIKit

class AnimatedSettingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    
    var didValueChange: ((Float) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func valueDidChanged(_ sender: Any) {
        didValueChange?(valueSlider.value)
    }
    
    func setUpCell(with model: AnimatedAttributesModel) {
        titleLabel.text = model.title + ": \(model.value)"
        valueSlider.maximumValue = model.maxValue
        valueSlider.minimumValue = model.minValue
        valueSlider.value = model.value
    }
}
