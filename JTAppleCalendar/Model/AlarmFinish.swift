//
//  AlarmFinish.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/25.
//  Copyright © 2020 com.litech. All rights reserved.
//

import AVFoundation
import UIKit

class AlarmFinish{
    
    var selectedFinishTime:Date?
    var audioPlayer: AVAudioPlayer!
    var sleepTimer: Timer?
    var seconds = 0
    
    func runTimer(){
        seconds = calculateInterval(userFinishTime: selectedFinishTime!)
        guard sleepTimer == nil else { return }
        if sleepTimer == nil{
            sleepTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimer(){
        if seconds != 0{
            seconds -= 1
            
            print(seconds)
        }else{
            sleepTimer?.invalidate()
            sleepTimer = nil
            let content = UNMutableNotificationContent()
            content.title = "勉強を終了する時間です。"
            content.body = ""
            content.sound = UNNotificationSound.default

            // 直ぐに通知を表示
            let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func stopTimer(){
        if sleepTimer != nil {
            sleepTimer!.invalidate()
            sleepTimer = nil
        }
    }
    
    private func calculateInterval(userFinishTime:Date)-> Int{
        var interval = Int(userFinishTime.timeIntervalSinceNow)
        if interval < 0{
            interval = 86400 - (0 - interval)
        }
        let calendar =  Calendar.current
        let seconds = calendar.component(.second, from: userFinishTime)
        return interval - seconds
    }
}
