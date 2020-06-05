//
//  ImportantDayTableViewCell.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class ImportantDayTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: Static properties
    
    static let reuseIdentifier = "ImportantDayTableViewCell"
    static let rowHeight: CGFloat = 100
    static var nib: UINib {
        return UINib(nibName: "ImportantDayTableViewCell", bundle: nil)
    }

    // MARK: Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Setup
    
    func setupCell(title: String, content: String, date: String, pin: Bool) {
        titleLabel.text = title
        descriptionLabel.text = content
        dateLabel.text = date
    }
}
