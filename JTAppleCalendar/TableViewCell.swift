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
        
        let attriStrTimeOne: NSMutableAttributedString = NSMutableAttributedString(string: timeOne)
        attriStrTimeOne.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 0,
                                     range: NSMakeRange(0, attriStrTimeOne.length))
        
        let attriStrTimeTwo: NSMutableAttributedString = NSMutableAttributedString(string: timeTwo)
        attriStrTimeTwo.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 0,
                                     range: NSMakeRange(0, attriStrTimeTwo.length))
        
        let attriStrSubject: NSMutableAttributedString = NSMutableAttributedString(string: subject)
        attriStrSubject.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 0,
                                     range: NSMakeRange(0, attriStrSubject.length))
        
        let attriStrContent: NSMutableAttributedString = NSMutableAttributedString(string: content)
        attriStrContent.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 0,
                                     range: NSMakeRange(0, attriStrContent.length))
        
        timeOneLabel.attributedText = attriStrTimeOne
        timeTwoLabel.attributedText = attriStrTimeTwo
        subjectLabel.attributedText = attriStrSubject
        contentLabel.attributedText = attriStrContent
    }
    
    func setUpAccessaryCell(timeOne: String, timeTwo: String, subject: String, content: String) {
        timeOneLabel.text = timeOne
        timeTwoLabel.text = timeTwo
        subjectLabel.text = subject
        contentLabel.text = content
        
        let attriStrTimeOne: NSMutableAttributedString = NSMutableAttributedString(string: timeOne)
        attriStrTimeOne.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 2,
                                     range: NSMakeRange(0, attriStrTimeOne.length))
        
        let attriStrTimeTwo: NSMutableAttributedString = NSMutableAttributedString(string: timeTwo)
        attriStrTimeTwo.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 2,
                                     range: NSMakeRange(0, attriStrTimeTwo.length))
        
        let attriStrSubject: NSMutableAttributedString = NSMutableAttributedString(string: subject)
        attriStrSubject.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 2,
                                     range: NSMakeRange(0, attriStrSubject.length))
        
        let attriStrContent: NSMutableAttributedString = NSMutableAttributedString(string: content)
        attriStrContent.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 2,
                                     range: NSMakeRange(0, attriStrContent.length))
        
        timeOneLabel.attributedText = attriStrTimeOne
        timeTwoLabel.attributedText = attriStrTimeTwo
        subjectLabel.attributedText = attriStrSubject
        contentLabel.attributedText = attriStrContent
        
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

extension UIView {
   var allSubviews: [UIView] {
      return subviews.flatMap { [$0] + $0.allSubviews }
   }
}
