//
//  String+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit
extension String {
    var intValue: Int {
        return Int(self) ?? 0
    }
    
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
    
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    static func isNilOrEmpty(_ string: String?) -> Bool {
        return string?.isEmpty ?? true
    }
    
    init(localizedKey key: String) {
        var bundle: Bundle? = Bundle.main
        let resourceName = Settings.appLanguage.value == LanguageCode.english.rawValue ? "Base" : Strings.localeIdentifier
        if let path = Bundle.main.path(forResource: resourceName, ofType: "lproj") {
            bundle = Bundle(path: path)
        }
        self = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
    
    func addAttribute(color: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    
    func addAttribute(fontName: String, fontSize: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize)]
        if let color = color {
            attributes.updateValue(color, forKey: .foregroundColor)
        }
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    func addAttribute(lineSpacing: CGFloat, lineBreakMode: NSLineBreakMode) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.lineBreakMode = lineBreakMode
        return NSMutableAttributedString(string: self, attributes: [.paragraphStyle: style])
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 5, alignment: NSTextAlignment = .left) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        return NSAttributedString(string: self, attributes: [.paragraphStyle: style])
    }
    
    func getWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font: font], context: nil)
        return actualSize.width
    }
    
    var image: UIImage? {
        return UIImage(named: self)
    }
    
    var sysImage: UIImage? {
        return UIImage(systemName: self)
    }
    
    func getFont(fontSize: CGFloat, isBold: Bool = false) -> UIFont {
        if let font = UIFont(name: self, size: fontSize) {
            return font
        }
        return isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
    }
    
    func addAttribute(highlightTexts: [String] = [], highlightColor: UIColor = .black, spacing: CGFloat = 5, alignment: NSTextAlignment = .justified) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        for text in highlightTexts {
            do {
                let regex = try NSRegularExpression(pattern: text.trimmingCharacters(in: .whitespacesAndNewlines), options: .caseInsensitive)
                let range = NSRange(location: 0, length: self.utf16.count)
                for match in regex.matches(in: self, options: .withTransparentBounds, range: range) {
                    attributedString.addAttribute(.foregroundColor, value: highlightColor, range: match.range)
                }
            } catch {
                NSLog("Error creating regular expresion: \(error)")
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = alignment
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: self.count))
        
        return attributedString
    }
    
    func getHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font: font], context: nil)
        return actualSize.height
    }
    
    func addAttribute(lineSpacing: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        return NSMutableAttributedString(string: self, attributes: [.paragraphStyle: style])
    }
    
    func setForegroundColor(highlightTexts: [String], color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        for text in highlightTexts {
            do {
                let regex = try NSRegularExpression(pattern: text.trimmingCharacters(in: .whitespacesAndNewlines), options: .caseInsensitive)
                let range = NSRange(location: 0, length: self.utf16.count)
                for match in regex.matches(in: self, options: .withTransparentBounds, range: range) {
                    attributedString.addAttribute(.foregroundColor, value: color, range: match.range)
                }
            } catch {
                NSLog("Error creating regular expresion: \(error)")
            }
        }
        
        return attributedString
    }
    
    func substring(with nsRange: NSRange) -> String? {
        guard let range = Range(nsRange, in: self) else { return nil }
        return String(self[range])
    }
    
    func formatStringTypeWith(text: String) -> String {
        return self.replacingOccurrences(of: "%@", with: text)
    }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                    indices.append(range.lowerBound)
                    startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                    result.append(range)
                    startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    private func getFileURL() -> URL? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let folderURL = documentURL.appendingPathComponent("")
        return folderURL.appendingPathComponent("\(self).png")
    }
    
    func removeImageFile() {
        guard let fileURL = getFileURL() else { return }
        FileManager.default.deleteFile(at: fileURL)
    }
}
