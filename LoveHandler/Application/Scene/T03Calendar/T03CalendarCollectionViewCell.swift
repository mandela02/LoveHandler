//
//  T03CalendarCollectionViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 22/04/2021.
//

import UIKit

class T03CalendarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateBackgroundView: RoundView!
    func bind(date: Date, isHavingData: Bool = true) {
        
        self.backgroundColor = date.isInSameMonth(as: Date()) ? .white: UIColor.gray.withAlphaComponent(0.5)

        dateLabel.text = "\(date.day)"
        
        dateLabel.textColor = UIColor.white
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 14.0)

        dateBackgroundView.backgroundColor = isHavingData ? .blue : .clear
    }
}
