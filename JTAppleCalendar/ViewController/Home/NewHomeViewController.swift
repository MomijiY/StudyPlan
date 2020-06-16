//
//  NewHomeViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/06/13.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import FloatingPanel
import FSCalendar
import RealmSwift
import CalculateCalendarLogic

class NewHomeViewController: UIViewController, FloatingPanelControllerDelegate,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    let semiModalViewController = SemiModalViewController()
    var floatingPanelController: FloatingPanelController!
    var items = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNeedsStatusBarAppearanceUpdate()
        items = [Event]()
        
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
        semiModalViewController.tableView.reloadData()
        
        floatingPanelController = FloatingPanelController()

        // セミモーダルビューとなるViewControllerを生成し、contentViewControllerとしてセットする
        floatingPanelController.set(contentViewController: semiModalViewController)

        // セミモーダルビューを表示する
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
        floatingPanelController = FloatingPanelController()
        // Delegateを設定
        floatingPanelController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            //タップされた日付を生成してます
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
        semiModalViewController.tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // セミモーダルビューを非表示にする
        floatingPanelController.removePanelFromParent(animated: true)
    }
}

extension NewHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        let selectionview = UIView()
        selectionview.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.2)
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
                var timer = Alarm().studyTimer
                timer?.invalidate()
                timer = nil
                print("削除")
                realm.delete(items[indexPath.row])
                items.remove(at: indexPath.row)
    //               alarm.stopNotification()
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["immediately"])
                semiModalViewController.tableView.reloadData()
                }
            }
        }
}

extension NewHomeViewController: FloatingPanelLayout {
    // セミモーダルビューの初期位置
    var initialPosition: FloatingPanelPosition {
        return .half
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        switch targetPosition {
        case .tip:
            print("tip")
        case .half:
            print("half")
        case .full:
            print("full")
        case .hidden:
            print("hidden")
        }
    }

    var topInteractionBuffer: CGFloat { return 0.0 }
    var bottomInteractionBuffer: CGFloat { return 0.0 }

    // セミモーダルビューの各表示パターンの高さを決定するためのInset
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 56.0
        case .half: return 262.0
        case .tip: return 100.0
        default: return nil
        }
    }

    // セミモーダルビューの背景Viewの透明度
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}

extension NewHomeViewController {
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
            return UIColor.yellow
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
            //タップされた日付を生成してます
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = formatter.string(from: date)
        let realm = try! Realm()
        let results = realm.objects(Event.self)
        items = [Event]()
        for ev in results {
            if ev.date == date {
                items.append(ev)
            }
        }
        semiModalViewController.tableView.reloadData()
    }
}
