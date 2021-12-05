//
//  ImagePickerHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation
import UIKit
import PhotosUI
import Photos

protocol ImagePickerDelegate: AnyObject {
    func didPickImage(images: [UIImage])
}

typealias CameraPickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

class ImagePickerHelper: NSObject {
    var title: String
    var message: String
    var isMultiplePick: Bool
    
    lazy var configuration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        if isMultiplePick {
            configuration.selectionLimit = 10
        } else {
            configuration.selectionLimit = 1
        }
        configuration.filter = .images
        return configuration
    }()
    
    lazy var imagePicker: PHPickerViewController = {
        var imagePicker =  PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        return imagePicker
    }()
    
    lazy var cameraPicker: UIImagePickerController = {
        var imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        return imagePicker
    }()

    weak var delegate: ImagePickerDelegate?

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
        switch action {
        case .camera:
            UIApplication.topViewController()?.present(cameraPicker, animated: true, completion: nil)
        case .library:
            UIApplication.topViewController()?.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ImagePickerHelper: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.fetchImage(from: picker, results: results)
        })
    }
    private func fetchImage(from picker: PHPickerViewController, results: [PHPickerResult]) {
        guard !results.isEmpty else {
            return
        }
        
        let identifier = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifier, options: nil)
        
        var resultCount = 0
        var images: [UIImage] = []
                
        fetchResult.enumerateObjects { [weak self] (asset, _, _) in
            guard let self = self else { return }
            resultCount += 1
            
            asset.getImage { image in
                if let image = image {
                    images.append(image)
                    
                    if images.count == resultCount {
                        self.delegate?.didPickImage(images: images)
                    }
                }
            }
        }
    }
}

extension ImagePickerHelper: CameraPickerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            print(#function)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            self.delegate?.didPickImage(images: [image])
        }
    }
}

extension ImagePickerHelper {
    func unauthorizationHandle() {
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

private extension PHAsset {
    func getImage(completionHandler: @escaping (UIImage?) -> Void) {
        let imageManager = PHCachingImageManager()
        
        let options = PHImageRequestOptions()
        options.version = .current
        options.isSynchronous = true

        imageManager.requestImage(for: self,
                                  targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                                  contentMode: .aspectFit,
                                  options: options,
                                  resultHandler: { image, _ in
                completionHandler(image)
        })
    }
}
