//
//  ImDateViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

final class ImDateViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noneLabel: UILabel!
    
    // MARK: Properties
    
    var topin = Int()
    private var adddate: AddDate!
    private let model = UserDefaultsModel()
    private var dataSource: [AddDate] = [AddDate]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Lifecycle
    
    static func instance() -> ImDateViewController {
        let vc = UIStoryboard(name: "ImDateViewController", bundle: nil).instantiateInitialViewController() as! ImDateViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        tableView.tableFooterView = UIView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemos()
    }

}

// MARK: - Configure

extension ImDateViewController {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //中身のないセルの下線を消す
        tableView.tableFooterView = UIView()
        tableView.rowHeight = ImportantDayTableViewCell.rowHeight
        tableView.register(ImportantDayTableViewCell.nib, forCellReuseIdentifier: ImportantDayTableViewCell.reuseIdentifier)
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        // 半透明の指定（デフォルト値）
        self.navigationController?.navigationBar.isTranslucent = true
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像（境界線の画像）を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
}

// MARK: - Model

extension ImDateViewController {
    
    func loadMemos() {
        guard let memos = model.loadMemos() else { return }
        self.dataSource = memos
    }
}

// MARK: - TableView dataSource, delegate

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
        let mainBackgoundView = UIView()
        selectionview.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.2)
        cell.selectedBackgroundView = selectionview
        mainBackgoundView.layer.cornerRadius = 20
        cell.backgroundView = mainBackgoundView
        let memo = dataSource[indexPath.row]
        cell.setupCell(title: memo.title, content: memo.content, date: memo.date, pin: memo.pin)
        if memo.pin == true {
//            cell.backgroundColor = UIColor(red: 163/255, green: 210/255, blue: 190/255, alpha: 0.8)
            mainBackgoundView.backgroundColor = UIColor(red: 163/255, green: 210/255, blue: 190/255, alpha: 0.8)
        }
        if memo.pin == false {
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let addDate = dataSource[indexPath.row]
        let vc = ImDetailViewController.instance(addDate)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //セルの削除許可を設定
    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    //　スワイプで削除する関数
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let kStoredMemosKey: String = "kStoredMemosKey"
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //メモ削除
            dataSource.remove(at: indexPath.row)
            guard let data = try? JSONEncoder().encode(dataSource) else { return }
            UserDefaults.standard.set(data, forKey: kStoredMemosKey)

            self.tableView.reloadData()
        }
    }
    
}
