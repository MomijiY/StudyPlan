//
//  CustomFloatingPanel.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/07/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import FloatingPanel

class CustomFloatingPanel:  FloatingPanelLayout{
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            ViewController().weekCalendar.scope = .week
            return 16.0
        case .half:
            ViewController().weekCalendar.scope = .week
            return 400.0
        case .tip:
            ViewController().weekCalendar.scope = .month
            return 216.0
        default: return nil
        }
    }
    
    var supportedPositions: Set<FloatingPanelPosition> {
        return[.full, .half, .tip]
    }
}
