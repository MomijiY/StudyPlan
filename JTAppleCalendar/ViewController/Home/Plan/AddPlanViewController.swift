//
//  AddPlanViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift
import os

class AddPlanViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var timeOneTextField: UITextField!
    @IBOutlet weak var timeTwoTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
//    @IBOutlet weak var navItem: UINavigationItem!
    
    //インスタンスを生成
//    let alarm = Alarm()
//    let fishishAlarm = FinishAlarm()
    
    let identifier = UUID().uuidString
    let finishIdentifier = UUID().uuidString
    
    var userdefdate = UserDefaults.standard.object(forKey: "date") as! String
    var items = Event()
    var alertController: UIAlertController!
    var timePicker: UIDatePicker = UIDatePicker()
    var timePicker2: UIDatePicker = UIDatePicker()
    var request:UNNotificationRequest!
    var finishRequest: UNNotificationRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeOneTextField.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        timeTwoTextField.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        subjectTextField.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        contentTextView.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0/255, green: 84/255, blue: 147/255, alpha: 1.0)
        ]
        items = Event()
        
        subjectTextField.delegate = self
        //picker
        timePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        timePicker.timeZone = NSTimeZone.local
        timePicker.locale = Locale.current
        timePicker.date = DateUtils.dateFromString(string: userdefdate, format: "yyyy/MM/dd")
        timePicker2.addTarget(self, action: #selector(doneDatePicker2(datePicker2:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(doneDatePicker(datePicker:)), for: .valueChanged)
        timeOneTextField.inputView = timePicker
        
        timePicker2.datePickerMode = UIDatePicker.Mode.dateAndTime
        timePicker2.timeZone = NSTimeZone.local
        timePicker2.locale = Locale.current
        timePicker2.date = timePicker.date
        timeTwoTextField.inputView = timePicker2
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        spacelItem.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        doneItem.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        toolbar.setItems([spacelItem, doneItem], animated: true)

        let toolbar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        spacelItem2.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        let doneItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        doneItem2.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        toolbar2.setItems([spacelItem2, doneItem2], animated: true)
        
        let toolbar3 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        spacelItem3.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        let doneItem3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done3))
        doneItem3.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        toolbar3.setItems([spacelItem3, doneItem3], animated: true)
        
        timeOneTextField.inputView = timePicker
        timeTwoTextField.inputView = timePicker2
        timeOneTextField.inputAccessoryView = toolbar
        timeTwoTextField.inputAccessoryView = toolbar2
        contentTextView.inputAccessoryView = toolbar3
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if timeOneTextField.text == "" {
            alert(title: "空欄があります。", message: "勉強を始める時間を入力してください。")
        }
        if timeTwoTextField.text == "" {
            alert(title: "空欄があります。", message: "勉強を終了する時間を入力してください。")
        }
        if timePicker.date <= Date() {
            alert(title: "今と同じ又は過去の時間を設定することはできません。", message: "今より前の時間を選んでください。")
        }
        if timePicker.date >= timePicker2.date {
            alert(title: "勉強を終了する時間を勉強を始める時間より前に設定することはできません。", message: "勉強を終了する時間を勉強を始める時間より後の時間に設定するようにしてください。")
        }
        if timeOneTextField.text != "" && timeTwoTextField.text != "" && timePicker.date > Date() && timePicker.date < timePicker2.date {
            items.time1 = timeOneTextField.text!
            items.time2 = timeTwoTextField.text!
            items.subject = subjectTextField.text!
            items.content = contentTextView.text!
            print("\(items.content), \(contentTextView.text!)")
            let realm = try! Realm()
            try! realm.write{
                let events = [Event(value: ["time1": items.time1,
                                            "time2": items.time2,
                                            "subject": items.subject,
                                            "content": contentTextView.text!,
                                            "date": userdefdate])]
                UserDefaults.standard.set(items.time1, forKey: "time1")
                UserDefaults.standard.set(items.time2, forKey: "time2")
                UserDefaults.standard.set(items.subject, forKey: "subject")
                UserDefaults.standard.set(items.content, forKey: "content")
                realm.add(events)
                print("書き込み中")
                print(events)
            }
            
            os_log("setButton")
                   
            // 日付フォーマット
//            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .medium
            dateFormatter.locale = Locale(identifier: "ja_JP")
                   
            let otherDate1 = timePicker.date
            print("otherDate1: \(otherDate1)")
            let targetDate = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: otherDate1)
            print("ターゲットは\(targetDate)")
                               
            // トリガーの作成
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: targetDate, repeats: false)
                               
            // 通知コンテンツの作成
            let content = UNMutableNotificationContent()
            content.title = "勉強を始める時間です。"
            content.body = dateFormatter.string(from: otherDate1)
            content.sound = UNNotificationSound.default
                               
            
            // 通知リクエストの作成
            request = UNNotificationRequest.init(
                    identifier: identifier,
                    content: content,
                    trigger: trigger)
            UserDefaults.standard.set(identifier, forKey: "identifier")
                        
            // 通知リクエストの登録
            let center = UNUserNotificationCenter.current()
            center.add(request)
                        
            let otherDate2 = timePicker2.date
                        
            print("otherDate2: \(otherDate2)")
            let FinishtargetDate = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: otherDate2)
                               
            // トリガーの作成
            let Finisgtrigger = UNCalendarNotificationTrigger.init(dateMatching: FinishtargetDate, repeats: false)
                               
            // 通知コンテンツの作成
            let Finishcontent = UNMutableNotificationContent()
            Finishcontent.title = "勉強を終了する時間です。"
            Finishcontent.body = dateFormatter.string(from: otherDate2)
            Finishcontent.sound = UNNotificationSound.default
            
            
            // 通知リクエストの作成
            finishRequest = UNNotificationRequest.init(
                    identifier: finishIdentifier,
                    content: Finishcontent,
                    trigger: Finisgtrigger)
            UserDefaults.standard.set(finishIdentifier, forKey: "finishIdentifier")
            print(identifier)
            print(finishIdentifier)
            center.add(finishRequest)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func done() {
        timeOneTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "\(userdefdate) HH:mm"
        timeOneTextField.text = "\(formatter.string(from: timePicker.date))"
    }
    
    @objc func done2() {
        timeTwoTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "\(userdefdate) HH:mm"
        timeTwoTextField.text = "\(formatter.string(from: timePicker2.date))"
    }
    
    @objc func doneDatePicker(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "\(userdefdate) HH:mm"
        timeOneTextField.text = "\(formatter.string(from: timePicker.date))"
        timeTwoTextField.text = "\(formatter.string(from: timePicker.date))"
//        timePicker.date = timePicker2.date
    }
    
    @objc func doneDatePicker2(datePicker2: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "\(userdefdate) HH:mm"
        timeTwoTextField.text = "\(formatter.string(from: timePicker2.date))"
    }

    @objc func done3() {
        contentTextView.endEditing(true)
    }
    
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        subjectTextField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        timePicker.date = timePicker2.date
    }
}
