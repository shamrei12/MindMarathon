//
//  UserDefaultsManager.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 17.11.23.
//

import UIKit


class UserDefaultsManager {
    static var shared: UserDefaultsManager = {
        let instance = UserDefaultsManager()
        return instance
    }()
    
    private let userDefaults = UserDefaults()
    private let firstStartKey = "firstStart"
    private let userExpirienseKey = "userExpiriense"
    
    func checkFirstStart() {
        if userDefaults.object(forKey: firstStartKey) == nil {
            userDefaults.setValue(true, forKey: firstStartKey)
        }
        
        if userDefaults.object(forKey: userExpirienseKey) == nil {
            userDefaults.setValue(0, forKey: userExpirienseKey)
        }
        
    }
    
    func addExpirience(exp: Int) {
        var userExp = userDefaults.object(forKey: userExpirienseKey) as? Int
        userExp! += exp
        userDefaults.setValue(userExp, forKey: userExpirienseKey)
    }
    
    func getUserExpiriense() -> Int? {
        if let userExp = userDefaults.integer(forKey: userExpirienseKey) as Int? {
            return userExp
        }
        
        return 0
    }
}
