//
//  ImagePickerHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation
import UIKit
import Fusuma
import Photos

protocol ImagePickerDelegate {
    func cameraHandle(image: UIImage)
    func libraryHandle(images: [UIImage])
}

class ImagePickerHelper: NSObject {
    var title: String
    var message: String
    var isMultiplePick: Bool
    
    private var pickerController: UIImagePickerController?
    var delegate: ImagePickerDelegate?

    init(title: String, message: String, isMultiplePick: Bool = false) {
        self.title = title
        self.message = message
        self.isMultiplePick = isMultiplePick
    }
    
    func showActionSheet() {
        UIAlertController.showActionSheet(source: ImageAction.self,
                                          title: title,
                                          message: message) { [weak self] action in
            guard let self = self else { return }
            self.imagePickerTapped(action: action)
        }
    }
}

extension ImagePickerHelper {
    private func imagePickerTapped(action: ImageAction) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        switch action {
        case .camera:
            fusuma.availableModes = [.camera]
        case .library:
            fusuma.availableModes = [.library]
            fusuma.allowMultipleSelection = isMultiplePick
            fusuma.photoSelectionLimit = 15
        }
        UIApplication.topViewController()?.present(fusuma, animated: true, completion: nil)

    }
}

extension ImagePickerHelper: FusumaDelegate {
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode, metaData: [ImageMetadata]) {
        delegate?.libraryHandle(images: images)
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        delegate?.libraryHandle(images: images)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            delegate?.cameraHandle(image: image)
        case .library:
            delegate?.libraryHandle(images: [image])
        default:
            return
        }
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }
    
    func fusumaCameraRollUnauthorized() {
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        })

        guard let vc = UIApplication.topViewController(),
              let presented = vc.presentedViewController else {
            return
        }

        presented.present(alert, animated: true, completion: nil)
    }
}
