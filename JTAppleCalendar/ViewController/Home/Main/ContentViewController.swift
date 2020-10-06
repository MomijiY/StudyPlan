//
//  ContentViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/07/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift

class ContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    var sectionName = ["大事な日", "勉強計画"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.backgroundColor = UIColor(hex: "FFFAFA", alpha: 1.0)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return ViewController().items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        let selectionview = UIView()
        selectionview.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.2)
        cell.selectedBackgroundView = selectionview
        let memo = ViewController().items[indexPath.row]
        cell.setUpPlanCell(timeOne: memo.time1, timeTwo: memo.time2, subject: memo.subject, content: memo.content)
        return cell
     }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
    }
}
