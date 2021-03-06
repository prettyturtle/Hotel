//
//  TabBar.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import UIKit

enum TabBar: CaseIterable {
    case total
    case bookmark
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .total:
            return UITabBarItem(
                title: "전체",
                image: Icon.house.image,
                selectedImage: Icon.houseFill.image
            )
        case .bookmark:
            return UITabBarItem(
                title: "찜",
                image: Icon.heart.image,
                selectedImage: Icon.heartFill.image
            )
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .total:
            return UINavigationController(rootViewController: TotalListViewController())
        case .bookmark:
            return UINavigationController(rootViewController: BookmarkViewController())
        }
    }
    
    static var viewControllers: [UIViewController] {
        return TabBar.allCases.map {
            let tabBarItem = $0.tabBarItem
            let viewController = $0.viewController
            viewController.tabBarItem = tabBarItem
            return viewController
        }
    }
}
