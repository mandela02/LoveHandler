//
//  UITextView+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

extension UITextView {
    func insertImage(_ image: UIImage) {
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let width = Utilities.getWindowSize().width
                    - textContainer.lineFragmentPadding * 2
        let textAttachment = NSTextAttachment()
        textAttachment.image = image.scaleTo(size: CGSize(width: width - 34, height: .greatestFiniteMagnitude))
        guard let cursorPosition = selectedTextRange?.start else { return }
        let offset = self.offset(from: beginningOfDocument, to: cursorPosition)
        attributedString.insert(NSAttributedString(attachment: textAttachment), at: offset)
        attributedText = attributedString
        if let newPosition = position(from: cursorPosition, offset: 1) {
            selectedTextRange = textRange(from: newPosition, to: newPosition)
        }
    }
    
    func setAttributes(_ attributes: [NSAttributedString.Key: Any]) {
        let (newAttributedString, imageInfos) = attributedText.replaceImageWithWhitespace()
        let mutableAttributedString = NSMutableAttributedString(string: newAttributedString.string, attributes: attributes)
        for imageInfo in imageInfos {
            let textAttachment = NSTextAttachment()
            textAttachment.image = imageInfo.image
            mutableAttributedString.replaceCharacters(in: imageInfo.range, with: NSAttributedString(attachment: textAttachment))
        }
        attributedText = mutableAttributedString
    }
    
    func setAttributesAtStart(_ attributes: [NSAttributedString.Key: Any]) {
        let mutableAttributedString = NSMutableAttributedString(string: text, attributes: attributes)
        attributedText = mutableAttributedString
    }
    
    func setLinkAttributes(color: UIColor, underlineStyleRawValue: Int) {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: attributedText.string, options: [], range: NSRange(location: 0, length: attributedText.string.utf16.count))
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
            for match in matches {
                mutableAttributedString.addAttribute(.foregroundColor, value: color, range: match.range)
                mutableAttributedString.addAttribute(.underlineStyle, value: underlineStyleRawValue, range: match.range)
            }
            attributedText = mutableAttributedString
        } catch {
            debugPrint("Error set link attributes")
        }
    }
    
    func setFirstLineFont(_ font: UIFont) {
        guard let range = attributedText.getFirstLineRange() else { return }
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributedString.addAttribute(.font, value: font, range: range)
        attributedText = mutableAttributedString
    }
    
    func lineCount(text: String) -> CGFloat {
        guard let font = self.font else { fatalError() }
        var textWidth = self.frame.inset(by: self.textContainerInset).width
        textWidth -= self.textContainer.lineFragmentPadding * 2.0
        let boundingRect = (text as NSString).boundingRect(with: CGSize(width: Double(textWidth), height: .greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
        return boundingRect.height / font.lineHeight
    }
    
    // swiftlint:disable legacy_constructor
    func scrollToBottom() {
        if self.text.count > 0 {
            let location = self.text.count - 1
            let bottom = NSMakeRange(location, 1)
            self.scrollRangeToVisible(bottom)
        }
    }
    // swiftlint:enable legacy_constructor
    
    func scrollToCursorPosition() {
        let caret = self.caretRect(for: self.selectedTextRange!.start)
        self.scrollRectToVisible(caret, animated: true)
    }
    
    var currentAtBeginningOfDocument: Bool {
        guard let cursorPosition = selectedTextRange?.start else { return false }
        return compare(cursorPosition, to: beginningOfDocument) == .orderedSame
    }
    
    var currentAtEndOfDocument: Bool {
        guard let cursorPosition = selectedTextRange?.start else { return false }
        return compare(cursorPosition, to: endOfDocument) == .orderedSame
    }
    
    func characterFromCursor(offset: Int) -> String? {
        // get the cursor position
        if let cursorRange = selectedTextRange {
            // get the position one character before the cursor start position
            if let newPosition = position(from: cursorRange.start, offset: offset),
                let range = textRange(from: newPosition, to: cursorRange.start) {
                return text(in: range)
            }
        }
        return nil
    }

    var imageLocations: [Int] {
        var locations: [Int] = []
        attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: attributedText.length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment,
                let _ = attachment.image {
                locations.append(range.location)
            }
        }
        return locations
    }
    
    var caretLocation: Int {
        if let selectedRange = selectedTextRange {
            // cursorPosition is an Int
            return offset(from: beginningOfDocument, to: selectedRange.start)
        } else {
            return 0
        }
    }
    
    func adjustForKeyboard(notification: Notification, container: UIView) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = container.convert(keyboardScreenEndFrame, from: container.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            self.contentInset = .zero
        } else {
            self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - self.safeAreaInsets.bottom, right: 0)
        }

        self.scrollIndicatorInsets = self.contentInset

        let selectedRange = self.selectedRange
        self.scrollRangeToVisible(selectedRange)
    }
    
    private func addLineBreakBeforeImage(image: UIImage, of imageList: [UIImage], attributes: [NSAttributedString.Key: Any]) {
        if !currentAtBeginningOfDocument {
            if image == imageList.first {
                // check if image after another image
                if characterFromCursor(offset: -1) != "\n" || imageLocations.contains(caretLocation - 2) {
                    insertAttributeText(text: "\n", attributes: attributes)
                }
                // if cursor is next to an image before insert, insert line break
                if imageLocations.contains(caretLocation - 2) {
                    insertAttributeText(text: "\n", attributes: attributes)
                }
            } else {
                insertAttributeText(text: "\n", attributes: attributes)
            }
        }
    }

    private func addLineBreakAfterImage(attributes: [NSAttributedString.Key: Any]) {
        // if after image is before another image
        let isBeforeAnImage = imageLocations.contains(caretLocation + 2) && characterFromCursor(offset: 1) == "\n"
        if !isBeforeAnImage {
            insertAttributeText(text: "\n", attributes: attributes)
        }
    }

    private func addLineBreakAfterImageList(image: UIImage, of imageList: [UIImage], attributes: [NSAttributedString.Key: Any]) {
        // check if image is the last image of list and at the end of textview
        let needLineBreakAtListEnd = currentAtEndOfDocument && image == imageList.last
        // check if cursor is next to an image after insert
        if needLineBreakAtListEnd || imageLocations.contains(caretLocation) {
            insertAttributeText(text: "\n", attributes: attributes)
        }
    }

    func insertImageToTextField(_ images: [UIImage], attributes: [NSAttributedString.Key: Any]) {
    
        for image in images {
            addLineBreakBeforeImage(image: image, of: images, attributes: attributes)
            insertImage(image)
            addLineBreakAfterImage(attributes: attributes)
            addLineBreakAfterImageList(image: image, of: images, attributes: attributes)
        }
        // reset cursor position
        guard let cursorPosition = selectedTextRange?.start else { return }
        setAttributes(attributes)
        if let newPosition = position(from: cursorPosition, offset: 0) {
            selectedTextRange = textRange(from: newPosition, to: newPosition)
        }
    }
    
    func insertAttributeText(text: String, attributes: [NSAttributedString.Key: Any]) {
        guard let selectedRange = selectedTextRange else {
            return
        }
        let attributedString = NSAttributedString(string: text)
        let cursorIndex = offset(from: beginningOfDocument, to: selectedRange.start)
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributedText.insert(attributedString, at: cursorIndex)
        mutableAttributedText.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttributedText.length))
        attributedText = mutableAttributedText
        
        if let newPosition = position(from: selectedRange.start, offset: text.count ) {
            selectedTextRange = textRange(from: newPosition, to: newPosition)
        }
    }
    
    func getSnapshot() -> UIImage? {
        guard let cloneView = self.copyView() else { return nil }
        cloneView.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height))
        tempView.addSubview(cloneView)
        let image = tempView.getScreenshotOfView()
        return image
    }
    
    func getThumbnail() -> UIImage? {
        setContentOffset(self.contentOffset, animated: false)
        return getDeviceScreenshot(false)
    }
}
