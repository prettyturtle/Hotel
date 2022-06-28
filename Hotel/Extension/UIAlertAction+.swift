//
//  UIAlertAction+.swift
//  Hotel
//
//  Created by yc on 2022/06/28.
//

import UIKit

extension UIAlertAction {
    static var okAction: UIAlertAction {
        return .init(title: "확인", style: .default)
    }
    static var cancelAction: UIAlertAction {
        return .init(title: "취소", style: .cancel)
    }
}
