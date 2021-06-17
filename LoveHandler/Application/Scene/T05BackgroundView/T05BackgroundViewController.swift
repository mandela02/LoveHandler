//
//  T05BackgroundViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 17/06/2021.
//

import UIKit

class T05BackgroundViewController: BaseViewController {
    
    @IBOutlet weak var bigImageVIew: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageController: CustomPageControl!
    
    private let images = [ImageNames.love1.image,
                          ImageNames.love2.image,
                          ImageNames.love3.image,
                          ImageNames.love4.image,
                          ImageNames.love5.image,
                          ImageNames.love6.image,
                          ImageNames.love7.image,
                          ImageNames.love8.image]
    
    override func setupView() {
        super.setupView()
        
        isBackButtonVisible = true
        isTitleVisible = true
        
        setupCollectionView()
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = LocalizedString.t02BackgroundCellTitle
    }
}

extension T05BackgroundViewController {
    private func setupCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension T05BackgroundViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T05ImageControllerViewCell.className, for: indexPath) as? T05ImageControllerViewCell else {
            return UICollectionViewCell()
        }
        guard let image = images[safe: indexPath.item],
              let image = image else {
            return UICollectionViewCell()
        }
        cell.setupCell(image: image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension T05BackgroundViewController: UICollectionViewDelegate {
}
