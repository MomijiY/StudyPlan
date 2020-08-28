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
            return 16.0
        case .half:
            return 400.0
        case .tip:
            return 210.0
        default: return nil
        }
    }
    
    var supportedPositions: Set<FloatingPanelPosition> {
        return[.full, .half, .tip]
    }
}
