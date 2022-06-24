//
//  Icon.swift
//  Hotel
//
//  Created by yc on 2022/06/25.
//

import UIKit

enum Icon {
    case house
    case houseFill
    case heart
    case heartFill
    case starFill
    case arrowUpDown
    
    var image: UIImage? {
        switch self {
        case .house:
            return UIImage(systemName: "house")
        case .houseFill:
            return UIImage(systemName: "house.fill")
        case .heart:
            return UIImage(systemName: "heart")
        case .heartFill:
            return UIImage(systemName: "heart.fill")
        case .starFill:
            return UIImage(systemName: "star.fill")
        case .arrowUpDown:
            return UIImage(systemName: "arrow.up.arrow.down")
        }
    }
}
