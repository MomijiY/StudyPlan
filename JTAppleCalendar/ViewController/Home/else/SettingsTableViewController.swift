//
//  SettingsTableViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/10/04.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
var homeMonday = Bool()
class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var homeMondaySetSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if homeMonday == true {
            homeMondaySetSwitch.isOn = true
            print("view did load true")
        } else {
            homeMonday  = false
            homeMondaySetSwitch.isOn = false
            print("view did load false")
        }
    }
    @IBAction func homeMondaydidChange(_ sender: UISwitch) {
        if sender.isOn {
            homeMonday = true
            UserDefaults.standard.set(homeMonday, forKey: "mondayTrue")
//            print("sender on")
            print("sender on \(homeMonday)")
        } else {
            homeMonday = false
            UserDefaults.standard.set(homeMonday, forKey: "mondayFalse")
//            print("sender off")
            print("sender off \(homeMonday)")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        if homeMonday == true {
//            homeMondaySetSwitch.isOn = true
//        } else {
//            homeMondaySetSwitch.isOn = false
//        }
        if homeMondaySetSwitch.isOn == true {
            homeMondaySetSwitch.isOn = true
            homeMonday = true
            print("viewWillDisappear true")
        } else {
            homeMonday = false
            homeMondaySetSwitch.isOn = false
            print("viewWillDisappear false")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if homeMonday == true {
            homeMondaySetSwitch.isOn = true
            homeMonday = true
            print("viewDidDisappear true")
        } else {
            homeMonday  = false
            homeMondaySetSwitch.isOn = false
            print("viewDidDisappear false")
        }
    }
}
