//
//  AddViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {

    @IBOutlet weak var timeOneTextField: UITextField!
    @IBOutlet weak var timeTwoTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let newItem = Event()
        // TextFieldの値を代入
        newItem.time1 = timeOneTextField.text!
        newItem.time2 = timeTwoTextField.text!
        newItem.subject = subjectTextField.text!
        newItem.contetnt = contentTextView.text!
        // インスタンスをRealmに保存
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(newItem)
            })
        }catch{
        }
        // 画面を閉じる
        self.navigationController?.popViewController(animated: true)
    }
}
