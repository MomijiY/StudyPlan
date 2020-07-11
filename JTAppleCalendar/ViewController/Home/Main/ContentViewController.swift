//
//  ContentViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/07/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift

class ContentViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.backgroundColor = UIColor(red: 172/255, green: 208/255, blue: 191/255, alpha: 1.0)
//        tableView.backgroundColor = UIColor(hex: "E8D454", alpha: 0.5)
        return tableView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
   }
}
extension ContentViewController: UITableViewDataSource, UITableViewDelegate {
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
}
