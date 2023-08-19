//
//  AppDelegate.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .alert]) { (granted, error) in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                print(settings)
                guard settings.authorizationStatus == .authorized else { return }
                 
            }
        }
        sendNotification()
        return true
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Mind Marathon"
        content.body = "Быки и коровы начали играть в крестики нолики. Присоединишься?"
        content.sound = UNNotificationSound.default
        
        let date = Date(timeIntervalSinceNow: 3600)
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            print(error?.localizedDescription)
        }
    }
}

