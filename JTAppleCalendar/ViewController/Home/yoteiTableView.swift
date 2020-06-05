//
//  yoteiTableView.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar

class yoteiTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    var Item: Results<Event>!
    let cellHeight: CGFloat = 100
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        let memo = Item[indexPath.row]
        cell.setUpPlanCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.contetnt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // Realm内のデータを削除
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.Item[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }catch{
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //タップされた日付を生成してます
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = formatter.string(from: date)
        let realm = try! Realm()
        let results = realm.objects(Event.self)
        for ev in results {
            if ev.date == date {
                print("ev: \(ev.subject)")
                let data = AddPlan(timeOne: ev.time1, timeTwo: ev.time2, subject: ev.subject, content: ev.contetnt, date: ev.date)
                
            }
        }
    }
    
}
