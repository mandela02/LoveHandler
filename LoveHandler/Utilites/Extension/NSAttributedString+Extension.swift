//
//  NSAttributedString+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

extension NSAttributedString {
    var images: [UIImage] {
        var result: [UIImage] = []
        self.enumerateAttribute(.attachment, in: NSRange(location: 0, length: length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, let image = attachment.image {
                result.append(image)
            }
        }
        return result
    }
    
    func removeImages() -> NSAttributedString {
        var ranges: [NSRange] = []
        self.enumerateAttribute(.attachment, in: NSRange(location: 0, length: length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, attachment.image != nil {
                ranges.append(range)
            }
        }
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        for index in 0..<ranges.count {
            mutableAttributedString.replaceCharacters(in: ranges[index], with: "")
            if index + 1 < ranges.count {
                for i in (index + 1)..<ranges.count {
                    ranges[i].location = max(ranges[i].location - ranges[index].length, 0)
                }
            }
        }
        return mutableAttributedString
    }
    
    func replaceImageWithWhitespace() -> (newAttributedString: NSAttributedString, imageInfos: [(range: NSRange, image: UIImage)]) {
        var imageInfos: [(range: NSRange, image: UIImage)] = []
        self.enumerateAttribute(.attachment, in: NSRange(location: 0, length: length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, let image = attachment.image {
                imageInfos.append((range: range, image: image))
            }
        }
        let newAttributedString = NSMutableAttributedString(attributedString: self)
        for imageInfo in imageInfos {
            newAttributedString.replaceCharacters(in: imageInfo.range, with: String(repeating: " ", count: imageInfo.range.length))
        }
        return (newAttributedString: newAttributedString, imageInfos: imageInfos)
    }
    
    func getFirstLineRange() -> NSRange? {
        let firstLine = self.string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .compactMap({ $0 }).first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard let range = self.string.range(of: firstLine) else { return nil }
        let nsRange = NSRange(range, in: self.string)
        return nsRange
    }
    
    func getImages() -> [(range: NSRange, image: UIImage)] {
        var imageInfos = [(range: NSRange, image: UIImage)]()
        enumerateAttribute(.attachment, in: NSRange(location: 0, length: length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, let image = attachment.image {
                imageInfos.append((range: range, image: image))
            }
        }
        
        return imageInfos
    }
    
    func getAllImage() -> [UIImage] {
        self.enumerateAttribute(.attachment, in: NSRange(location: 0, length: length), options: []) { (value, range, stop) in
            var images: [UIImage] = []
            if let attachment = value as? NSTextAttachment, let image = attachment.image {
                images.append(image)
            }
        }
        return images
    }
    
    func getTexts() -> String {
        let imageInfos = getImages()
        let newAttributedString = NSMutableAttributedString(attributedString: self)
        for imageInfo in imageInfos {
            newAttributedString.replaceCharacters(in: imageInfo.range, with: String(repeating: " ", count: imageInfo.range.length))
        }
        return newAttributedString.string
    }
    
    func fitImage(with ratio: CGFloat) -> NSAttributedString {
        self.enumerateAttribute(.attachment, in: NSRange(location: 0, length: length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, let image = attachment.image {
                 attachment.image = image.scaleTo(widthRatio: ratio, heightRatio: ratio)
            }
        }
        return self
    }
}
