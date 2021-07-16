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
    case camera = "camera.circle"
    case background = "photo.on.rectangle.angled"
    case language = "globe"
    case heartCircleFill = "heart.circle.fill"
    case faceDashFill = "face.dashed.fill"
    case lockOpenFill = "lock.open.fill"
    case lockFill = "lock.fill"
    case handThumsUpFill = "hand.thumbsup.fill"
    case clapSparklesFill = "hands.sparkles.fill"
    case trashFill = "trash.fill"
    case dollarsignCircleFill = "dollarsign.circle.fill"
    case sunMinFill = "sun.min.fill"
    case checkMark = "checkmark.circle.fill"
    case arrowUpSquare = "arrow.up.square"
    case trash = "trash"
    case faceid = "faceid"
    case backspace = "delete.left.fill"
    case touchid = "touchid"
}

extension SystemImage {
    var image: UIImage {
        return self.rawValue.sysImage ?? UIImage()
    }
}
