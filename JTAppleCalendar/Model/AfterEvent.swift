//
//  AfterEvent.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/08/10.
//  Copyright © 2020 com.litech. All rights reserved.
//

import Foundation
import RealmSwift

class AfterEvent: Object {

    @objc dynamic var time1: String = ""
    @objc dynamic var time2: String = ""
    @objc dynamic var star = Int()
    @objc dynamic var content: String = ""
    @objc dynamic var date = String()
}
