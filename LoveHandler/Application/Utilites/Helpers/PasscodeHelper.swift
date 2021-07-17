//
//  PasscodeHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 17/07/2021.
//

import UIKit
import KeychainSwift

class PasscodeHelper {
    private static let key = "passcode"
    
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
    
    static func savePasscode(passcode: String) {
        let keychain = KeychainSwift()
        keychain.set(passcode, forKey: "key")
    }
    
    static func getPasscode() -> String? {
        let keychain = KeychainSwift()
        return keychain.get("key")
    }
    
    static func isPasscodeCorrect(input: String) -> Bool {
        guard let passcode = getPasscode() else { return false }
        return passcode == input
    }
}
