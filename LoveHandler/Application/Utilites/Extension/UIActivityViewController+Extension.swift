//
//  UIActivityController+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 20/06/2021.
//

import UIKit

extension UIActivityViewController {
    static func share(image: UIImage, at view: UIView) {
        guard let url = self.saveImage(image: image) else { return }
        let imageToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: imageToShare,
                                                              applicationActivities: nil)
        activityViewController
            .popoverPresentationController?
            .sourceView = view
        
        UIApplication.topViewController()?
            .present(activityViewController,
                     animated: true,
                     completion: nil)
    }
    
    static private func saveImage(image: UIImage) -> URL? {
        let fileName = LocalizedString.appName + ".png"
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory
            .appendingPathComponent(fileName)
        
        guard let data = image.jpeg(.highest) else { return nil }

        removeCaptureImage(with: fileURL)

        do {
            try data.write(to: fileURL)
            return fileURL
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    static private func removeCaptureImage(with fileURL: URL) {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
    }
}
