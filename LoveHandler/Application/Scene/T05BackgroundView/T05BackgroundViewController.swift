//
//  T05BackgroundViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 17/06/2021.
//

import UIKit
import Combine
import Mantis

class T05BackgroundViewController: BaseViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bigImageVIew: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageController: CustomPageControl!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    private let defaultDividerSize: CGFloat = 10
    
    private var aspectRatio: CGFloat {
        let size = Utilities.getWindowBound()
        return size.width / size.height
    }
        
    private var selectedImageIndexPath = CurrentValueSubject<Int, Never>(0)
    private var deletedImageIndexPath = PassthroughSubject<Int, Never>()
    private var viewWillAppear = PassthroughSubject<Void, Never>()
    private var addImage = PassthroughSubject<UIImage, Never>()

    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: T05BackgroundViewModel?
    
    private var images: [UIImage] = []
    private var selectedIndex: Int = 0

    private var picker: ImagePickerHelper?

    override func deinitView() {
        selectedImageIndexPath.send(completion: .finished)
        viewWillAppear.send(completion: .finished)
        cancellables.forEach { $0.cancel() }
    }
    
    override func setupView() {
        super.setupView()
        bigImageVIew.isUserInteractionEnabled = true
        
        setupCollectionView()
        
        setupPageController()
        addGestureRecognizers()
        
        addPicker()
        
        isBackButtonVisible = false
        isTitleVisible = true
        
        let interaction = UIContextMenuInteraction(delegate: self)
        bigImageVIew.addInteraction(interaction)
    }
    
    override func refreshView() {
        super.refreshView()
        viewWillAppear.send(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBigImageView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel else { return }
        let input = T05BackgroundViewModel
            .Input(viewWillAppear: viewWillAppear.eraseToAnyPublisher(),
                   selectedIndex: selectedImageIndexPath.eraseToAnyPublisher(),
                   deletedIndex: deletedImageIndexPath.eraseToAnyPublisher(),
                   savedImage: addImage.eraseToAnyPublisher())
        
        let output = viewModel.transform(input)
        
        output.images.sink { [weak self] images in
            guard let self = self else { return }
            self.images = images
            self.pageController.numberOfPages = images.count
            self.imageCollectionView.reloadData()
        }
        .store(in: &cancellables)
        
        output.selectedImage.sink { [weak self] image in
            guard let self = self else { return }
            self.bigImageVIew.image = image
        }
        .store(in: &cancellables)
        
        output.noResponse
            .sink(receiveValue: {})
            .store(in: &cancellables)
        
        output.selectedIndex
            .sink { [weak self] index in
                guard let self = self else { return }
                if self.images.count > 0 {
                    self.selectedIndex = index
                    self.pageController.currentPage = index
                    self.imageCollectionView
                        .scrollToItem(at: IndexPath(item: index,
                                                    section: 0),
                                      at: .centeredHorizontally,
                                      animated: true)
                    self.imageCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = LocalizedString.t02BackgroundCellTitle
    }
    
    override func setupTheme() {
        super.setupTheme()
        backgroundView.backgroundColor = Theme.current.tableViewColor.background
        imageCollectionView.backgroundColor = Theme.current.tableViewColor.background
        addImageButton.tintColor = Theme.current.buttonColor.tintColor
    }
    
    @IBAction func onAddImageButtonTapped(_ sender: Any) {
        picker?.showActionSheet()
    }
}

// MARK: - Setting View Controller
extension T05BackgroundViewController {
    private func addPicker() {
        picker = ImagePickerHelper(title: LocalizedString.t01ImagePickerTitle,
                                   message: LocalizedString.t01ImagePickerSubTitle)
        
        picker?.delegate = self
    }
    
    private func setupPageController() {
        pageController.initView(numberOfPages: images.count,
                                currentPage: selectedImageIndexPath.value)
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
                       isSelected: indexPath.item == selectedIndex)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension T05BackgroundViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize(collectionView: collectionView,
                                 aspectRatio: aspectRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return defaultDividerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return defaultDividerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: defaultDividerSize,
                            left: defaultDividerSize,
                            bottom: defaultDividerSize,
                            right: defaultDividerSize)
    }
}

// MARK: - UICollectionViewDelegate
extension T05BackgroundViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageIndexPath.send(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        return createContextMenu(at: indexPath.item)
    }
    
    private func createContextMenu(at indexPath: Int) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] suggestedActions in
            guard let self = self else {
                return UIMenu(title: "", children: [])
            }
            let saveAction =
                UIAction(title: LocalizedString.t05ShareButtonTitle,
                         image: SystemImage.arrowUpSquare.image,
                         attributes: .destructive) { action in
                    self.performShare(at: indexPath)
                    
                }
            let deleteAction =
                UIAction(title: LocalizedString.t05DeleteButtonTitle,
                         image: SystemImage.trash.image,
                         attributes: .destructive) { action in
                    self.performDelete(at: indexPath)
                }
            return UIMenu(title: "", children: [saveAction, deleteAction])
        }
    }
    
    private func performDelete(at indexPath: Int) {
        if images.count == 1 {
            UIAlertController.errorDialog(title: LocalizedString.t05LastImageErrorTitle,
                                          message: LocalizedString.t05LastImageErrorMessage)
            return
        }
        deletedImageIndexPath.send(indexPath)
        
    }
    
    private func performShare(at indexPath: Int) {
        guard let image = images[safe: indexPath] else { return }

        UIActivityViewController.share(image: image,
                                       at: self.view)
        
    }
}

// MARK: - View Geture
extension T05BackgroundViewController {
    private func swipeDownToDismiss(isEnabled: Bool) {
        navigationController?.presentationController?.presentedView?.gestureRecognizers?.forEach({$0.isEnabled = isEnabled})
    }
    
    private func addGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        self.bigImageVIew.addGestureRecognizer(swipeLeft)
        bigImageVIew.addGestureRecognizer(swipeRight)
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

extension T05BackgroundViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return createContextMenu(at: selectedIndex)
    }
}

// MARK: - ImagePickerDelegate
extension T05BackgroundViewController: ImagePickerDelegate {
    func didPickImage(images: [UIImage]) {
        if !images.isEmpty {
            cropImage(image: images.first!)
        }
    }
    
    private func cropImage(image: UIImage) {
        var config = Mantis.Config()
        config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: Double(Utilities.getWindowBound().width / Utilities.getWindowBound().height))
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true)
    }
}

extension T05BackgroundViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        self.dismiss(animated: true) { [weak self] in
            self?.addImage.send(cropped)
        }
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true) { [weak self] in
            self?.addImage.send(original)
        }
    }
    
}
