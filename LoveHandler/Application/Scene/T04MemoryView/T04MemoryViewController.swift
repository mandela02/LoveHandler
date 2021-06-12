//
//  T04MemoryViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 12/06/2021.
//

import UIKit

enum Purpose {
    case new
    case update
}

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

    var backgroundTap: UITapGestureRecognizer?
    
    var viewPurpose: Purpose?
    
    var titlePlaceHolder: String {
        return "Nhập nhật ký tại đây"
    }
    
    override func setupView() {
        contentTextView.viewCornerRadius = 10
        
        setupTransitionAnimation()
        setupTapBackground()
        setupViewBaseOnPerpose()
    }
    
    private func setupViewBaseOnPerpose() {
        if viewPurpose == Purpose.new {
            imageView.image = SystemImage.camera.image?
                .withAlignmentRectInsets(UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0))
            dateLabel.text = "Chọn ngày tại đây"
            contentTextView.text = "Nhập nhật ký tại đây"
            contentTextView.viewBorderWidth = 1
            contentTextView.viewBorderColor = Colors.pink

        }
    }
    
    override func setupTheme() {
        super.setupTheme()
        imageView.tintColor = Colors.pink
        saveButton.backgroundColor = Colors.hotPink
        saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        saveButton.setTitle("Save", for: .normal)
    }
    
    private func setupTransitionAnimation() {
        saveButton.hero.id = HeroIdentifier.addButtonIdentifier
        bigContainerView.hero.modifiers = [.cornerRadius(10),
                                           .forceAnimate,
                                           .spring(stiffness: 250, damping: 25)]
        backgroundView.hero.modifiers = [.fade]
    }
    
    private func setupTapBackground() {
        backgroundTap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        backgroundContentView.isUserInteractionEnabled = true
        backgroundContentView.addGestureRecognizer(backgroundTap!)
        backgroundTap?.delegate = self
    }
    
    @objc private func onTap() {
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
        
    override func keyboarDidShow(keyboardHeight: CGFloat) {
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardHeight > 100 ? keyboardHeight - 100 : keyboardHeight
        scrollView.contentInset = contentInset
        
        if contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == titlePlaceHolder {
            contentTextView.text = ""
            contentTextView.insertText("")
        }
    }
    
    override func keyboarDidHide() {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        if contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            contentTextView.text = ""
            contentTextView.insertText(titlePlaceHolder)
        }
    }

}

extension T04MemoryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == backgroundTap && (touch.view == backgroundContentView || contentTextView.isFirstResponder)  {
            return true
        }
        return false;
    }
}
