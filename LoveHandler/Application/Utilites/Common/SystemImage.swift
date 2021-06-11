//
//  SystemImage.swift
//  LoveHandler
//
//  Created by LanNTH on 11/06/2021.
//

import UIKit

enum SystemImage: String {
    case roundHeart = "suit.heart.fill"
    case xMark = "xmark"
}

extension SystemImage {
    var image: UIImage? {
        return self.rawValue.sysImage
    }
}
