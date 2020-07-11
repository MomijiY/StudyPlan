//
//  NavViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/06/12.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = UIColor(red: 0/255, green: 84/255, blue: 147/255, alpha: 1.0)
    }
}
