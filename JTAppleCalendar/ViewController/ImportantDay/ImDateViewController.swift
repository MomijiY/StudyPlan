//
//  ImDateViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
//import RealmSwift

final class ImDateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noneLabel: UILabel!
    
    private var adddate: AddDate!
    private let model = UserDefaultsModel()
    
//    let realm = try! Realm()
//    var items: Results<ImportantDate>!
    private var dataSource: [AddDate] = [AddDate]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    static func instance() -> ImDateViewController {
        let vc = UIStoryboard(name: "ImDateViewController", bundle: nil).instantiateInitialViewController() as! ImDateViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let realm = try! Realm()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
//        self.items = realm.objects(ImportantDate.self).sorted(byKeyPath: "pin", ascending: false)
        self.tableView.reloadData()
        self.setNeedsStatusBarAppearanceUpdate()
        tableView.tableFooterView = UIView()
        configureTableView()
        
        
        guard let memos = model.loadMemos() else { return }
        self.dataSource = memos
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadMemos()
//        let realm = try! Realm()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
//        let date = Date()
//        let dateStr = formatter.string(from: date)
//        let realm = try! Realm()
//        self.items = realm.objects(ImportantDate.self).sorted(byKeyPath: "pin", ascending: false)
        guard let memos = model.loadMemos() else { return }
        self.dataSource = memos
//        print(items)
//        print(items[0].title)
        self.tableView.reloadData()
        
    }

}
//
extension ImDateViewController {

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = ImportantDayTableViewCell.rowHeight
        tableView.register(ImportantDayTableViewCell.nib, forCellReuseIdentifier: ImportantDayTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            noneLabel.isHidden = false
            return 0
        } else {
            noneLabel.isHidden = true
            return dataSource.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImportantDayTableViewCell.reuseIdentifier, for: indexPath) as! ImportantDayTableViewCell
        let selectionview = UIView()
//        let realm = try! Realm()
        selectionview.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.2)
        
//        print("title", self.items[indexPath.row].title)
        cell.selectedBackgroundView = selectionview

        cell.cellView.layer.cornerRadius = 20
        selectionview.layer.cornerRadius = 20
        let memo = dataSource[indexPath.row]
        cell.titleLabel.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        cell.descriptionLabel.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        cell.dateLabel.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        cell.cellView.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
//        guard let count = items?.count, indexPath.row < count else { return cell }
//
//        try! realm.write {
//            items[indexPath.row].title = self.dataSource[indexPath.row].title
//            items[indexPath.row].dateDescription = self.dataSource[indexPath.row].content
//            items[indexPath.row].date = self.dataSource[indexPath.row].date
//            items[indexPath.row].pin = self.dataSource[indexPath.row].pin
//            print("itemsTitle", items[indexPath.row].title)
//        }
        
        if memo.pin == true {
            cell.setupCell(title: memo.title, content: memo.content, date: memo.date, pin: false)
        }
        if memo.pin == false {
            cell.setupCell(title: memo.title, content: memo.content, date: memo.date, pin: true)
        }
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memo = dataSource[indexPath.row]
        UserDefaults.standard.set(memo.title, forKey: "title")
        UserDefaults.standard.set(memo.content, forKey: "description")
        UserDefaults.standard.set(memo.date, forKey: "date")
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }

    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let realm = try! Realm()
        let kStoredMemosKey: String = "kStoredMemosKey"
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            //メモ削除
            dataSource.remove(at: indexPath.row)
            guard let data = try? JSONEncoder().encode(dataSource) else { return }
            UserDefaults.standard.set(data, forKey: kStoredMemosKey)
            self.tableView.reloadData()
//            try! realm.write {
////                let memo = items[indexPath.row]
//                print("削除")
////                realm.delete(dataSource[indexPath.row])
//                realm.delete(items[indexPath.row])
////                items.remove(at: indexPath.row)
//
//                self.tableView.reloadData()
//            }
        }
    }

}


//extension ImDateViewController {
//
//    func loadMemos() {
//        guard let memos = model.loadMemos() else { return }
//        self.dataSource = memos
//    }
//}
