//
//  StudyingTableViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/06/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class StudyingTableViewController: UITableViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var alertController: UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = UserDefaults.standard.object(forKey: "time2") as? String
        subjectLabel.text = UserDefaults.standard.object(forKey: "subject") as? String
        contentLabel.text = UserDefaults.standard.object(forKey: "content") as? String
    }

    @IBAction func stopStudy(_ sender: UIBarButtonItem) {
        alert(title: "勉強を終了しますか？", message: "")
    }
    
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "cancel",
                                                       style: .cancel,
                                                       handler: nil))
        alertController.addAction(UIAlertAction(title: "OK",style: .destructive,
                                       handler: {(action: UIAlertAction!) in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                         // 0.5秒後に実行したい処理
                                          self.performSegue(withIdentifier: "toHome", sender: nil)
                                         }
                                        }
                                        ))
        present(alertController, animated: true)
    }
}
