//
//  UIAlertController+.swift
//  Hotel
//
//  Created by yc on 2022/06/28.
//

import UIKit

extension UIAlertController {
    static func showErrorAlert(target viewController: UIViewController) {
        let alertController = UIAlertController(
            title: "ERROR",
            message: "다시 시도해주세요.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction.okAction)
        viewController.present(alertController, animated: true)
    }
    static func showActionSheet(
        target viewController: UIViewController,
        title: String?,
        message: String?,
        actions: [UIAlertAction]
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        actions.forEach { alertController.addAction($0) }
        alertController.addAction(UIAlertAction.cancelAction)
        viewController.present(alertController, animated: true)
    }
}
