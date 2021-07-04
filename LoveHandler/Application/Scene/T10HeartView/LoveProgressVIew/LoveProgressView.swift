//
//  LoveProgressView.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit

class LoveProgressView: BaseView, NibLoadable {

    @IBOutlet weak var dayCountTitleLabel: UILabel!
    @IBOutlet weak var numberOfDayLabel: UILabel!
    @IBOutlet weak var dayCountSubtitleLabel: UILabel!
    @IBOutlet weak var heartView: HeartView!
    var contentView: UIView?

    var progress: Float = 0 {
        didSet {
            heartView.progress = progress
        }
    }
    
    var numberOfDay: Int = 0 {
        didSet {
            numberOfDayLabel.text = "\(numberOfDay)"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override func setupLocalizedStrings() {
        super.setupLocalizedStrings()
        dayCountTitleLabel.text = LocalizedString.t01HeartTitle
        dayCountSubtitleLabel.text = LocalizedString.t01HeartSubTitle
    }
    
    override func setupTheme() {
        super.setupTheme()
        dayCountTitleLabel.textColor = UIColor.white
        dayCountSubtitleLabel.textColor = UIColor.white
        numberOfDayLabel.textColor = UIColor.white
    }
}
