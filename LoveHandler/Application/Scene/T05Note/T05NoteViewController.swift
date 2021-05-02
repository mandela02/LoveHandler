//
//  T05NoteViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import UIKit
import Combine

class T05NoteViewController: BaseViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var viewModel: T05NoteViewModel?
    
    private let defaultDividerSize: CGFloat = 1
    private var picker: ImagePickerHelper?
    
    private var cancellables = Set<AnyCancellable>()
    private var cameraImage = CurrentValueSubject<UIImage?, Never>(nil)
    private var libraryImage = CurrentValueSubject<[UIImage], Never>([])
    
    private var deletedImage = PassthroughSubject<Int?, Never>()
    private var seletedImage = PassthroughSubject<Int?, Never>()
    private var images = CurrentValueSubject<[UIImage], Never>([])
    
    private var avatar = CurrentValueSubject<UIImage?, Never>(nil)

    deinit {
        cancellables.forEach { $0.cancel() }
        cameraImage.send(completion: .finished)
        libraryImage.send(completion: .finished)
        deletedImage.send(completion: .finished)
        seletedImage.send(completion: .finished)
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.imageCollectionView.reloadData()
    }
    
    override func setupView() {
        super.setupView()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        picker = ImagePickerHelper(title: "Image", message: "Image", isMultiplePick: true)
        picker?.delegate = self
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = viewModel else { return }
        let input = T05NoteViewModel.Input(imageButtonPressed: addImageButton.tapPublisher,
                                           cameraImage: cameraImage.eraseToAnyPublisher(),
                                           libraryImages: libraryImage.eraseToAnyPublisher(),
                                           deleteButtonPressed: deletedImage.eraseToAnyPublisher(),
                                           seletedCell: seletedImage.eraseToAnyPublisher())
        let output = viewModel.transform(input)
        
        output.didPressImageButton
            .sink { [weak self] in
                self?.picker?.showActionSheet()
            }
            .store(in: &cancellables)
        
        output.images
            .sink { [weak self] (images) in
                guard let self = self else { return }
                self.images.send(images)
                self.deletedImage.send(nil)
                self.cameraImage.send(nil)
                self.libraryImage.send([])
                self.imageCollectionView.reloadData()

            }
            .store(in: &cancellables)
        
        output.avatar
            .sink { [weak self] image in
                self?.avatarImageView.image = image
                self?.avatar.send(image)
                self?.imageCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        output.noResponse
            .sink {}
            .store(in: &cancellables)
    }
        
    override func setupTheme() {
        super.setupTheme()
        self.navigationController?.navigationBar.tintColor = UIColor.white;
    }
}

extension T05NoteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T05ImageCollectionViewCell.className, for: indexPath) as? T05ImageCollectionViewCell else { return UICollectionViewCell() }
        guard let image = images.value[safe: indexPath.item] else { return UICollectionViewCell() }
        cell.generateCell(with: image, isAvatar: image == avatar.value)
        cell.buttonTappedAction = { [weak self] in
            self?.deletedImage.send(indexPath.item)
        }
        return cell
    }
}

extension T05NoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = defaultDividerSize * 2 +
            collectionView.safeAreaInsets.top +
            collectionView.safeAreaInsets.bottom
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seletedImage.send(indexPath.item)
    }
}

extension T05NoteViewController: ImagePickerDelegate {
    func cameraHandle(image: UIImage) {
        cameraImage.send(image)
    }
    
    func libraryHandle(images: [UIImage]) {
        libraryImage.send(images)
    }
}
