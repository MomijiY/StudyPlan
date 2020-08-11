//
//  AfterStudyTableViewCell.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/08/08.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class AfterStudyTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    func setUp(content: String) {
        contentLabel.text = UserDefaults.standard.object(forKey: "content") as? String
    }
    
}
