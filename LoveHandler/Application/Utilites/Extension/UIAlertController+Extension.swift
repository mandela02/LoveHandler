//
//  UIAlertController+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 18/04/2021.
//

import UIKit
import Combine

extension UIAlertController {
    static func showActionSheet<T: CaseIterable & EnumName>(source: T.Type,
                                                            title: String,
                                                            message: String,
                                                            cancelButtontTitle: String = LocalizedString.t01ImagePickerCancel,
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
        
        let cancelAlertAction = UIAlertAction(title: cancelButtontTitle,
                                              style: .cancel,
                                              handler: {_ in })
        
        actionSheet.addAction(cancelAlertAction)
        
        UIApplication.topViewController()?.present(actionSheet, animated: true, completion: nil)
    }
    
    static func inputDialog(currentText: String,
                            title: String,
                            message: String,
                            placeholder: String = "",
                            buttonTitle: String,
                            cancelButtontTitle: String = LocalizedString.t01ImagePickerCancel,
                            onSubmit: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.overrideUserInterfaceStyle = .light
        
        alert.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.text = currentText
        }

        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[safe: 0],
               let userText = textField.text {
                onSubmit(userText)
            }
        }))
        
        let cancelAlertAction = UIAlertAction(title: cancelButtontTitle,
                                              style: .cancel,
                                              handler: {_ in })
        
        alert.addAction(cancelAlertAction)
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    static func alertDialog<T>(title: String,
                            message: String,
                            argument: T?) -> Future<T?, Never> {
        return Future { promise in
            let alert = UIAlertController(title: title,
                                          message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizedString.okButton,
                                          style: .default, handler: { _ in
                promise(.success(argument))
            }))
            alert.addAction(UIAlertAction(title: LocalizedString.cancelButton,
                                          style: .destructive, handler: { _ in
                promise(.success(nil))
            }))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func errorDialog(title: String,
                            message: String) {
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedString.okButton, style: .destructive, handler: { _ in
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }

}
