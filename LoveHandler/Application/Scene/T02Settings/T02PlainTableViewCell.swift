//
//  T02PlainTableViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 16/06/2021.
//

import UIKit

class T02PlainTableViewCell: UITableViewCell {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        self.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        label.layoutIfNeeded()
        label.sizeToFit()
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCell(title: String) {
        label.text = title
    }
}
