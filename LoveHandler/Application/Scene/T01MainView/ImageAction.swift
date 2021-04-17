//
//  ImageAction.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit

enum ImageAction: CaseIterable {
    case library
    case camera
    
    var name: String {
        switch self {
        case .camera:
            return LocalizedString.t01ImagePickerCamera
        case .library:
            return LocalizedString.t01ImagePickerLibrary
        }
    }
}

extension ImageAction {
    static func showActionSheet(onTap: @escaping (ImageAction) -> Void) {
        let actionSheet: UIAlertController = UIAlertController(title: LocalizedString.t01ImagePickerTitle,
                                                               message: LocalizedString.t01ImagePickerSubTitle,
                                                               preferredStyle: .actionSheet)
        
        actionSheet.overrideUserInterfaceStyle = .light
        
        for action in ImageAction.allCases {
            let alertAction = UIAlertAction(title: action.name,
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
