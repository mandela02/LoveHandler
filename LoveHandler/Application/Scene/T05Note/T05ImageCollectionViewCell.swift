//
//  T05ImageCollectionViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import UIKit

class T05ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var buttonTappedAction : (() -> Void)?

    @IBAction func buttonTap(sender: AnyObject) {
        buttonTappedAction?()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func generateCell(with image: UIImage, isAvatar: Bool) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        backgroundColor = isAvatar ? Colors.lightPink : .clear
    }

}
