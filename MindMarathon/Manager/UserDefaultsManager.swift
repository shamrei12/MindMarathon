//
//  UserDefaultsManager.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 17.11.23.
//

import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults()
    private let userLevelKey = "userLevel"
    private let firstStartKey = "firstStart"
    private let userExperienceKey = "userExperience"
    private let currentThemeKey = "currentTheme"
    private let currentLanguageKey = "currentLanguage"
    private let editUserKey = "editUserKey"
    private let userimagekey = "userimagekey"
    
    func checkFirstStart() -> Bool {
//        userDefaults.set(nil, forKey: firstStartKey)
        return userDefaults.object(forKey: firstStartKey) == nil
    }
    
    func setupDataUserDefaults() {
       
        if userDefaults.object(forKey: firstStartKey) == nil {
            userDefaults.set(true, forKey: firstStartKey)
        }
    }
    
    func addExperience(exp: Int) {
        let userExp = userDefaults.integer(forKey: userExperienceKey)
        userDefaults.set(userExp + exp, forKey: userExperienceKey)
    }
    
    func getUserExperience() -> Int {
        return userDefaults.integer(forKey: userExperienceKey)
    }
    
    func getUserLevel() -> Int {
        return userDefaults.integer(forKey: userLevelKey)
    }
    
    func setCurrentLanguage(lang: String?) {
        userDefaults.set(lang, forKey: currentLanguageKey)
    }
    
    func setCurrentTheme(theme: String?) {
        userDefaults.set(theme, forKey: currentThemeKey)
    }
    
    func getLanguage() -> String {
        return userDefaults.string(forKey: currentLanguageKey) ?? "en"
    }
    
    func getTheme() -> String {
        return userDefaults.string(forKey: currentThemeKey) ?? "auto"
    }
    
    func changeExpirience(exp: Int) {
        userDefaults.set(exp, forKey: userExperienceKey)
    }
    
    func changeUserLebel(level: Int) {
        userDefaults.setValue(level, forKey: userLevelKey)
    }
    
    func synchronize() {
        userDefaults.synchronize()
    }
    
    func getUIID() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    func changeUserKey(type: Bool) {
        if userDefaults.object(forKey: editUserKey) != nil {
            userDefaults.set(type, forKey: editUserKey)
        } else {
            userDefaults.set(false, forKey: editUserKey)
        }
    }
    
    func getUserKey() -> Bool {
        return userDefaults.bool(forKey: editUserKey)
    }

    
}

