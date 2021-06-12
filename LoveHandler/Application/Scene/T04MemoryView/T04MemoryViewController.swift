//
//  T04MemoryViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 12/06/2021.
//

import UIKit

class T04MemoryViewController: BaseViewController {
    @IBOutlet weak var bigContainerView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func setupView() {
        bigContainerView.viewCornerRadius = 10
    }
}
