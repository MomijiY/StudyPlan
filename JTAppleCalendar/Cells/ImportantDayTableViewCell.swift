//
//  ImportantDayTableViewCell.swift
//  JTAppleCalendar
// ImportantDayTableViewCell
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class ImportantDayTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
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
        ImportantDayTableViewCell().makeUp()
    }
    
    fileprivate func commonInit() {

    }

//    open override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if let indicatorButton = allSubviews.compactMap({ $0 as? UIButton }).last {
//            let image = indicatorButton.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
//            indicatorButton.setBackgroundImage(image, for: .normal)
//            indicatorButton.tintColor = .white
//        }
//    }
    
    func layoutIndicatorButtonAccesory() {
        if let indicatorButton = allSubviews.compactMap({ $0 as? UIButton }).last {
            let image = indicatorButton.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
            indicatorButton.setBackgroundImage(image, for: .normal)
            indicatorButton.tintColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        }
    }
    
    func layoutIndicatorButtonNormal() {
        if let indicatorButton = allSubviews.compactMap({ $0 as? UIButton }).last {
            let image = indicatorButton.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
            indicatorButton.setBackgroundImage(image, for: .normal)
            indicatorButton.tintColor = UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 1.0)
        }
    }
    
}
