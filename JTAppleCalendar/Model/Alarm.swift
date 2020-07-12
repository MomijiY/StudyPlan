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
    let id = "immediately"
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
            let request = UNNotificationRequest(identifier: id, content: content, trigger: nil)
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
    //通知を削除する関数———ViewController.swiftの332行目で呼び出している。
    func stopNotification() {
        print(#function)
        studyTimer!.invalidate()
        studyTimer = nil

        // requestのIDで絞って消す
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiers = requests
                .filter { $0.identifier == self.id}
                .map { $0.identifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
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
