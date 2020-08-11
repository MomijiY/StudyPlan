//
//  AfterStudyCell.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/08/10.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class AfterStudyCell: UITableViewCell {
    
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var timeOneLabel: UILabel!
    @IBOutlet private weak var timeTwoLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // MARK: Static properties
    
    static let reuseIdentifier = "AfterStudyCell"
    static let rowHeight: CGFloat = 100
    
    static var nib: UINib {
        return UINib(nibName: "AfterStudyCell", bundle: nil)
    }
    
    func setUpPlanCell(timeOne: String, timeTwo: String, star: Int, content: String) {
        let StrStar = String(star)
        timeOneLabel.text = timeOne
        timeTwoLabel.text = timeTwo
        starLabel.text = StrStar
        contentLabel.text = content
        
        let attriStrTimeOne: NSMutableAttributedString = NSMutableAttributedString(string: timeOne)
        attriStrTimeOne.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 0,
                                     range: NSMakeRange(0, attriStrTimeOne.length))
        
        let attriStrTimeTwo: NSMutableAttributedString = NSMutableAttributedString(string: timeTwo)
        attriStrTimeTwo.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 0,
                                     range: NSMakeRange(0, attriStrTimeTwo.length))
        
        let attriStrSubject: NSMutableAttributedString = NSMutableAttributedString(string: StrStar)
        attriStrSubject.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 0,
                                     range: NSMakeRange(0, attriStrSubject.length))
        
        let attriStrContent: NSMutableAttributedString = NSMutableAttributedString(string: content)
        attriStrContent.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 0,
                                     range: NSMakeRange(0, attriStrContent.length))
        
        timeOneLabel.attributedText = attriStrTimeOne
        timeTwoLabel.attributedText = attriStrTimeTwo
        starLabel.attributedText = attriStrSubject
        contentLabel.attributedText = attriStrContent
        
        self.backgroundColor = .clear
    }
    
    func setUpAccessaryCell(timeOne: String, timeTwo: String, star: Int, content: String) {
        let StrStar = String(star)
        timeOneLabel.text = timeOne
        timeTwoLabel.text = timeTwo
        starLabel.text = StrStar
        contentLabel.text = content
        
        self.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.2)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func commonInit() {

    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if let indicatorButton = allSubviews.compactMap({ $0 as? UIButton }).last {
            let image = indicatorButton.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
            indicatorButton.setBackgroundImage(image, for: .normal)
            indicatorButton.tintColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
         }
      }
    
}
