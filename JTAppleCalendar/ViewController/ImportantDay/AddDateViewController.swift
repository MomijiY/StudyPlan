//
//  AddDateViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import os

class AddDateViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var top: UISwitch!
    var pin = true
    var isPicker = false
    
    private let model = UserDefaultsModel()
    let identifier = UUID().uuidString
    let content = UNMutableNotificationContent()
    var request:UNNotificationRequest!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.becomeFirstResponder()
        self.setNeedsStatusBarAppearanceUpdate()
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "datecell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pincell")
        tableView.tableFooterView = UIView()
        titleTextField.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        descriptionTextField.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        dateDone()
        datePicker.addTarget(self, action: #selector(doneDatePicker(datePicker:)), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    @IBAction func topSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            self.pin = true
            UserDefaults.standard.set(pin, forKey: "truePin")
        } else {
            self.pin = false
            UserDefaults.standard.set(pin, forKey: "falsePin")
        }
    }
    
    @IBAction func saveImDate(_ sender: UIBarButtonItem) {
        saveImDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "ja_JP")
               
        let otherDate1 = datePicker.date
        let targetDate = Calendar.current.dateComponents(
            [.year, .month, .day],from: otherDate1)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: targetDate, repeats: false)
        
        content.title = "勉強を始める時間です。"
        content.body = dateFormatter.string(from: otherDate1)
        content.sound = UNNotificationSound.default
        
        request = UNNotificationRequest.init(
                identifier: identifier,
                content: content,
                trigger: trigger)
        UserDefaults.standard.set(identifier, forKey: "identifier")
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    @IBAction func selectDate(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        dateLabel.text = "\(formatter.string(from: datePicker.date))"
    }
    
    @objc func doneDatePicker(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        dateLabel.text = "\(formatter.string(from: datePicker.date))"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        
        return true
    }
}

extension AddDateViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 2:
            if isPicker == true {
                isPicker = false
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
                self.tableView.endUpdates()
            } else {
                isPicker = true
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
                self.tableView.endUpdates()
            }
            dateDone()
            tableView.reloadData()
        default:
            break
        }
    }
    
}

extension AddDateViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
          return 5
      }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && isPicker == true {
            return 2
        } else {
            return 1
        }
    }
}

extension AddDateViewController {
    
    func dateDone() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        dateLabel.text = "\(formatter.string(from: datePicker.date))"
    }
    
    func saveImDate() {
        let alert = UIAlertController(title: "タイトルを設定してください。", message: "", preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okbutton)
        
        if titleTextField.text == "" {
            present(alert, animated: true, completion: nil)
        } else {
            guard let title = titleTextField.text,
                let description = descriptionTextField.text,
                let date = dateLabel.text else { return }
            let importantDay = AddDate(title: title, content: description, date: date, pin: self.pin)
            if let storedDay = model.loadMemos() {
                var newDates = storedDay
                var flag = false
                for (i, data) in newDates.enumerated() {
                    if data.pin == false && self.pin == true {
                        newDates.insert(importantDay, at: i)
                         flag = true
                        break;
                    }
                }
                if flag == false && self.pin == true {
                    newDates.append(importantDay)
                }
                if newDates.count == 0 || self.pin == false {
                    newDates.append(importantDay)
                }
                model.saveMemos(newDates)
            } else {
                model.saveMemos([importantDay])
            }
            self.dismiss(animated: true, completion: nil)

        }
    }
}
