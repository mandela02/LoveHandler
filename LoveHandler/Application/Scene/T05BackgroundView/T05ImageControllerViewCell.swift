//
//  T05ImageControllerViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 17/06/2021.
//

import UIKit

class T05ImageControllerViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setupCell(image: UIImage) {
        self.imageView.image = image
        imageView.viewCornerRadius = 10
        imageView.contentMode = .scaleAspectFill
    }
}
