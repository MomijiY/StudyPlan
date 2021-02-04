//
//  PlanDetailViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/18.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift
import os

class PlanDetailViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var timeOneTextField: UITextField!
    @IBOutlet weak var timeTwoTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var items = Event()
    let realm = try! Realm()
    var timePicker: UIDatePicker = UIDatePicker()
    var timePicker2: UIDatePicker = UIDatePicker()
    var userdefdate = UserDefaults.standard.object(forKey: "date") as! String
    var alertController: UIAlertController!
    var deleteBool = Bool()
    
    let identifier = UserDefaults.standard.object(forKey: "identifier") as! String
    let finishIdentifier = UserDefaults.standard.object(forKey: "finishIdentifier") as! String
    
    let content = UNMutableNotificationContent()
    let Finishcontent = UNMutableNotificationContent()
    
    var request:UNNotificationRequest!
    var finishRequest: UNNotificationRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
//        showUdfText()
        
        tableView.estimatedRowHeight = 263
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNeedsStatusBarAppearanceUpdate()
        setUpFirst()
        tableView.estimatedRowHeight = 263
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func tappedSaveButton(_ sender: UIButton) {
        try! realm.write {
            let memo = items
            print("identifier: \(memo.identifier)")
            print("finishIdentifier: \(memo.finishIdentifier)")
            UserDefaults.standard.set(identifier, forKey: "fromDetailIdentifer")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [finishIdentifier])
            realm.delete(realm.objects(Event.self).filter("identifier=%@",identifier))
            print("削除")
        }
        if timeOneTextField.text == "" {
            alert(title: "空欄があります。", message: "勉強を始める時間を入力してください。")
        }
        if timeTwoTextField.text == "" {
            alert(title: "空欄があります。", message: "勉強を終了する時間を入力してください。")
        }
        if timePicker.date <= Date() {
            alert(title: "今と同じ又は過去の時間を設定することはできません。", message: "今より前の時間を選んでください。")
        }
        if timePicker.date > timePicker2.date {
            alert(title: "勉強を終了する時間を勉強を始める時間より前に設定することはできません。", message: "勉強を終了する時間を勉強を始める時間より後の時間に設定するようにしてください。")
        }
        if timeOneTextField.text == timeTwoTextField.text {
            alert(title: "勉強を終了する時間を始める時間と同じ時間に設定することはできません。", message: "勉強を終了する時間を勉強を始める時間より後の時間に設定するようにしてください。")
        }
        if timeOneTextField.text != "" && timeTwoTextField.text != "" && timePicker.date > Date() && timePicker.date < timePicker2.date {
            UserDefaults.standard.set(true, forKey: "delete")
            items.time1 = timeOneTextField.text!
            items.time2 = timeTwoTextField.text!
            items.subject = subjectTextField.text!
            items.content = contentTextView.text!
            items.identifier = identifier
            items.finishIdentifier = finishIdentifier
            print("\(items.content), \(contentTextView.text!)")
            let realm = try! Realm()
            try! realm.write{
                let events = [Event(value: ["time1": items.time1,
                                            "time2": items.time2,
                                            "subject": items.subject,
                                            "content": contentTextView.text!,
                                            "date": userdefdate,
                                            "identifier": identifier,
                                            "finishIdentifier": finishIdentifier])]
                UserDefaults.standard.set(items.time1, forKey: "time1")
                UserDefaults.standard.set(items.time2, forKey: "time2")
                UserDefaults.standard.set(items.subject, forKey: "subject")
                UserDefaults.standard.set(items.content, forKey: "content")
                
                let formatter = DateFormatter()
                var time2Formatter = formatter.dateFormat
                time2Formatter = "\(userdefdate)"
                UserDefaults.standard.set(time2Formatter, forKey: "time2Formatter")
                realm.add(events)
                print("書き込み中")
                print(events)
            }
            
            os_log("setButton")
            
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
            
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: targetDate, repeats: false)
            
            content.title = "勉強を始める時間です。"
            content.body = dateFormatter.string(from: otherDate1)
            content.sound = UNNotificationSound.default
            request = UNNotificationRequest.init(
                    identifier: identifier,
                    content: content,
                    trigger: trigger)
            UserDefaults.standard.set(identifier, forKey: "identifier")
            UserDefaults.standard.set(content.title, forKey: "notiContent")
            let center = UNUserNotificationCenter.current()
            center.add(request)
                        
            let otherDate2 = timePicker2.date
                        
            print("otherDate2: \(otherDate2)")
            let FinishtargetDate = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: otherDate2)
            let Finisgtrigger = UNCalendarNotificationTrigger.init(dateMatching: FinishtargetDate, repeats: false)
            Finishcontent.title = "勉強を終了する時間です。"
            Finishcontent.body = dateFormatter.string(from: otherDate2)
            Finishcontent.sound = UNNotificationSound.default
            
            finishRequest = UNNotificationRequest.init(
                    identifier: finishIdentifier,
                    content: Finishcontent,
                    trigger: Finisgtrigger)
            UserDefaults.standard.set(finishIdentifier, forKey: "finishIdentifier")
            UserDefaults.standard.set(content.title, forKey: "finishNotiContent")
            print("identifier: \(items.identifier)")
            print("finishIdentifier: \(items.finishIdentifier)")
            center.add(finishRequest)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setUpFirst() {
        timeOneTextField.delegate = self
        timeTwoTextField.delegate = self
        subjectTextField.delegate = self
        contentTextView.delegate = self
        
        timeOneTextField.text = UserDefaults.standard.object(forKey: "time1") as? String
        timeTwoTextField.text = UserDefaults.standard.object(forKey: "time2") as? String
        subjectTextField.text = UserDefaults.standard.object(forKey: "subject") as? String
        contentTextView.text = UserDefaults.standard.object(forKey: "content") as? String
        
        
//        timeOneTextField.becomeFirstResponder()
        timeOneTextField.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        timeTwoTextField.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        subjectTextField.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        contentTextView.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0/255, green: 84/255, blue: 147/255, alpha: 1.0)
        ]
        items = Event()
        
        subjectTextField.delegate = self
        
        timePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        timePicker.timeZone = NSTimeZone.local
        timePicker.locale = Locale.current
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
            timePicker2.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
//        if userdefdate == UserDefaults.standard.object(forKey: "time2Formatter") as? String{
//            timeOneTextField.text = UserDefaults.standard.object(forKey: "time2") as? String
//            timePicker.date = DateUtils.dateFromString(string: timeOneTextField.text!, format: "yyyy/M/d HH:mm")
//        } else {
//            timeOneTextField.text = ""
//            timePicker.date = DateUtils.dateFromString(string: userdefdate, format: "yyyy/MM/dd")
//        }
    //        timePicker.date = DateUtils.dateFromString(string: userdefdate, format: "yyyy/MM/dd")
        timePicker2.addTarget(self, action: #selector(doneDatePicker2(datePicker2:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(doneDatePicker(datePicker:)), for: .valueChanged)
        timeOneTextField.inputView = timePicker
        
        timePicker2.datePickerMode = UIDatePicker.Mode.dateAndTime
        timePicker2.timeZone = NSTimeZone.local
        timePicker2.locale = Locale.current
        timePicker2.date = timePicker.date
        timeTwoTextField.inputView = timePicker2
        
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
        if timeTwoTextField.text == "" {
            let timeTwoTextDate = DateUtils.dateFromString(string: timeOneTextField.text!, format: "yyyy/M/d HH:mm")
            timePicker2.date = timeTwoTextDate
        } else if timeTwoTextField.text == timeOneTextField.text{
            let timeTwoTextDate = DateUtils.dateFromString(string: timeOneTextField.text!, format: "yyyy/M/d HH:mm")
            timePicker2.date = timeTwoTextDate
        } else {
            print("none")
        }
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
}
