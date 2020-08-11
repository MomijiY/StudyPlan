//
//  AddPlan.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import Foundation

struct AddPlan: Codable{
    let timeOne: String
    let timeTwo: String
    let subject: String
    let content: String
    let date: String
    let identifier: String
    let finishIdentifier: String
}
