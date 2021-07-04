//
//  NumberDisplayView.swift
//  LoveHandler
//
//  Created by LanNTH on 04/07/2021.
//

import UIKit

class NumberDisplayView: UIView, NibLoadable {
    
    @IBOutlet weak var displayLabel: BaseLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        setupView()
    }
        
    private func setupView() {
        displayLabel.textColor = UIColor.white
    }
    
    func setupLabel(with content: String) {
        displayLabel.text = content
    }
}
