//
//  yoteiTavleViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/19.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class yoteiTableViewController: UIViewController{

    @IBOutlet weak var yoteiTableView: UITableView!
    var tableView: UITableView!
//    @IBOutlet weak var scrollView: UIScrollView! {
//        didSet{
//            scrollView.delegate = self
//        }
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("スクロール中です。")
//    }
    
    var Item: Results<Event>!
    var items = [Event]()
    override func viewDidLoad() {
        super.viewDidLoad()
        yoteiTableView.delegate = self
        yoteiTableView.dataSource = self
        yoteiTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        yoteiTableView.tableFooterView = UIView()
    }
}

extension yoteiTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        let memo = items[indexPath.row]
        cell.setUpPlanCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
//        print("memo.content: \(memo.content)")
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
                print("削除")
                realm.delete(items[indexPath.row])
                items.remove(at: indexPath.row)
                self.yoteiTableView.reloadData()
            }
        }
    }
}

