//
//  Alarm.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/24.
//  Copyright © 2020 com.litech. All rights reserved.
//


import UIKit
import UserNotifications

class Alarm{
    
    var selectedBeginStudyTime:Date?
    var studyTimer: Timer?
    var seconds = 0
    
    func runTimer(){
        seconds = calculateInterval(userAwakeTime: selectedBeginStudyTime!)
        guard studyTimer == nil else { return }
        if studyTimer == nil{
            studyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimer(){
        if seconds > 0{
            seconds -= 1
            
            print(seconds)
        }else{
            stopTimer()
            let content = UNMutableNotificationContent()
            content.title = "勉強を始める時間です。"
            content.body = "勉強を始めましょう！"
            content.sound = UNNotificationSound.default
            // 直ぐに通知を表示
            let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//            ViewController().dismiss(animated: true, completion: nil)
            print("勉強を開始")
        }
    }
    
    func stopTimer(){
        if studyTimer != nil {
            studyTimer!.invalidate()
            studyTimer = nil
        }
    }
    func stopNotification() {
        if studyTimer != nil {
            print("studyTimer != nil")
            studyTimer!.invalidate()
            studyTimer = nil
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["immediately"])
        } else {
            studyTimer = nil
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["immediately"])
        }
    }
    
    private func calculateInterval(userAwakeTime:Date)-> Int{
        var interval = Int(userAwakeTime.timeIntervalSinceNow)
        if interval < 0{
            interval = 86400 - (0 - interval)
        }
        let calendar =  Calendar.current
        let seconds = calendar.component(.second, from: userAwakeTime)
        return interval - seconds
    }
}
