//
//  UITableView+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import Foundation

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withIdentifier: cellType.className, for: indexPath) as? T {
            return cell
        } else {
            fatalError("Couldn't dequeueReusableCell \(cellType.className)")
        }
    }
}
