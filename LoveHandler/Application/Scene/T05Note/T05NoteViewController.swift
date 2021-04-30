//
//  T05NoteViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import UIKit

class T05NoteViewController: BaseViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private let defaultDividerSize: CGFloat = 1
    
    override func setupView() {
        super.setupView()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
}

extension T05NoteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T05ImageCollectionViewCell.className, for: indexPath) as? T05ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = UIColor.red
        return cell
    }
}

extension T05NoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = defaultDividerSize * 2 +
            collectionView.safeAreaInsets.left +
            collectionView.safeAreaInsets.right
        
        let height = collectionView.bounds.size.height - marginsAndInsets
        
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return defaultDividerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return defaultDividerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: defaultDividerSize, left: defaultDividerSize, bottom: defaultDividerSize, right: defaultDividerSize)
    }
}
