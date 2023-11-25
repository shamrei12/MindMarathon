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
    private let currentTheme = "currentTheme"
    private let currentLanguage = "currentLanguage"
    
    func checkFirstStart() {
//        userDefaults.setValue(nil, forKey: userExpirienseKey)
//        userDefaults.setValue(nil, forKey: firstStartKey)
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
    
    func setCurrentLanguage(lang: String?) {
        userDefaults.setValue(lang, forKey: currentLanguage)
    }
    
    func setCurrentTheme(theme: String?) {
        userDefaults.setValue(theme, forKey: currentTheme)
    }
    
    func getLanguage() -> String {
        let lang = userDefaults.string(forKey: currentLanguage)
        if lang != nil {
            return lang ?? "en"
        } else {
            return "en"
        }
    }
    
    func getTheme() -> String {
        let theme = userDefaults.string(forKey: currentTheme)
        
        if theme != nil {
            return theme ?? "auto"
        } else {
            return "auto"
        }
    }
}
