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
    @IBOutlet weak var weekCalendar: FSCalendar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var dateLabel: UILabel!
    
    let cellHeight: CGFloat = 100
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var Item: Results<Event>!
    var items = [Event]()
    var imItems = [ImportantDate]()
    var ImItems: Results<ImportantDate>!
    
    var sectionName = ["大事な日", "勉強計画"]
    var fpc = FloatingPanelController()
    let contentVC = ContentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(imItems.count)
        self.setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.backgroundImage = UIImage()
//        items = [Event]()
        weekCalendar.delegate = self
        weekCalendar.dataSource = self
        weekCalendar.scope = .month
        weekCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        if homeMonday == true {
            weekCalendar.firstWeekday = 2
            print("begin from Monday")
        } else {
            weekCalendar.firstWeekday = 1
            print("begin from Sunday")
        }
        if width <= 414, height <= 736 {
            self.weekCalendar.appearance.weekdayFont = UIFont(name: "Arial", size: 16)
            self.weekCalendar.appearance.titleFont = UIFont(name: "Arial Hebrew Light", size: 20)
            print("width <= 414, height <= 736")
        } else if width <= 414, height <= 896 {
            self.weekCalendar.appearance.weekdayFont = UIFont(name: "Arial", size: 18)
            self.weekCalendar.appearance.titleFont = UIFont(name: "Arial Hebrew Light", size: 22)
            print("width <= 414, height <= 896")
        } else if width <= 2048, height <= 2732 {
            self.weekCalendar.appearance.weekdayFont = UIFont(name: "Arial", size: 24)
            self.weekCalendar.appearance.titleFont = UIFont(name: "Arial Hebrew Light", size: 28)
            print("width <= 2048, height <= 2732")
        } else {
            self.weekCalendar.appearance.weekdayFont = UIFont(name: "Arial", size: 16)
            self.weekCalendar.appearance.titleFont = UIFont(name: "Arial Hebrew Light", size: 20)
            print("else")
        }
        fpc.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        fpc.track(scrollView: contentVC.tableView)
        fpc.surfaceView.cornerRadius = 24.0
        contentVC.tableView.delegate = self
        contentVC.tableView.dataSource = self
        contentVC.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        contentVC.tableView.register(ImportantDayTableViewCell.nib, forCellReuseIdentifier: ImportantDayTableViewCell.reuseIdentifier)
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes
            = [.font: UIFont(name: "Arial-BoldMT", size: 20)!,
               .foregroundColor: UIColor.white
              ]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        let date = Date()
        let dateStr = formatter.string(from: date)
        dateLabel.text = dateStr
//        UserDefaults.standard.set(dateLabel.text, forKey: "date")
        let realm = try! Realm()
        let results = realm.objects(Event.self).sorted(byKeyPath: "time1")
        ImItems = realm.objects(ImportantDate.self).filter("date == %@", dateStr).sorted(byKeyPath: "pin", ascending: false)
        items = [Event]()
        for ev in results {
            if ev.date == dateStr {
                items.append(ev)
            }
        }
        sectionName = ["大事な日", "勉強計画"]
//        for imev in imResults {
//            if imev.date == dateStr {
//                imItems.append(imev)
//            }
//        }
        contentVC.tableView.reloadData()
        
        let dateUdf = UserDefaults.standard.object(forKey: "date") as? String
        
        if dateUdf != nil {
            let dateUtils = DateUtils.dateFromString(string: dateUdf!, format: "yyyy/M/d")
            weekCalendar.select(dateUtils)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/M/d", options: 0, locale: Locale(identifier: "ja_JP"))
            let nowDate = DateUtils.dateFromString(string: dateFormatter.string(from: Date()), format: "yyyy/M/d")
            weekCalendar.select(nowDate)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if homeMonday == true {
            weekCalendar.firstWeekday = 2
            print("begin from Monday")
        } else {
            weekCalendar.firstWeekday = 1
            print("begin from Sunday")
        }
        let dateUdf = UserDefaults.standard.object(forKey: "date") as? String
        
        if dateUdf != nil {
            let dateUtils = DateUtils.dateFromString(string: dateUdf!, format: "yyyy/M/d")
            weekCalendar.select(dateUtils)
    //        UserDefaults.standard.set(dateLabel.text, forKey: "date")
            let realm = try! Realm()
            let results = realm.objects(Event.self).sorted(byKeyPath: "time1")
            ImItems = realm.objects(ImportantDate.self).filter("date == %@", dateUdf!).sorted(byKeyPath: "pin", ascending: false)
            items = [Event]()
            sectionName = ["大事な日", "勉強計画"]
            for ev in results {
                if ev.date == dateUdf {
                    items.append(ev)
                }
            }
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/M/d", options: 0, locale: Locale(identifier: "ja_JP"))
            let nowDate = DateUtils.dateFromString(string: dateFormatter.string(from: Date()), format: "yyyy/M/d")
            weekCalendar.select(nowDate)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
//        let date = Date()
//        let dateStr = formatter.string(from: date)
//        dateLabel.text = dateUdf
////        UserDefaults.standard.set(dateLabel.text, forKey: "date")
//        let realm = try! Realm()
//        let results = realm.objects(Event.self).sorted(byKeyPath: "time1")
//        ImItems = realm.objects(ImportantDate.self).filter("date == %@", dateUdf!).sorted(byKeyPath: "pin", ascending: false)
//        items = [Event]()
////        sectionName = ["大事な日", "勉強計画"]
//        for ev in results {
//            if ev.date == dateUdf {
//                items.append(ev)
//            }
//        }
//        for imev in imResults {
//            if imev.date == dateStr {
//                imItems.append(imev)
//            }
//        }
        contentVC.tableView.reloadData()
        let currentPageDate = FSCalendar().currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        var stringMonth: String = String(month)
        if month == 1 {
            stringMonth = "January"
        } else if month == 2 {
            stringMonth = "February"
        } else if month == 3 {
            stringMonth = "March"
        } else if month == 4 {
            stringMonth = "April"
        } else if month == 5 {
            stringMonth = "May"
        } else if month == 6 {
            stringMonth = "June"
        } else if month == 7 {
            stringMonth = "July"
        } else if month == 8 {
            stringMonth = "August"
        } else if month == 9 {
            stringMonth = "September"
        } else if month == 10 {
            stringMonth = "October"
        } else if month == 11 {
            stringMonth = "November"
        } else {
            stringMonth = "December"
        }
        navItem.title = stringMonth
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    func setLeftTitle(_ localizedStringKey: String) {
        let titleLabel = UILabel(frame: CGRect(x: 4, y: 0, width: view.frame.width, height: 28))
        titleLabel.text = localizedStringKey.localizedUppercase
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
    }
}

extension ViewController {
    func judgeHoliday(_ date : Date) -> Bool {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        let holiday = CalculateCalendarLogic()
            
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if self.judgeHoliday(date){
            return UIColor(red: 238/255, green: 68/255, blue: 81/255, alpha: 1.0)
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        print(bounds)
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
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/M/d", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateStr = formatter.string(from: date)
        dateLabel.text = dateStr
        UserDefaults.standard.set(dateLabel.text, forKey: "date")
        print("calendar dateStr: \(dateStr)")
        let realm = try! Realm()
        let results = realm.objects(Event.self).filter("date == %@", dateStr).sorted(byKeyPath: "time1")
        ImItems = realm.objects(ImportantDate.self).filter("date == %@", dateStr).sorted(byKeyPath: "pin", ascending: false)
        items = [Event]()
        for ev in results {
            if ev.date == dateStr {
                items.append(ev)
            }
        }
//        for imev in imResults {
//            if imev.date == dateStr {
//                imItems.append(imev)
//            }
//        }
        contentVC.tableView.reloadData()
        
        let dateUdf = UserDefaults.standard.object(forKey: "date") as! String
        let dateUtils = DateUtils.dateFromString(string: dateUdf, format: "yyyy/M/d")
        weekCalendar.select(dateUtils)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        
        var stringMonth: String = String(month)
        
        if month == 1 {
            stringMonth = "January"
        } else if month == 2 {
            stringMonth = "February"
        } else if month == 3 {
            stringMonth = "March"
        } else if month == 4 {
            stringMonth = "April"
        } else if month == 5 {
            stringMonth = "May"
        } else if month == 6 {
            stringMonth = "June"
        } else if month == 7 {
            stringMonth = "July"
        } else if month == 8 {
            stringMonth = "August"
        } else if month == 9 {
            stringMonth = "September"
        } else if month == 10 {
            stringMonth = "October"
        } else if month == 11 {
            stringMonth = "November"
        } else {
            stringMonth = "December"
        }
        navItem.title = stringMonth
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if ImItems == nil {
                return 0
            } else {
                return ImItems.count
            }
        } else if section == 1 {
            return items.count
        } else {
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionName[section]
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectionview = UIView()
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImportantDayTableViewCell.reuseIdentifier, for: indexPath) as! ImportantDayTableViewCell
            let selectionview = UIView()
            selectionview.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.2)

            cell.selectedBackgroundView = selectionview

            cell.cellView.layer.cornerRadius = 20
            selectionview.layer.cornerRadius = 20
            let memo = ImItems[indexPath.row]
            cell.titleLabel.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
            cell.descriptionLabel.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
            cell.dateLabel.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
            cell.cellView.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 1.0)
            if memo.pin == true {
                cell.setupCell(title: self.ImItems[indexPath.row].title, content: self.ImItems[indexPath.row].dateDescription, date: self.ImItems[indexPath.row].date, pin: false)
            }
            if memo.pin == false {
                cell.setupCell(title: self.ImItems[indexPath.row].title, content: self.ImItems[indexPath.row].dateDescription, date: self.ImItems[indexPath.row].date, pin: true)
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
            
            selectionview.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.2)
            cell.selectedBackgroundView = selectionview
            let memo = items[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/M/d HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
            let date = DateUtils.dateFromString(string: memo.time2, format: "yyyy/M/d HH:mm")
            let nowDate = DateUtils.dateFromString(string: dateFormatter.string(from: Date()), format: "yyyy/M/d HH:mm")
            print("nowDate: \(nowDate)")
            if date < nowDate {
                cell.setUpAccessaryCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
//                cell.layer.cornerRadius = 20
                print("過去date: \(date)")
                print("過去の日付です。")
            } else if date == nowDate {
                cell.setUpAccessaryCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
//                cell.layer.cornerRadius = 20
            } else {
                cell.setUpPlanCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
                print("過去ではないdate: \(date)")
            }
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let marginView = UIView()
        let label = UILabel()
        label.text = sectionName[section]
        label.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        label.font = UIFont(name: "Helvetica-Bold", size: 16)
        label.frame = CGRect(x:20, y: -10, width: 100, height: 100)
        marginView.addSubview(label)
        return marginView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let memo = ImItems[indexPath.row]
            UserDefaults.standard.set(memo.title, forKey: "title")
            UserDefaults.standard.set(memo.dateDescription, forKey: "description")
            UserDefaults.standard.set(memo.date, forKey: "imDate")
            self.performSegue(withIdentifier: "toImdateDetail", sender: nil)
        } else if indexPath.section == 1 {
            let memo = items[indexPath.row]
            UserDefaults.standard.set(memo.time1, forKey: "time1")
            UserDefaults.standard.set(memo.time2, forKey: "time2")
            UserDefaults.standard.set(memo.subject, forKey: "subject")
            UserDefaults.standard.set(memo.content, forKey: "content")
            self.performSegue(withIdentifier: "toPlanDetail", sender: nil)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            let realm = try! Realm()
            try! realm.write {
                let memo = items[indexPath.row]
                print("identifier: \(memo.identifier)")
                print("finishIdentifier: \(memo.finishIdentifier)")
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [memo.identifier])
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [memo.finishIdentifier])
                print("削除")
                realm.delete(items[indexPath.row])
                items.remove(at: indexPath.row)
                
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
extension UIView {
    func makeUp(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4
    }
}
