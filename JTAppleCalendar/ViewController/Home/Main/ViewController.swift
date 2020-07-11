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
import FloatingPanel

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance, UIScrollViewDelegate, UIGestureRecognizerDelegate{
//    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var weekCalendar: FSCalendar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var calendarView: UIView!
//    @IBOutlet weak var noneLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let cellHeight: CGFloat = 100
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var Item: Results<Event>!
    var items = [Event]()
    var currentTime = CurrentTime()
    var currentTimeFinish = FinishCurrentTime()
    let alarm = Alarm()
    
    var fpc = FloatingPanelController()
    let contentVC = ContentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.backgroundImage = UIImage()
//        UITabBar.appearance().tintColor = .white
        currentTime.delegate = self
        currentTimeFinish.delegate = self
        items = [Event]()
        weekCalendar.delegate = self
        weekCalendar.dataSource = self
        weekCalendar.scope = .month
        weekCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        self.weekCalendar.appearance.weekdayFont = UIFont(name: "Futura", size: 18)
        self.weekCalendar.appearance.titleFont = UIFont(name: "Helvetica Neue", size: 16)
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
        formatter.dateFormat = "M/d日"
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
        
//        // gesture settings
//        let swipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(
//            target: self,
//            action: #selector(ViewController.swipeUp))
//        swipeUpGesture.direction = .up
//        let swipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(
//            target: self,
//            action: #selector(swipeDown))
//        swipeDownGesture.direction = .down
//        swipeUpGesture.delegate = self
//        swipeDownGesture.delegate = self
//        self.weekCalendar.addGestureRecognizer(swipeUpGesture)
//        self.weekCalendar.addGestureRecognizer(swipeDownGesture)
        
    }
//    // MARK: -- gesture Recognition
//    @objc func swipeUp() {
//        print("swiped up")
//        self.weekCalendar.setScope(.week, animated: true)
//        if width == 320.0 && height == 480.0 { //iPhone1,3G,3GS,4,4s
//            tableViewHeight.constant = -300
//        }
//        else if width == 320.0 && height == 568.0 { //iPhone5,5s,5c,SE --OK
//            tableViewHeight.constant = -300
//        }
//        else if width == 375.0 && height == 667.0 { //iPhone6,6s,7,8 --OK
//            tableViewHeight.constant = -300
//        }
//        else if width == 414.0 && height == 736.0 { //iPhone6,6s,7,8 plus --OK
//            tableViewHeight.constant = -350
//        }
//        else if width == 375.0 && height == 812.0 { //iPhoneX,XS,11Pro --OK
//            tableViewHeight.constant = -450
//        }
//        else if width == 414.0 && height == 896.0 { //iPhone XR,11 --OK
//            tableViewHeight.constant = -500
//        }
//        else if width == 414.0 && height == 896.0 { //iPhone XS,11Pro Max --OK
//            tableViewHeight.constant = -500
//        }
//        else { //iPad
//            tableViewHeight.constant = -500
//        }
//
//    }
//    @objc func swipeDown() {
//        print("swiped down")
//        self.weekCalendar.setScope(.month, animated: true)
//        if width == 320.0 && height == 480.0 { //iPhone1,3G,3GS,4,4s
//            tableViewHeight.constant = 50
//        }
//        else if width == 320.0 && height == 568.0 { //iPhone5,5s,5c,SE --OK
//            tableViewHeight.constant = 50
//        }
//        else if width == 375.0 && height == 667.0 { //iPhone6,6s,7,8 --OK
//            tableViewHeight.constant = 50
//        }
//        else if width == 414.0 && height == 736.0 { //iPhone6,6s,7,8 plus --OK
//            tableViewHeight.constant = 50
//        }
//        else if width == 375.0 && height == 812.0 { //iPhoneX,XS,11Pro --OK
//            tableViewHeight.constant = 50
//        }
//        else if width == 414.0 && height == 896.0 { //iPhone XR,11 --OK
//            tableViewHeight.constant = 50
//        }
//        else if width == 414.0 && height == 896.0 { //iPhone XS,11Pro Max --OK
//            tableViewHeight.constant = 50
//        }
//        else { //iPad
//            tableViewHeight.constant = 50
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            //タップされた日付を生成してます
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
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
            return UIColor(red: 235/255, green: 53/255, blue: 127/255, alpha: 1.0)
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
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "M/d", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateStr = formatter.string(from: date)
        let now: Date = Date()
        let justNow: Date = now
        print("calendar justNow: \(justNow)")
        if date < now {
            let memo = items[IndexPath().row]
            
            let cell = contentVC.tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: IndexPath()) as! TableViewCell
            cell.setUpAccessaryCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
            print("過去の日付です")
        } else if date == justNow {
            print("今日の日付です")
        } else {
            print("未来の日付です")
        }
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
        cell.setUpPlanCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
//        let dateUdf = UserDefaults.standard.object(forKey: "date")
//        let date = DateUtils.dateFromString(string: dateUdf as! String, format: "M/d")
////        print(date)
//        print("tableView dateUdf: \(String(describing: dateUdf))")
//        let now = Date()
//        print("tableView now: \(now)")
//        if date > now {
//            print("未来の日付です")
//        } else if date < now {
////            cell.setUpAccessaryCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
//            print("過去の日付です")
//        } else if date == now {
//            print("今日の日付です")
//        }
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
                Alarm().stopNotification()
                print("削除")
                realm.delete(items[indexPath.row])
                items.remove(at: indexPath.row)
//                alarm.stopNotification()
                
                contentVC.tableView.reloadData()
            }
        }
    }
}


extension ViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanel()
    }
}
