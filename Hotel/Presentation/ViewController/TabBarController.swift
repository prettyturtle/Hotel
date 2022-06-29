//
//  TabBarController.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = TabBar.viewControllers
        view.tintColor = .mainColor
    }
}
