//
//  AppDelegate.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigator: AppNavigator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppNavigator()
        AdsHelper.shared.configure()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        PasscodeHelper.verify()
    }
}

extension AppDelegate {
    private func setupAppNavigator() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        navigator = AppNavigator(window: window)
        if Settings.isFirstTimeOpenApp.value {
            _ = UseCaseProvider.defaultProvider.getAppUseCase().save()
            Settings.isFirstTimeOpenApp.value = false
        }
        
        PasscodeHelper.verify()
    }
}
