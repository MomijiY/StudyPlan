//
//  HomeViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class HomeViewController: UITableViewController,FSCalendarDataSource,FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var yoteiTableView: UITableView!
    
    var Item: Results<Event>!
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        yoteiTableView.delegate = self
        yoteiTableView.dataSource = self
        yoteiTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        do{
            let realm = try Realm()
            Item = realm.objects(Event.self)
        }catch{
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        yoteiTableView.reloadData()
    }

}

extension HomeViewController {
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        Item.count
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = yoteiTableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
//        let memo = Item[indexPath.row]
//        cell.setUpPlanCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.contetnt)
//        return cell
//    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if(editingStyle == UITableViewCell.EditingStyle.delete) {
//            // Realm内のデータを削除
//            do{
//                let realm = try Realm()
//                try realm.write {
//                    realm.delete(self.Item[indexPath.row])
//                }
//                yoteiTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
//            }catch{
//            }
//        }
//    }
}
