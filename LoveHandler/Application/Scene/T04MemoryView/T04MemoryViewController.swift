//
//  T04MemoryViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 12/06/2021.
//

import UIKit
import Combine

class T04MemoryViewController: BaseViewController {
    @IBOutlet weak var bigContainerView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollableContentView: UIView!
    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var imagePickButtonView: UIView!
    @IBOutlet weak var dateContainerStackView: UIStackView!
    @IBOutlet weak var bigContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeHolderImage: UIImageView!
    private var picker: ImagePickerHelper?
    private var currentConstraint: CGFloat = 0
    private var backgroundTap: UITapGestureRecognizer?
    private var imageTap: UITapGestureRecognizer?
    
    private var image = PassthroughSubject<UIImage, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var titlePlaceHolder: String {
        return "Nhập nhật ký tại đây"
    }
    
    var viewModel: T04MemoryViewModel?
    
    var imageHeroId = ""
    var isInEditMode = false
    
    private var isDoneInitAnimation = false
    private var limitConstaints: CGFloat = 150
    
    override func deinitView() {
        image.send(completion: .finished)
        cancellables.forEach { $0.cancel() }
    }
    
    override func setupView() {
        self.imagePickButtonView.isHidden = true
        self.scrollView.delegate = self
        contentTextView.viewCornerRadius = 10
        
        setupTransitionAnimation()
        setupTapBackground()
        addGesture()
        addPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSlideAnimation()
    }
    
    override func bindViewModel() {
        let chooseDateTap = UITapGestureRecognizer()
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(chooseDateTap)
        
        
        guard let viewModel = viewModel else { return }
        
        let chooseDateAction = chooseDateTap.tapPublisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.contentTextView.resignFirstResponder()
            })
            .map { _ in }.eraseToAnyPublisher()
        
        let input = T04MemoryViewModel.Input(textFieldString: contentTextView.textPublisher.compactMap { $0 }.eraseToAnyPublisher(),
                                             saveButtonTrigger: saveButton.tapPublisher,
                                             chooseDateTrigger: chooseDateAction,
                                             selectedImageTrigger: image.eraseToAnyPublisher())
        
        let output = viewModel.transform(input)
        
        output.noResponse.sink { _ in }.store(in: &cancellables)
        
        output.date.sink { [weak self] date in
            guard let self = self else { return }
            self.dateLabel.text = date.dayMonthYearString
        }.store(in: &cancellables)
        
        output.image.sink { [weak self] image in
            guard let self = self else { return }
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFill
            self.placeHolderImage.isHidden = true
            
            if self.isDoneInitAnimation {
                self.imagePickButtonView.isHidden = false
            }
            
            let width = self.bigContainerView.width
            let ratio = image.size.height / image.size.width
            self.imageHeightConstraint.constant = width * ratio
            
            self.addGestureToImageViewIfNeeded(isNeeded: false)
            
            self.currentConstraint = self.imageHeightConstraint.constant
            
            if !self.isDoneInitAnimation {
                self.bigContainerViewBottomConstraint.constant = Utilities.getWindowSize().height - self.limitConstaints - self.imageHeightConstraint.constant - 50
            }
            
        }.store(in: &cancellables)
        
        output.viewPurpose.sink { [weak self] purpose in
            guard let self = self else { return }
            self.setupViewBaseOnPerpose(viewPurpose: purpose)
        }.store(in: &cancellables)
        
        output.isSaveButtonEnable.sink { [weak self] isEnable in
            guard let self = self else { return }
            self.saveButton.isEnabled = isEnable
        }.store(in: &cancellables)
    }
    
    override func setupTheme() {
        super.setupTheme()
        imageView.tintColor = Colors.pink
        saveButton.backgroundColor = Colors.hotPink
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitleColor(UIColor.gray, for: .disabled)
        
        imagePickButtonView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        saveButton.setTitle("Save", for: .normal)
    }
    
    override func keyboarDidShow(keyboardHeight: CGFloat) {
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardHeight > 100 ? keyboardHeight - 100 : keyboardHeight
        scrollView.contentInset = contentInset
        
        if contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == titlePlaceHolder {
            contentTextView.text = ""
            contentTextView.insertText("")
        }
        
        contentTextView.viewBorderWidth = 1
        contentTextView.viewBorderColor = Colors.pink
    }
    
    override func keyboarDidHide() {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        if contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            contentTextView.text = ""
            contentTextView.insertText(titlePlaceHolder)
        }
        
        contentTextView.viewBorderWidth = 0
        contentTextView.viewBorderColor = UIColor.clear
    }
}

// MARK: - Obj C
extension T04MemoryViewController {
    @objc private func onTap() {
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleImageTap(_ sender: UITapGestureRecognizer? = nil) {
        contentTextView.resignFirstResponder()
        picker?.showActionSheet()
    }
}
// MARK: - Private function
extension T04MemoryViewController {
    private func configureSlideAnimation() {
        if !isInEditMode {
            isDoneInitAnimation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if !self.isDoneInitAnimation {
                self.bigContainerViewBottomConstraint.constant = self.limitConstaints
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
                self.isDoneInitAnimation = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self = self else { return }
            if self.isInEditMode {
                self.imagePickButtonView.alpha = 0.0
                self.imagePickButtonView.isHidden = false
                
                UIView.animate(withDuration: 0.6,
                               animations: { [weak self] in
                                self?.imagePickButtonView.alpha = 1.0
                               })
            }
        }
    }
    
    private func setupViewBaseOnPerpose(viewPurpose: Purpose) {
        switch viewPurpose {
        case .new:
            imageView.contentMode = .scaleAspectFit
            dateLabel.text = Date().dayMonthYearString
            contentTextView.text = "Nhập nhật ký tại đây"
            contentTextView.viewBorderWidth = 1
            contentTextView.viewBorderColor = Colors.pink
            
            imagePickButtonView.isHidden = true
            
            setupPlaceHolderImage()
            
        case .update(memory: let memory):
            guard let data = memory.image,
                  let text = memory.title else {
                return
            }
            
            if let image = UIImage(data: data) {
                self.image.send(image)
                imageView.image = image
                let width = bigContainerView.width
                let ratio = image.size.height / image.size.width
                imageHeightConstraint.constant = width * ratio
                addGestureToImageViewIfNeeded(isNeeded: false)
                currentConstraint = imageHeightConstraint.constant
            }
            
            contentTextView.text = ""
            contentTextView.insertText(text)
            dateLabel.text = Date(timeIntervalSince1970: TimeInterval(memory.displayedDate)).dayMonthYearString
        }
    }
    
    private func setupTransitionAnimation() {
        if isInEditMode {
            imageView.hero.id = imageHeroId
            imageView.hero.modifiers =  [.cornerRadius(10), .forceAnimate]
            bigContainerView.hero.modifiers =  [.cornerRadius(10), .forceAnimate]
            backgroundView.hero.modifiers = [.fade]
            saveButton.hero.modifiers =  [.cornerRadius(10), .forceAnimate]
            
        } else {
            saveButton.hero.id = HeroIdentifier.addButtonIdentifier
            bigContainerView.hero.modifiers = [.cornerRadius(10), .forceAnimate]
            backgroundView.hero.modifiers = [.fade]
            
        }
    }
    
    private func setupTapBackground() {
        backgroundTap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        backgroundContentView.isUserInteractionEnabled = true
        backgroundContentView.addGestureRecognizer(backgroundTap!)
        backgroundTap?.delegate = self
    }
    
    
    private func addGesture() {
        imageTap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        addGestureToImageViewIfNeeded(isNeeded: true)
    }
    
    private func addGestureToImageViewIfNeeded(isNeeded: Bool) {
        guard let imageTap = imageTap else { return }
        if isNeeded {
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(imageTap)
        } else {
            imageView.removeGestureRecognizer(imageTap)
            imagePickButtonView.addGestureRecognizer(imageTap)
        }
    }
    
    private func addPicker() {
        picker = ImagePickerHelper(title: LocalizedString.t01ImagePickerTitle,
                                   message: LocalizedString.t01ImagePickerSubTitle)
        
        picker?.delegate = self
    }
    
    private func setupPlaceHolderImage() {
        guard let image = ImageNames.placeholderImage.image else {
            return
        }
    
        imageView.image = SystemImage.camera.image?
            .withAlignmentRectInsets(UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0))
        
        imageView.backgroundColor = UIColor.clear
        
        placeHolderImage.image = image

        let width = self.bigContainerView.width
        let ratio = image.size.height / image.size.width
        self.imageHeightConstraint.constant = width * ratio
    }
}

// MARK: - UIGestureRecognizerDelegate
extension T04MemoryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == backgroundTap && (touch.view == backgroundContentView || contentTextView.isFirstResponder)  {
            return true
        }
        return false;
    }
}


// MARK: - ImagePickerDelegate
extension T04MemoryViewController: ImagePickerDelegate {
    func cameraHandle(image: UIImage) {
        self.image.send(image)
    }
    
    func libraryHandle(images: [UIImage]) {
        if !images.isEmpty {
            self.image.send(images.first!)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension T04MemoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            imageHeightConstraint.constant -= scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetHeightConstraint()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            resetHeightConstraint()
        }
    }
    
    private func resetHeightConstraint() {
        imageHeightConstraint.constant = currentConstraint
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
