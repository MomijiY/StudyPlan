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
        tabbar.layer.borderColor = UIColor.clear.cgColor
        tabbar.tintColor = UIColor(red: 0/255, green: 84/255, blue: 147/255, alpha: 1.0)
    }

}
