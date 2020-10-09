//
//  SectionHeaderView.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/10/06.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!

    func setup(titleText: String) {
        titleLabel.text = titleText
    }

}
