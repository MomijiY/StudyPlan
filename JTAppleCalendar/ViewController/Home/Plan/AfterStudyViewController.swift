//
//  AfterStudyViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/08/08.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift

class AfterStudyViewController: UITableViewController {
    
    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    let starImage = UIImage(named: "star")
    let starFillImage = UIImage(named: "starFill")
    var count: Int = 0
    var starCount: Int = 0
    var items = AfterEvent()
    override func viewDidLoad() {
        super.viewDidLoad()
        star1.setBackgroundImage(starImage, for: .normal)
        star2.setBackgroundImage(starImage, for: .normal)
        star3.setBackgroundImage(starImage, for: .normal)
        star4.setBackgroundImage(starImage, for: .normal)
        star5.setBackgroundImage(starImage, for: .normal)
        
        time1Label.text = UserDefaults.standard.object(forKey: "time1") as? String
        time2Label.text = UserDefaults.standard.object(forKey: "time2") as? String
        subjectLabel.text = UserDefaults.standard.object(forKey: "subject") as? String
        contentLabel.text = UserDefaults.standard.object(forKey: "content") as? String
        
        count = 0
        starCount = 0
        
        time1Label.isHidden = false
        time2Label.isHidden = false
        
        star1.isHidden = false
        star2.isHidden = false
        star3.isHidden = false
        star4.isHidden = false
        star5.isHidden = false
        contentTextView.isHidden = false
        
        subjectLabel.isHidden = true
        contentLabel.isHidden = true
        
        
        tableView.register(UINib(nibName: "AfterStudyTableViewCell", bundle: nil), forCellReuseIdentifier: "contentCell")
    }
    
    @IBAction func tappedStar1(_ sender: UIButton) {
        star1.setBackgroundImage(starFillImage, for: .normal)
        star2.setBackgroundImage(starImage, for: .normal)
        star3.setBackgroundImage(starImage, for: .normal)
        star4.setBackgroundImage(starImage, for: .normal)
        star5.setBackgroundImage(starImage, for: .normal)
        starCount = 1
    }
    
    @IBAction func tappedStar2(_ sender: UIButton) {
        star1.setBackgroundImage(starFillImage, for: .normal)
        star2.setBackgroundImage(starFillImage, for: .normal)
        star3.setBackgroundImage(starImage, for: .normal)
        star4.setBackgroundImage(starImage, for: .normal)
        star5.setBackgroundImage(starImage, for: .normal)
        starCount = 2
    }
    
    @IBAction func tappedStar3(_ sender: UIButton) {
        star1.setBackgroundImage(starFillImage, for: .normal)
        star2.setBackgroundImage(starFillImage, for: .normal)
        star3.setBackgroundImage(starFillImage, for: .normal)
        star4.setBackgroundImage(starImage, for: .normal)
        star5.setBackgroundImage(starImage, for: .normal)
        starCount = 3
    }
    
    @IBAction func tappedStar4(_ sender: UIButton) {
        star1.setBackgroundImage(starFillImage, for: .normal)
        star2.setBackgroundImage(starFillImage, for: .normal)
        star3.setBackgroundImage(starFillImage, for: .normal)
        star4.setBackgroundImage(starFillImage, for: .normal)
        star5.setBackgroundImage(starImage, for: .normal)
        starCount = 4
    }
    
    @IBAction func tappedStar5(_ sender: UIButton) {
        star1.setBackgroundImage(starFillImage, for: .normal)
        star2.setBackgroundImage(starFillImage, for: .normal)
        star3.setBackgroundImage(starFillImage, for: .normal)
        star4.setBackgroundImage(starFillImage, for: .normal)
        star5.setBackgroundImage(starFillImage, for: .normal)
        starCount = 5
    }
    
    @IBAction func tappedChangeButton(_ sender: UIBarButtonItem) {
        count += 1
        if count % 2 == 0 {
            time1Label.isHidden = false
            time2Label.isHidden = false
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            star4.isHidden = false
            star5.isHidden = false
            contentTextView.isHidden = false
            
            subjectLabel.isHidden = true
            contentLabel.isHidden = true
        } else {
            time1Label.isHidden = false
            time2Label.isHidden = false
            
            star1.isHidden = true
            star2.isHidden = true
            star3.isHidden = true
            star4.isHidden = true
            star5.isHidden = true
            contentTextView.isHidden = true
            
            subjectLabel.isHidden = false
            contentLabel.isHidden = false
        }
    }
    
    @IBAction func tappedSaveButton(_ sender: UIButton) {
        count = 0
        items.time1 = time1Label.text!
        items.time2 = time2Label.text!
        items.star = starCount
        items.content = contentTextView.text!
        
        let realm = try! Realm()
        try! realm.write{
            let events = [AfterEvent(value: ["time1": items.time1,
                                             "time2": items.time2,
                                             "star": items.star,
                                             "content": items.content])]
            realm.add(events)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
