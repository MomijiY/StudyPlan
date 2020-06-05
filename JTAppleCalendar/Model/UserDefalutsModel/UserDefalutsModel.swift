//
//  UserDefalutsModel.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/11.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

struct UserDefaultsModel {
    
    // MARK: UserDefaults Key
    
    private let kStoredMemosKey: String = "kStoredMemosKey"
    
    // MARK: Memo
    
    func saveMemos(_ memo: [AddDate]) {
        guard let data = try? JSONEncoder().encode(memo) else { return }
        UserDefaults.standard.set(data, forKey: kStoredMemosKey)
    }
    
    func loadMemos() -> [AddDate]? {
        guard let data = UserDefaults.standard.data(forKey: kStoredMemosKey),
            let storedMemos = try? JSONDecoder().decode([AddDate].self, from: data) else { return nil }
        return storedMemos
    }
}
