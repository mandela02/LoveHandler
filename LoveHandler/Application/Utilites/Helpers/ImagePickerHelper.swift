//
//  ImagePickerHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation
import UIKit
import BSImagePicker
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
            switch action {
            case .camera:
                self.imagePickerTapped(action: action)
            case .library:
                if self.isMultiplePick {
                    self.multiImagePicker()
                } else {
                    self.imagePickerTapped(action: action)
                }
            }
        }
    }
    
    private func imagePickerTapped(action: ImageAction) {
        pickerController = UIImagePickerController()
        
        guard let pickerController = pickerController else { return }
        
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = action == .camera ? .camera : .photoLibrary
        
        UIApplication.topViewController()?.present(pickerController, animated: true, completion: nil)
    }
}

extension ImagePickerHelper: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        picker.dismiss(animated: true, completion: nil)
        
        if picker.sourceType == .camera {
            delegate?.cameraHandle(image: image)
        }
        
        if picker.sourceType == .photoLibrary {
            delegate?.libraryHandle(images: [image])
        }
    }
}

extension ImagePickerHelper {
    private func multiImagePicker() {
        let imagePicker = ImagePickerController()

        imagePicker.settings.selection.max = 15
        imagePicker.settings.selection.unselectOnReachingMax = false
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.albumButton.tintColor = UIColor.green
        imagePicker.cancelButton.tintColor = UIColor.red
        imagePicker.doneButton.tintColor = UIColor.purple
        imagePicker.navigationBar.barTintColor = .black
        imagePicker.settings.theme.backgroundColor = .black
        imagePicker.settings.theme.selectionFillColor = UIColor.gray
        imagePicker.settings.theme.selectionStrokeColor = UIColor.yellow
        imagePicker.settings.theme.selectionShadowColor = UIColor.red
        imagePicker.settings.theme.previewTitleAttributes = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]
        imagePicker.settings.theme.previewSubtitleAttributes = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.white]
        imagePicker.settings.theme.albumTitleAttributes = [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.white]
        imagePicker.settings.list.cellsPerRow = {(verticalSize, horizontalSize) -> Int in
            switch (verticalSize, horizontalSize) {
            case (.compact, .regular): // iPhone5-6 portrait
                return 3
            case (.compact, .compact): // iPhone5-6 landscape
                return 3
            case (.regular, .regular): // iPad portrait/landscape
                return 4
            default:
                return 3
            }
        }

        UIApplication.topViewController()?.presentImagePicker(imagePicker, select: { _ in
        }, deselect: { _ in
        }, cancel: { _ in
        }, finish: { [weak self] assets in
            guard let self = self else { return }
            var images: [UIImage] = []
            for asset in assets {
                self.fetchImage(asset: asset) { image in
                    guard let image = image else { return }
                    images.append(image)
                    
                    if images.count == assets.count {
                        self.delegate?.libraryHandle(images: images)
                    }
                }
            }
        })
    }
    
    private func fetchImage(asset: PHAsset, complete: @escaping (UIImage?) -> Void) {
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: PHImageManagerMaximumSize,
                                              contentMode: .aspectFit,
                                              options: nil) { (image, info) in
            complete(image)
            print(info)
        }
    }

}

extension ImagePickerHelper: UINavigationControllerDelegate {
    
}
