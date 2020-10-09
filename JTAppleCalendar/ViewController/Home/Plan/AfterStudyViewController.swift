//
//  AfterStudyViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/08/08.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift

class AfterStudyViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    let realm = try! Realm()
    var item: Results<Event>!
    
    var starsPicker: UIPickerView = UIPickerView()
    let stars: [String] = ["全然できなかった", "予定していた勉強ができなかった", "予定通り", "予定していたより勉強ができた", "集中してたくさんの勉強ができた"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        item = realm.objects(Event.self)
        
        //pickerの設定
        starsPicker.delegate = self
        starsPicker.dataSource = self
        textField.inputView = starsPicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        spacelItem.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        doneItem.tintColor = UIColor(red: 52/255, green: 85/255, blue: 109/255, alpha: 1.0)
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        textField.inputAccessoryView = toolbar
    }
    
    @IBAction func tappedSaveButton(_ sender: UIBarButtonItem) {
        print("tappedSaveButton")
        try! realm.write() {
            //書き換え完了
            item[UserDefaults.standard.object(forKey: "itemNum") as! Int].afterStudyStars = textField.text
            item[UserDefaults.standard.object(forKey: "itemNum") as! Int].afterStudyComment = textView.text
            
            print(textField.text)
            print(textView.text)
            UserDefaults.standard.set("true", forKey: "afterStudyStars")
            UserDefaults.standard.set("true", forKey: "afterStudyComment")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func done() {
        textField.endEditing(true)
        textField.text = "\(stars[starsPicker.selectedRow(inComponent: 0)])"
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stars.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = stars[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stars[row]
    }
}
