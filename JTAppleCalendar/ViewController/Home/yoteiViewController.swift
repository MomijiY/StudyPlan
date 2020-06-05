//
//  yoteiViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/19.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class yoteiViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    
    var Item: Results<Event>!
    var items = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [Event]()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = Date()
        let dateStr = formatter.string(from: date)
        let realm = try! Realm()
        let results = realm.objects(Event.self)
        items = [Event]()
        for ev in results {
            if ev.date == dateStr {
                items.append(ev)
            }
        }
    }
}
