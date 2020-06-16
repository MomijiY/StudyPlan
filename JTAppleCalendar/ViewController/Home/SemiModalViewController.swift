//
//  SemiModalViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/06/13.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift
class SemiModalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellHeight: CGFloat = 100
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var items = [Event]()
    var currentTime = CurrentTime()
    var currentTimeFinish = FinishCurrentTime()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
//        items = [Event]()
//        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
//        tableView.tableFooterView = UIView()
//        tableView.separatorColor = .white
    }
}
