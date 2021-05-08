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
    func bind(date: Date, isHavingData: Bool = true, isSelected: Bool = false) {
        
        self.backgroundColor = date.isInSameMonth(as: Date()) ? (isSelected ? Colors.lightPink : .white ): Colors.deepPink

        dateLabel.text = "\(date.day)"
        
        dateLabel.textColor = date.isInSameMonth(as: Date()) ? (isHavingData || isSelected ? .white : Colors.deepPink) : .white
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 14.0)

        dateBackgroundView.backgroundColor = isHavingData ? Colors.deepPink : .clear
    }
}
