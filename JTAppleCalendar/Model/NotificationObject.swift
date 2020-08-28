//
//  NotificationObject.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/08/15.
//  Copyright © 2020 com.litech. All rights reserved.
//

import Foundation
import RealmSwift

class NotificationObject: Object {
    @objc dynamic var content: String = ""
    @objc dynamic var finishContent: String = ""
}
