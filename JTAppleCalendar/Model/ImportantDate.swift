//
//  ImportantDate.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/10/02.
//  Copyright © 2020 com.litech. All rights reserved.
//

import Foundation
import RealmSwift

class ImportantDate: Object {

    @objc dynamic var title: String = ""
    @objc dynamic var dateDescription: String = ""
    @objc dynamic var date = String()
    @objc dynamic var pin: Bool = false
}
