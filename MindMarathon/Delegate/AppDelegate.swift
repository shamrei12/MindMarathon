//
//  AppDelegate.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import UserNotifications
import RealmSwift
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                self.sendMorningNotification()
                self.sendEveningNotification()
            }
        }
        FirebaseApp.configure()
        configureRealm()
        
        return true
    }
    
    func configureRealm() {
        let config = Realm.Configuration(
            // Указываем новую версию схемы базы данных
            schemaVersion: 25,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion <= 24 {
                    // Выполняем необходимые действия для изменения схемы
                    migration.enumerateObjects(ofType: WhiteBoardManager.className()) { oldObject, newObject in
                        if let oldTimerGame = oldObject?["timerGame"] as? String {
                            if let newTimerGame = Int(oldTimerGame) {
                                newObject?["timerGame"] = newTimerGame
                            }
                        }
                    }
                    
                    migration.enumerateObjects(ofType: ProfileManager.className()) { oldObject, newObject in
                        if let premium = oldObject?["premiumStatus"] as? Bool {
                            // Преобразование Bool в TimeInterval
                            let newPremium: TimeInterval = premium ? 1.0 : 0.0
                            
                            newObject?["premiumStatus"] = newPremium
                        }
                    }
                }
            }
        )
        // Устанавливаем новую конфигурацию Realm до инициализации
        Realm.Configuration.defaultConfiguration = config
    }
    
    func sendMorningNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Mind Marathon"
        content.body = "Быки и коровы начали играть в крестики нолики. Присоединишься?"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9 // Установите желаемое время утреннего уведомления
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "morningNotification", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendEveningNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Mind Marathon"
        content.body = "Буквы начали строить плохие слова. Помешай им!"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18 // Установите желаемое время вечернего уведомления
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "eveningNotification", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
