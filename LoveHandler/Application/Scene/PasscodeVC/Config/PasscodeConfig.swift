//
//  PasscodeConfig.swift
//  Passcode
//
//  Created by hb on 08/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class PasscodeConfig: NSObject {
    var logoImg: UIImage?
    var backspaceImg: UIImage? = SystemImage.backspace.image
    var touchIdImg: UIImage? = SystemImage.touchid.image
    var faceIdImg: UIImage? = SystemImage.faceid.image

    var backgroundColor: UIColor = .darkGray
    var msgColor: UIColor = .white
    var keyTintColor: UIColor = .white
    var keyHighlitedTintColor: UIColor = .lightGray
    var keyHighlitedBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.2)

    var digitColor: UIColor = .white

    var noOfDigits: Int = 4
    var isRandomKeyEnabled = false
    
    var title: String {
        return LocalizedString.passcodeViewTitle
    }
    var viewDesctiption: String {
        return LocalizedString.passcodeViewDescription
    }
    var confirmMessage: String {
        return LocalizedString.passcodeViewConfirmMesseage
    }
    var notMatchMessage: String {
        return LocalizedString.passcodeViewNotMatchMessage
    }
}
