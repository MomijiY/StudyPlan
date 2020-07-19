//
//  ViewController.swift
//  JTAppleCalendar
//

//  Created by 吉川椛 on 2020/05/10.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift
import os
import FloatingPanel
import QuartzCore
class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance, UIScrollViewDelegate, UIGestureRecognizerDelegate{
//    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var weekCalendar: FSCalendar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var plusButton: UIBarButtonItem!
//    @IBOutlet weak var calendarView: UIView!
//    @IBOutlet weak var noneLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let cellHeight: CGFloat = 100
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var Item: Results<Event>!
    var items = [Event]()
    
    var fpc = FloatingPanelController()
    let contentVC = ContentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.backgroundImage = UIImage()
//        UITabBar.appearance().tintColor = .white
        items = [Event]()
        weekCalendar.delegate = self
        weekCalendar.dataSource = self
        weekCalendar.scope = .month
        weekCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        self.weekCalendar.appearance.weekdayFont = UIFont(name: "Futura", size: 18)
        self.weekCalendar.appearance.titleFont = UIFont(name: "Futura-light", size: 16)
//        yoteiTableView.delegate = self
//        yoteiTableView.dataSource = self
//        yoteiTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
//        yoteiTableView.tableFooterView = UIView()
//        yoteiTableView.separatorColor = .white
        fpc.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        fpc.track(scrollView: contentVC.tableView)
        contentVC.tableView.delegate = self
        contentVC.tableView.dataSource = self
        contentVC.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        self.navigationController!
            .navigationBar
            .setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        // Realmからデータを取得
            //タップされた日付を生成してます
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        let date = Date()
        let dateStr = formatter.string(from: date)
        dateLabel.text = dateStr
        UserDefaults.standard.set(dateLabel.text, forKey: "date")
        let realm = try! Realm()
        let results = realm.objects(Event.self)
        items = [Event]()
        for ev in results {
            if ev.date == dateStr {
                items.append(ev)
            }
        }
        contentVC.tableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            //タップされた日付を生成してます
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        let date = Date()
        let dateStr = formatter.string(from: date)
        dateLabel.text = dateStr
        UserDefaults.standard.set(dateLabel.text, forKey: "date")
        let realm = try! Realm()
        let results = realm.objects(Event.self)
        items = [Event]()
        for ev in results {
            if ev.date == dateStr {
                items.append(ev)
            }
        }
        contentVC.tableView.reloadData()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

}

extension ViewController {
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
            
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
            
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }


    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
        
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
        
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if self.judgeHoliday(date){
//            let appearance = self.weekCalendar.appearance.titleFont = UIFont(name: "Futura-Bold", size: 16)
            return UIColor(red: 238/255, green: 68/255, blue: 81/255, alpha: 1.0)
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        print(bounds)
//        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        
        UserDefaults.standard.set(year, forKey: "year")
        UserDefaults.standard.set(month, forKey: "month")
        UserDefaults.standard.set(day, forKey: "day")
            //タップされた日付を生成してます
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/M/d", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateStr = formatter.string(from: date)
        dateLabel.text = dateStr
        UserDefaults.standard.set(dateLabel.text, forKey: "date")
        print("calendar dateStr: \(dateStr)")
        let realm = try! Realm()
        let results = realm.objects(Event.self)
        items = [Event]()
        for ev in results {
            if ev.date == dateStr {
                items.append(ev)
            }
        }
        contentVC.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if items.count == 0 {
//            noneLabel.isHidden = false
//        } else {
//            noneLabel.isHidden = true
//        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        let selectionview = UIView()
        selectionview.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.2)
        cell.selectedBackgroundView = selectionview
        let memo = items[indexPath.row]
        let now = Date()
        let dateUdf = UserDefaults.standard.object(forKey: "date")
        let date = DateUtils.dateFromString(string: dateUdf as! String, format: "yyyy/M/d")
        if date < now {
            cell.setUpAccessaryCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
            print("過去date: \(date)")
            print("過去の日付です。")
        } else {
            cell.setUpPlanCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
            print("過去ではないdate: \(date)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memo = items[indexPath.row]
        UserDefaults.standard.set(memo.time1, forKey: "time1")
        UserDefaults.standard.set(memo.time2, forKey: "time2")
        UserDefaults.standard.set(memo.subject, forKey: "subject")
        UserDefaults.standard.set(memo.content, forKey: "content")
        self.performSegue(withIdentifier: "toPlanDetail", sender: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            let realm = try! Realm()
            try! realm.write {
                //通知を削除する。
//                Alarm().stopNotification()
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["CalendarNotification"])
                print(UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["CalendarNotification"]))
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["CalendarNotificationFinish"])
                print(UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["CalendarNotificationFinish"]))
                print("削除")
                realm.delete(items[indexPath.row])
                items.remove(at: indexPath.row)
//                alarm.stopNotification()
                
                contentVC.tableView.reloadData()
            }
        }
    }
}


extension ViewController: FloatingPanelControllerDelegate, FloatingPanelLayout {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return ViewController()
    }
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
//            self.weekCalendar.setScope(.week, animated: true)
//            weekCalendar.scope = .week
            return 16.0
        case .half:
//            weekCalendar.scope = .week
            return 400.0
        case .tip:
//            weekCalendar.scope = .month
            return 216.0
        default: return nil
        }
    }
    
    var supportedPositions: Set<FloatingPanelPosition> {
        return[.full, .half, .tip]
    }
}
extension UIView {
    func makeUp(){
//        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4
    }
}
