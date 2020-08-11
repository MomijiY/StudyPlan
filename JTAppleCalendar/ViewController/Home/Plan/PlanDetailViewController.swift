//
//  PlanDetailViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/18.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class PlanDetailViewController: UITableViewController {

    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        
        time1Label.text = UserDefaults.standard.object(forKey: "time1") as? String
        time2Label.text = UserDefaults.standard.object(forKey: "time2") as? String
        subjectLabel.text = UserDefaults.standard.object(forKey: "subject") as? String
        contentLabel.text = UserDefaults.standard.object(forKey: "content") as? String
        
        tableView.estimatedRowHeight = 263
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
