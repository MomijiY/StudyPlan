//
//  AddDateViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class AddDateViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var top: UISwitch!
    var pin = true
    var isPicker = false
    
    private let model = UserDefaultsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "datecell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pincell")
        tableView.tableFooterView = UIView()
        dateDone()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    @IBAction func topSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            //トップに固定する時
            self.pin = true
            UserDefaults.standard.set(pin, forKey: "truePin")
        } else {
            // トップに固定しない時
            self.pin = false
            UserDefaults.standard.set(pin, forKey: "falsePin")
        }
    }
    
    @IBAction func saveImDate(_ sender: UIBarButtonItem) {
        saveImDate()
    }
    
    @IBAction func selectDate(_ sender: Any) {
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

//MARK: TableViewdelegate, tableViewDataSource

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

//MARK: Functions
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
                    //データのピンが全てtrueだとここで挿入できないのでそのときはvar flagで判断するようにしています。
                    if data.pin == false && self.pin == true {
                        newDates.insert(importantDay, at: i)
                         flag = true
                        break;
                    }
                }
                //flag==falseのままとき（上でデータが挿入できなかった時）ここでnewDatesにデータを入れています。
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
            print([importantDay])
//            navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)

        }
    }
}
