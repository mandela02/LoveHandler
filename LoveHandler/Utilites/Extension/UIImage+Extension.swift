//
//  UIImage+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    func tintColor(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func merge(with image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        image.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func scaleTo(size targetSize: CGSize) -> UIImage? {
        let oldSize = self.size
        let widthRatio  = targetSize.width  / oldSize.width
        let heightRatio = targetSize.height / oldSize.height
        
        if widthRatio > heightRatio {
            return self.scaleTo(widthRatio: heightRatio, heightRatio: heightRatio)
        } else {
            return self.scaleTo(widthRatio: widthRatio, heightRatio: widthRatio)
        }
    }
    
    func scaleTo(widthRatio: CGFloat, heightRatio: CGFloat) -> UIImage? {
        let oldSize = self.size
        let newSize = CGSize(width: oldSize.width * widthRatio, height: oldSize.height * widthRatio)
        return self.resize(targetSize: newSize)
    }
        
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func compressImage() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        let megaByte = 1000.0

        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / megaByte

        while imageSizeKB > megaByte {
            guard let resizedImage = resizingImage.resized(withPercentage: 0.5),
            let imageData = resizedImage.pngData() else { return nil }

            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / megaByte
        }

        return resizingImage
    }
}
