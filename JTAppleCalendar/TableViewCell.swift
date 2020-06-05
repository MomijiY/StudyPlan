//
//  TableViewCell.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var timeOneLabel: UILabel!
    @IBOutlet private weak var timeTwoLabel: UILabel!
    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // MARK: Static properties
    
    static let reuseIdentifier = "TableViewCell"
    static let rowHeight: CGFloat = 100
    
    static var nib: UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    func setUpPlanCell(timeOne: String, timeTwo: String, subject: String, content: String) {
        timeOneLabel.text = timeOne
        timeTwoLabel.text = timeTwo
        subjectLabel.text = subject
        contentLabel.text = content
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
