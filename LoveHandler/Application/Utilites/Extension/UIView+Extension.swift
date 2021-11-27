//
//  UIView+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var leading: CGFloat {
        return self.frame.origin.x
    }
    
    var trailing: CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    var top: CGFloat {
        return self.frame.origin.y
    }
    
    var bottom: CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    var position: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
        
    @IBInspectable var viewBorderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
        
    class var navigationBarHeight: CGFloat {
        return UINavigationController().navigationBar.frame.size.height
    }
    
    class var tabBarHeight: CGFloat {
        return UITabBarController().tabBar.frame.size.height
    }
    
    public class func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    public class func loadNib<T: UIView>() -> T! {
        let name = String(describing: self)
        let bundle = Bundle(for: T.self)
        guard let xib = bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T else {
            fatalError("Cannot load nib named `\(name)`")
        }
        return xib
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            return UIView()
        }
        return view
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shake(duration: CFTimeInterval = 0.07, repeatCount: Float = 3) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    enum ViewSide: String {
        case left = "LeftSide"
        case right = "RightSide"
        case top = "TopSide"
        case bottom = "BottomSide"
    }
    
    func addBorder(toSide sides: ViewSide..., withColor color: UIColor, andThickness thickness: CGFloat) {
        let sideNames = sides.map { $0.rawValue }
        _ = layer.sublayers?.filter({ sideNames.contains($0.name ?? "") }).map { $0.removeFromSuperlayer() }
        for side in sides {
            let border = CALayer()
            border.name = "\(side.rawValue)"
            border.backgroundColor = color.cgColor
            switch side {
            case .left: border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            case .right: border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            case .top: border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
            case .bottom: border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            }
            self.layoutIfNeeded()
            layer.addSublayer(border)
        }
    }
    
    func removeAllSubviews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func fadeIn(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.isHidden = false
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.isHidden = true
        }, completion: completion)
    }
    
    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
    
    func updateConstraintsAndLayout() {
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func swipeAnimation(isSwipeLeft: Bool, duration: TimeInterval = 0.5) {
        let transition = CATransition()
        transition.type = .push
        transition.subtype = isSwipeLeft ? .fromRight : .fromLeft
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.fillMode = .removed
        self.layer.add(transition, forKey: nil)
    }
    
    func createGradientLayer(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint, cornerRadius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = cornerRadius
        self.layer.addSublayer(gradientLayer)
    }
    
    func scaleWithBounce(in duration: TimeInterval, springDamping: CGFloat, isShow: Bool = true) {
        let options: UIView.AnimationOptions = isShow ? .curveEaseOut : .curveLinear
        let transform: CGAffineTransform = isShow ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: duration, delay: 0.0,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: 0.0,
                       options: options,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        self.transform = transform
                       }, completion: { [weak self] _ in
                        guard let self = self, !isShow else { return }
                        self.isHidden = true
                       })
    }
    
    func moveY(to yPos: CGFloat, in duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.frame.origin.y = yPos
        }
    }
    func moveX(to xPos: CGFloat, in duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.0,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        self.frame.origin.x = xPos
                       }, completion: nil)
    }
    
    func getScreenshotOfView() -> UIImage? {
        let contentSize = self.size
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func getDeviceScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage: UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in: context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    func createPickerInputView() -> UIView {
        // fix input accessory view lost on IPAD in multi window mode, on right side
        let inputView = UIView()
        inputView.size.height = 216
        inputView.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        inputView.addSubview(self)
        NSLayoutConstraint.activate([
            inputView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inputView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inputView.topAnchor.constraint(equalTo: self.topAnchor),
            inputView.bottomAnchor.constraint(equalTo: self.topAnchor)
        ])
        return inputView
    }
    
    func copyView<T: UIView>() -> T? {
        do {
            let archivedObj = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedObj) as? T
        } catch {
            return nil
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        } completion: { [weak self] done in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear) { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            } completion: { [weak self] _ in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
    
    static func getHeaderViewForSection(with title: String) -> UIView? {
        guard !title.isEmpty else { return nil }
        let header = UIView()
        header.backgroundColor = .clear
        let headerTitle = UILabel()
        header.addSubview(headerTitle)
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        [headerTitle.centerYAnchor.constraint(equalTo: header.centerYAnchor),
         headerTitle.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20)]
            .forEach { $0.isActive = true }
        headerTitle.frame.origin.x = 20
        headerTitle.font = UIFont.systemFont(ofSize: 11)
        headerTitle.text = title
        return header
    }
}
