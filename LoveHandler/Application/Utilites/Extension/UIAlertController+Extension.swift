//
//  UIAlertController+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 18/04/2021.
//

import UIKit

extension UIAlertController {
    static func showActionSheet<T: CaseIterable & EnumName>(source: T.Type,
                                                            title: String,
                                                            message: String,
                                                            onTap: @escaping (T) -> Void) {
        let actionSheet: UIAlertController = UIAlertController(title: title,
                                                               message: message,
                                                               preferredStyle: .actionSheet)
        
        actionSheet.overrideUserInterfaceStyle = .light
        
        for action in T.allCases {
            let alertAction = UIAlertAction(title: action.getName(),
                                        style: .default,
                                        handler: { _ in
                                            onTap(action)
                                        })
            actionSheet.addAction(alertAction)
        }
        
        let cancelAlertAction = UIAlertAction(title: LocalizedString.t01ImagePickerCancel,
                                    style: .cancel,
                                    handler: {_ in })
        
        actionSheet.addAction(cancelAlertAction)
        
        UIApplication.topViewController()?.present(actionSheet, animated: true, completion: nil)
    }
}
