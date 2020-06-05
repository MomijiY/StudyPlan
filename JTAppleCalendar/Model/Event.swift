//
//  Event.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object {

    @objc dynamic var time1: String = ""
    @objc dynamic var time2: String = ""
    @objc dynamic var subject: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var date = String()
}
