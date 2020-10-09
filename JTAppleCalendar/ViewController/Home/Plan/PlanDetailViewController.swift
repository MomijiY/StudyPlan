//
//  PlanDetailViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/18.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift

class PlanDetailViewController: UITableViewController {

    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var afterStudyStars: UILabel!
    @IBOutlet weak var afterStudyComment: UILabel!
    @IBOutlet weak var afterStudyButton: UIBarButtonItem!
    
    var items = [Event]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        time1Label.text = UserDefaults.standard.object(forKey: "time1") as? String
        time2Label.text = UserDefaults.standard.object(forKey: "time2") as? String
        subjectLabel.text = UserDefaults.standard.object(forKey: "subject") as? String
        contentLabel.text = UserDefaults.standard.object(forKey: "content") as? String
        
        print(UserDefaults.standard.object(forKey: "pastTrue"))
        if UserDefaults.standard.object(forKey: "pastTrue") as? String == "true" {
            afterStudyButton.isEnabled = true
            afterStudyButton.tintColor =  UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        } else {
            afterStudyButton.isEnabled = false
            afterStudyButton.tintColor = .clear
        }
        
        let results = realm.objects(Event.self)
        for ev in results {
            if ev.time1 == time1Label.text {
                items.append(ev)
                afterStudyStars.text = ev.afterStudyStars
                afterStudyComment.text = ev.afterStudyComment
            }
        }
        
        
        tableView.estimatedRowHeight = 263
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNeedsStatusBarAppearanceUpdate()
        
        time1Label.text = UserDefaults.standard.object(forKey: "time1") as? String
        time2Label.text = UserDefaults.standard.object(forKey: "time2") as? String
        subjectLabel.text = UserDefaults.standard.object(forKey: "subject") as? String
        contentLabel.text = UserDefaults.standard.object(forKey: "content") as? String
        
        print(UserDefaults.standard.object(forKey: "pastTrue"))
        if UserDefaults.standard.object(forKey: "pastTrue") as? String == "true" {
            afterStudyButton.isEnabled = true
            afterStudyButton.tintColor =  UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        } else {
            afterStudyButton.isEnabled = false
            afterStudyButton.tintColor = .clear
        }
        
        let results = realm.objects(Event.self)
        
        for ev in results {
            if ev.time1 == time1Label.text {
                items.append(ev)
                afterStudyStars.text = ev.afterStudyStars
                afterStudyComment.text = ev.afterStudyComment
            }
        }
        
        
        tableView.estimatedRowHeight = 263
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if afterStudyButton.isEnabled == true {
            return 4
        } else {
            return 3
        }
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 3 {
//            if afterStudyButton.isEnabled == true {
//                return 2
//            } else {
//                return 0
//            }
//        } else {
//            return 1
//        }
//    }
}
