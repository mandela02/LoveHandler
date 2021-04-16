//
//  UIPickerView+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

extension UIPickerView {
    func createInputView() -> UIView {
        // Bug-No74-THANHLD-fix input accessory view lost on IPAD in multi window mode, on right side
        let inputView = UIView()
        inputView.size.height = 216
        inputView.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        inputView.addSubview(self)
        NSLayoutConstraint.activate([
            inputView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inputView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inputView.topAnchor.constraint(equalTo: self.topAnchor),
            inputView.bottomAnchor.constraint(equalTo: self.topAnchor)
        ])
        return inputView
    }
}
