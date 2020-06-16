//
//  AddPlanViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class AddPlanViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var timeOneTextField: UITextField!
    @IBOutlet weak var timeTwoTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
//    @IBOutlet weak var navItem: UINavigationItem!
    
    //インスタンスを生成
    let alarm = Alarm()
    let fishishAlarm = FinishAlarm()
    
    var userdefdate = UserDefaults.standard.object(forKey: "date") as! String
    var items = Event()
    var alertController: UIAlertController!
    var timePicker: UIDatePicker = UIDatePicker()
    var timePicker2: UIDatePicker = UIDatePicker()
    var request:UNNotificationRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        
//        navItem.title = userdefdate
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0/255, green: 84/255, blue: 147/255, alpha: 1.0)
        ]
        items = Event()
        
        subjectTextField.delegate = self
        //picker
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.timeZone = NSTimeZone.local
        timePicker.locale = Locale.current
        timeOneTextField.inputView = timePicker
        
        timePicker2.datePickerMode = UIDatePicker.Mode.time
        timePicker2.timeZone = NSTimeZone.local
        timePicker2.locale = Locale.current
        timeTwoTextField.inputView = timePicker2
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)

        let toolbar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        toolbar2.setItems([spacelItem2, doneItem2], animated: true)
        
        let toolbar3 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done3))
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
        if timeOneTextField.text != "" && timeTwoTextField.text != "" {
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
            //AlarmにあるselectedWakeUpTimeにユーザーの入力した日付を代入
            alarm.selectedBeginStudyTime = timePicker.date
            fishishAlarm.selectedFinishStudyTime = timePicker2.date
            //AlarmのrunTimerを呼ぶ
            alarm.runTimer()
            fishishAlarm.runTimer()
            // 画面を閉じる
//            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func done() {
        timeOneTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeOneTextField.text = "\(formatter.string(from: timePicker.date))"
    }
    
    @objc func done2() {
        timeTwoTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeTwoTextField.text = "\(formatter.string(from: timePicker2.date))"
    }

    @objc func done3() {
        contentTextView.endEditing(true)
    }
    
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        present(alertController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        subjectTextField.resignFirstResponder()
        
        return true
    }
}
