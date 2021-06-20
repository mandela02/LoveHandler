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
    
    private var aspectRatio: CGFloat {
        let size = Utilities.getWindowBound()
        return size.width / size.height
    }
    
    private var isContextMenuOn = false
    
    private var selectedImageIndexPath = CurrentValueSubject<Int, Never>(0)
    private var cancellables = Set<AnyCancellable>()
    

    override func deinitView() {
        selectedImageIndexPath.send(completion: .finished)
        cancellables.forEach { $0.cancel() }
    }
    
    override func setupView() {
        super.setupView()
        setupCollectionView()
        setupPageController()
        addGestureRecognizers()
        
        isBackButtonVisible = false
        isTitleVisible = true
        
    }
    
    override func refreshView() {
        super.refreshView()
        imageCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBigImageView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        selectedImageIndexPath
            .sink { [weak self] index in
                guard let self = self else { return }
                self.imageCollectionView.reloadData()
                self.imageCollectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                                      at: .centeredHorizontally,
                                                      animated: true)
                
                guard let image = self.images[safe: index] else { return }
                self.bigImageVIew.image = image
                self.pageController.currentPage = index
                Settings.background.value = image.jpeg(.medium)
            }.store(in: &cancellables)
    }
        
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = LocalizedString.t02BackgroundCellTitle
    }
    
    override func setupTheme() {
        super.setupTheme()
        self.navigationController?.navigationBar.tintColor = UIColor.white;
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
    
    private func calculateCellSize(collectionView: UICollectionView, aspectRatio: CGFloat) -> CGSize {
        let marginsAndInsets = defaultDividerSize * 2 +
            collectionView.safeAreaInsets.top +
            collectionView.safeAreaInsets.bottom
        
        let height = collectionView.bounds.size.height - marginsAndInsets
        
        return CGSize(width: height * aspectRatio, height: height)
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
                        .resize(targetSize: imageSize),
                       isSelected: indexPath.item == selectedImageIndexPath.value)
        return cell
    }
}

extension T05BackgroundViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize(collectionView: collectionView, aspectRatio: aspectRatio)
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
    
    func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] suggestedActions in
            guard let self = self else {
                return UIMenu(title: "", children: [])
            }
            let saveAction =
                UIAction(title: NSLocalizedString("Save", comment: ""),
                         image: UIImage(systemName: "arrow.up.square"),
                         attributes: .destructive) { action in
                    self.performShare(at: indexPath)
                    
                }
            let deleteAction =
                UIAction(title: NSLocalizedString("Delete", comment: ""),
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive) { action in
                    self.performDelete(at: indexPath)
                }
            return UIMenu(title: "", children: [saveAction, deleteAction])
        }
    }
    
    private func performDelete(at indexPath: IndexPath) {
        
    }
    
    private func performShare(at indexPath: IndexPath) {
        
    }
}

extension T05BackgroundViewController {
    private func swipeDownToDismiss(isEnabled: Bool) {
        navigationController?.presentationController?.presentedView?.gestureRecognizers?.forEach({$0.isEnabled = isEnabled})
    }

    private func addGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .began {
            swipeDownToDismiss(isEnabled: false)
        }
        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.left:
            pageController.move(to: .left)
        case UISwipeGestureRecognizer.Direction.right:
            pageController.move(to: .right)
        default:
            break
        }
        
        selectedImageIndexPath.send(pageController.currentPage)
        
        if sender.state == .ended {
            swipeDownToDismiss(isEnabled: true)
        }
    }
}
