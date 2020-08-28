//
//  ImportantDayTableViewCell.swift
//  JTAppleCalendar
// ImportantDayTableViewCell
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class ImportantDayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    
    static let reuseIdentifier = "ImportantDayTableViewCell"
    static let rowHeight: CGFloat = 100
    static var nib: UINib {
        return UINib(nibName: "ImportantDayTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupCell(title: String, content: String, date: String, pin: Bool) {
        titleLabel.text = title
        descriptionLabel.text = content
        dateLabel.text = date
        pinImage.isHidden = pin
        ImportantDayTableViewCell().makeUp()
    }
    
    fileprivate func commonInit() {

    }

    
}
