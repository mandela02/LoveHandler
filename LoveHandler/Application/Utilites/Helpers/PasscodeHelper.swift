//
//  PasscodeHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 17/07/2021.
//

import UIKit

class PasscodeHelper {
    static func create(at viewController: UIViewController) {
        if let vc = PasscodeViewController.instance(with: .CREATE) {
            vc.show(in: viewController) { (passcode, newPasscode, mode) in
                print(passcode, newPasscode, mode)
                if passcode.lowercased() == "biometric" {
                    vc.dismiss(animated: true, completion: nil)
                } else {
                    vc.startProgressing()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                        vc.stopProgress()
                        vc.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    static func verify() {
        if Settings.isUsingPasscode.value == false { return }
        
        if let vc = PasscodeViewController.instance(with: .VERIFY) {
            vc.show(in: UIApplication.topViewController()) { (passcode, newPasscode, mode) in
                print(passcode, newPasscode, mode)
                if passcode.lowercased() == "biometric" {
                    vc.dismiss(animated: true, completion: nil)
                } else {
                    vc.startProgressing()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                        vc.stopProgress()
                        vc.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
