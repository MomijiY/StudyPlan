//
//  ImDetailViewController.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class ImDetailViewController: UITableViewController, UICollectionViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var addDate: AddDate!
    
    static func instance(_ adddate: AddDate) -> ImDetailViewController {
        let vc = UIStoryboard(name: "ImDetailViewController", bundle: nil).instantiateInitialViewController() as! ImDetailViewController
        vc.addDate = adddate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        configureUI()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ImDetailViewController {
    
    func configureUI() {
        
        titleLabel.text = addDate.title
        descriptionLabel.text = addDate.content
        dateLabel.text = addDate.date
        
    }
}
