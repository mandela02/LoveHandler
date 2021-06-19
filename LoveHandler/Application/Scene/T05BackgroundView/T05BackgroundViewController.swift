//
//  T05BackgroundViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 17/06/2021.
//

import UIKit
import Combine

class T05BackgroundViewController: BaseViewController {
    
    @IBOutlet weak var bigImageVIew: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageController: CustomPageControl!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    private let images = [ImageNames.love1.image,
                          ImageNames.love2.image,
                          ImageNames.love3.image,
                          ImageNames.love4.image,
                          ImageNames.love5.image,
                          ImageNames.love6.image,
                          ImageNames.love7.image,
                          ImageNames.love8.image]
        .compactMap { $0 }
    
    private let defaultDividerSize: CGFloat = 10
    
    private var selectedImageIndexPath = CurrentValueSubject<Int, Never>(0)
    private var cancellables = Set<AnyCancellable>()

    private var aspectRatio: CGFloat {
        let size = Utilities.getWindowBound()
        return size.width / size.height
    }
    
    private var cellSize: CGSize = CGSize.zero
    
    override func deinitView() {
        selectedImageIndexPath.send(completion: .finished)
        cancellables.forEach { $0.cancel() }
    }
    
    override func setupView() {
        super.setupView()
        setupCollectionView()
        setupPageController()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        isBackButtonVisible = false
        isTitleVisible = true
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        selectedImageIndexPath
            .sink { [weak self] index in
                guard let self = self else { return }
                guard let image = self.images[safe: index] else { return }
                self.bigImageVIew.image = image
                self.pageController.currentPage = index
            }.store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBigImageView()
        calculateCellSize(aspectRatio: self.aspectRatio)
        imageCollectionView.reloadData()
    }
        
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = LocalizedString.t02BackgroundCellTitle
    }
}

extension T05BackgroundViewController {
    private func setupPageController() {
        pageController.initView(numberOfPages: images.count, currentPage: 0)
    }
    
    private func setupBigImageView() {
        imageViewWidthConstraint.constant = bigImageVIew.bounds.size.height * aspectRatio
        bigImageVIew.viewCornerRadius = 10
    }
    
    private func setupCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    private func calculateCellSize(aspectRatio: CGFloat) {
        let marginsAndInsets = defaultDividerSize * 2 +
            imageCollectionView.safeAreaInsets.top +
            imageCollectionView.safeAreaInsets.bottom
        
        let height = imageCollectionView.bounds.size.height - marginsAndInsets
        
        cellSize = CGSize(width: height * aspectRatio, height: height)
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
        guard let image = images[safe: indexPath.item] else {
            return UICollectionViewCell()
        }
        
        let imageAspectRatio = image.size.width / image.size.height
        let imageSize = CGSize(width: cell.bounds.size.height * imageAspectRatio,
                               height: cell.bounds.size.height)
        
        cell.setupCell(image: image
                        .resize(targetSize: imageSize))
        return cell
    }
}

extension T05BackgroundViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
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

extension T05BackgroundViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageIndexPath.send(indexPath.item)
    }
}