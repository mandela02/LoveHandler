//
//  T05ImageControllerViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 17/06/2021.
//

import UIKit

class T05ImageControllerViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    private lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = SystemImage.checkMark.image
        imageView.tintColor = UIColor.white
        
        return imageView
    }()
    
    override func prepareForReuse() {
        imageView.image = nil
        checkMarkImageView.isHidden = true
    }
    
    
    
    func setupCell(image: UIImage, isSelected: Bool = false) {
        self.imageView.image = image
        imageView.viewCornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        
        self.checkMarkImageView.isHidden = !isSelected
    }
}
