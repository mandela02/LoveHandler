//
//  AdsHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 17/07/2021.
//

import UIKit.UIViewController
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@objc protocol AdsPresented {
    @objc optional func removeAdsIfNeeded(bannerView: UIView)
    @objc optional func bannerViewDidShow(bannerView: UIView, height: CGFloat)
}

class AdsHelper: NSObject, GADBannerViewDelegate {
    
    private var bannerView: GADBannerView?
    var isBannerViewDidLoad: Bool = false
    static let BannerViewLoadedNotification = "BannerViewLoadedNotification"
    
    static let shared = AdsHelper()
    
    private override init() {
        super.init()
    }
    
    static var showAdsAfterDay: Int {
//        return Int(AppConfig.showAdsAfterDay) ?? 0
        return 0
    }
    
    static func shouldDisplayAds() -> Bool {
        return true
//        return !Settings.isAdsRemoved.value && Utilities.usedAppDays() >= showAdsAfterDay
    }
    
    func configure() {
        if AdsHelper.shouldDisplayAds() {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            bannerView = GADBannerView()
            bannerView!.adUnitID = AppConfig.adsIDs
            bannerView!.delegate = self
            bannerView!.backgroundColor = .clear
            bannerView!.load(GADRequest())
        }
    }
    
    func getBannerView() -> GADBannerView? {
        return bannerView
    }
    
    static func adsSize(width: CGFloat) -> GADAdSize {
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
    }
    
    func removeBannerView() {
        bannerView?.removeFromSuperview()
        bannerView = nil
    }
            
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        isBannerViewDidLoad = true
        NotificationCenter.default.post(name: .BannerViewLoadedNotification, object: true)
    }
}

extension AdsPresented where Self: UIViewController {
    func setBannerView(with container: UIView,
                       heightConstraint: NSLayoutConstraint,
                       forceUpdate: Bool = false,
                       fixedWidth: CGFloat? = nil) {
        guard AdsHelper.shouldDisplayAds() else {
            container.isHidden = true
            heightConstraint.constant = 0
            return
        }
        
        guard let bannerView = AdsHelper.shared.getBannerView(),
              container.subviews.firstIndex(of: bannerView) == nil || forceUpdate
        else {
            return
        }
     
        initBannerView(container, bannerView, heightConstraint, fixedWidth)
        
        setAnimationWhenLoaded(container)
        
        addAdsRemoveNotification(container, heightConstraint)
    }
    
    private func setAnimationWhenLoaded(_ container: UIView) {
        container.alpha = 0
        if AdsHelper.shared.isBannerViewDidLoad {
            container.alpha = 1
            self.bannerViewDidShow?(bannerView: container, height: container.frame.height)
        } else {
            _ = NotificationCenter.default
                .addObserver(forName: .BannerViewLoadedNotification,
                             object: nil, queue: nil) { notification in
                    guard let isLoaded = notification.object as? Bool else { return }
                    if isLoaded {
                        UIView.animate(withDuration: 0.3, animations: {
                            container.alpha = 1
                        }, completion: nil)
                        self.bannerViewDidShow?(bannerView: container, height: container.frame.height)
                    }
                }
        }
    }
    
    // fixedWidth: is fixed size of banner, if nil return width of window
    private func initBannerView(_ container: UIView,
                                _ bannerView: GADBannerView,
                                _ heightConstraint: NSLayoutConstraint,
                                _ fixedWidth: CGFloat? = nil) {
        container.isHidden = false
        container.backgroundColor = .clear
        container.addSubview(bannerView)
        bannerView.rootViewController = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: container.topAnchor),
            bannerView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            bannerView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        let adSize = AdsHelper.adsSize(width: fixedWidth ?? Utilities.getWindowBound().width)
        bannerView.adSize = adSize
        heightConstraint.constant = adSize.size.height
    }
    
    private func addAdsRemoveNotification(_ container: UIView, _ heightConstraint: NSLayoutConstraint) {
//        _ = NotificationCenter.default
//            .addObserver(forName: .IAPHelperPurchaseNotification,
//                         object: nil, queue: nil) {[weak self] notification in
//                guard let isPurchase = notification.object as? Bool else { return }
//                if isPurchase {
//                    self?.removeAdsIfNeeded?(bannerView: container)
//                    AdsHelper.shared.removeBannerView()
//                    heightConstraint.constant = 0
//                }
//            }
    }
}

extension NSNotification.Name {
    static let BannerViewLoadedNotification = NSNotification.Name(AdsHelper.BannerViewLoadedNotification)
//    static let IAPHelperPurchaseNotification = NSNotification.Name(IAPHelper.IAPHelperPurchaseNotification)
    static let languageChangeObserver = NSNotification.Name(rawValue: Strings.languageChangedObserver)
}
