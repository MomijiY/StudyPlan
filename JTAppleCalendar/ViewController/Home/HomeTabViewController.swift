//
//  HomeTabViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/06/12.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class HomeTabViewController: UITabBarController {

    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbar.accessibilityIdentifier = "tabBar"
        tabbar.layer.borderColor = UIColor.clear.cgColor
        tabbar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }

}
