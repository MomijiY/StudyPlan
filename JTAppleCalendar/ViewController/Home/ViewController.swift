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
import UserNotifications

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance, UIScrollViewDelegate, UIGestureRecognizerDelegate{
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var weekCalendar: FSCalendar!
    @IBOutlet weak var yoteiTableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self
        }
    }
    
    let cellHeight: CGFloat = 100
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var Item: Results<Event>!
    var items = [Event]()
    var currentTime = CurrentTime()
//    var currentTimeFinish = CurrentTimeFinish()
    let alarm = Alarm()
    override func viewDidLoad() {
        super.viewDidLoad()
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        
        currentTime.delegate = self
//        currentTimeFinish.delegate = self
        items = [Event]()
        weekCalendar.delegate = self
        weekCalendar.dataSource = self
        weekCalendar.scope = .month
        weekCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        yoteiTableView.delegate = self
        yoteiTableView.dataSource = self
        yoteiTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        yoteiTableView.tableFooterView = UIView()

        // Realmからデータを取得
            //タップされた日付を生成してます
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = Date()
        let dateStr = formatter.string(from: date)
        navItem.title = dateStr
        UserDefaults.standard.set(navItem.title, forKey: "date")
        let realm = try! Realm()
        let results = realm.objects(Event.self)
        items = [Event]()
        for ev in results {
            if ev.date == dateStr {
                items.append(ev)
            }
        }
        yoteiTableView.reloadData()
        
        // gesture settings
        let swipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(ViewController.swipeUp))
        swipeUpGesture.direction = .up
        let swipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(swipeDown))
        swipeDownGesture.direction = .down
        swipeUpGesture.delegate = self
        swipeDownGesture.delegate = self
        self.weekCalendar.addGestureRecognizer(swipeUpGesture)
        self.weekCalendar.addGestureRecognizer(swipeDownGesture)
        
    }
    // MARK: -- gesture Recognition
    @objc func swipeUp() {
        print("swiped up")
        self.weekCalendar.setScope(.week, animated: true)
        if width == 320.0 && height == 480.0 { //iPhone1,3G,3GS,4,4s
            tableViewHeight.constant = -300
        }
        else if width == 320.0 && height == 568.0 { //iPhone5,5s,5c,SE --OK
            tableViewHeight.constant = -300
        }
        else if width == 375.0 && height == 667.0 { //iPhone6,6s,7,8 --OK
            tableViewHeight.constant = -300
        }
        else if width == 414.0 && height == 736.0 { //iPhone6,6s,7,8 plus --OK
            tableViewHeight.constant = -350
        }
        else if width == 375.0 && height == 812.0 { //iPhoneX,XS,11Pro --OK
            tableViewHeight.constant = -450
        }
        else if width == 414.0 && height == 896.0 { //iPhone XR,11 --OK
            tableViewHeight.constant = -500
        }
        else if width == 414.0 && height == 896.0 { //iPhone XS,11Pro Max --OK
            tableViewHeight.constant = -500
        }
        else { //iPad
            tableViewHeight.constant = -500
        }
        
    }
    @objc func swipeDown() {
        print("swiped down")
        self.weekCalendar.setScope(.month, animated: true)
        if width == 320.0 && height == 480.0 { //iPhone1,3G,3GS,4,4s
            tableViewHeight.constant = 50
        }
        else if width == 320.0 && height == 568.0 { //iPhone5,5s,5c,SE --OK
            tableViewHeight.constant = 50
        }
        else if width == 375.0 && height == 667.0 { //iPhone6,6s,7,8 --OK
            tableViewHeight.constant = 50
        }
        else if width == 414.0 && height == 736.0 { //iPhone6,6s,7,8 plus --OK
            tableViewHeight.constant = 50
        }
        else if width == 375.0 && height == 812.0 { //iPhoneX,XS,11Pro --OK
            tableViewHeight.constant = 50
        }
        else if width == 414.0 && height == 896.0 { //iPhone XR,11 --OK
            tableViewHeight.constant = 50
        }
        else if width == 414.0 && height == 896.0 { //iPhone XS,11Pro Max --OK
            tableViewHeight.constant = 50
        }
        else { //iPad
            tableViewHeight.constant = 50
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            //タップされた日付を生成してます
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = Date()
        let dateStr = formatter.string(from: date)
        navItem.title = dateStr
        UserDefaults.standard.set(navItem.title, forKey: "date")
        let realm = try! Realm()
        let results = realm.objects(Event.self)
        items = [Event]()
        for ev in results {
            if ev.date == dateStr {
                items.append(ev)
            }
        }
        yoteiTableView.reloadData()
        
        
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
            return UIColor.red
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        print(bounds)
        calendarHeight.constant = bounds.height
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
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = formatter.string(from: date)
        navItem.title = date
        UserDefaults.standard.set(navItem.title, forKey: "date")
        let realm = try! Realm()
        let results = realm.objects(Event.self)
        items = [Event]()
        for ev in results {
            if ev.date == date {
                items.append(ev)
            }
        }
        yoteiTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        let selectionview = UIView()
        selectionview.backgroundColor = UIColor(red: 0/255, green: 187/255, blue: 255/255, alpha: 0.2)
        cell.selectedBackgroundView = selectionview
        let memo = items[indexPath.row]
        cell.setUpPlanCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
        if Alarm().seconds > 0 {
            cell.setUpAccessaryCell(timeOne: memo.time1,
                                    timeTwo: memo.time2,
                                    subject: memo.subject,
                                    content: memo.content)
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
                var timer = alarm.studyTimer
                timer?.invalidate()
                timer = nil
                print("削除")
                realm.delete(items[indexPath.row])
                items.remove(at: indexPath.row)
//                alarm.stopNotification()
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["immediately"])
                self.yoteiTableView.reloadData()
            }
        }
    }
}
