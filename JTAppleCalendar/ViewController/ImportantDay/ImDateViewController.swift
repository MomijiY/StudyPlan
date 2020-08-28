//
//  ImDateViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

final class ImDateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noneLabel: UILabel!
    
    private var adddate: AddDate!
    private let model = UserDefaultsModel()
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
        self.setNeedsStatusBarAppearanceUpdate()
        tableView.tableFooterView = UIView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemos()
    }

}

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
}


extension ImDateViewController {
    
    func loadMemos() {
        guard let memos = model.loadMemos() else { return }
        self.dataSource = memos
    }
}

extension ImDateViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            noneLabel.isHidden = false
        } else {
            noneLabel.isHidden = true
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImportantDayTableViewCell.reuseIdentifier, for: indexPath) as! ImportantDayTableViewCell
        let selectionview = UIView()
        selectionview.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.2)
        
        cell.selectedBackgroundView = selectionview
        
        cell.cellView.layer.cornerRadius = 20
        selectionview.layer.cornerRadius = 20
        let memo = dataSource[indexPath.row]
        cell.titleLabel.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        cell.descriptionLabel.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        cell.dateLabel.textColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
        cell.cellView.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 1.0)
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
        tableView.deselectRow(at: indexPath, animated: true)
        let addDate = dataSource[indexPath.row]
        let vc = ImDetailViewController.instance(addDate)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let kStoredMemosKey: String = "kStoredMemosKey"
        if editingStyle == UITableViewCell.EditingStyle.delete {
            dataSource.remove(at: indexPath.row)
            guard let data = try? JSONEncoder().encode(dataSource) else { return }
            UserDefaults.standard.set(data, forKey: kStoredMemosKey)

            self.tableView.reloadData()
        }
    }
    
}
