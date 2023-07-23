//
//  TimeManager.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 15.05.23.
//

import Foundation

class TimeManager {
    
    static var shared: TimeManager = {
        let instance = TimeManager()
        return instance
    }()
    
    private init() {}
    
    func convertToMinutes(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .short
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
    
    func curentDate(_ time: String) -> String {
        let times = Int(NSDate().timeIntervalSince1970)
        let date = Date(timeIntervalSince1970: TimeInterval(times))
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone(abbreviation: time)
        dateFormater.locale = Locale.current
        dateFormater.dateFormat = "d MMMM"
        let formattedString = dateFormater.string(from: date)
        return formattedString
    }

    func solstice(_ time: String) -> String {
        let times = Int(NSDate().timeIntervalSince1970)
        let date = Date(timeIntervalSince1970: TimeInterval(times))
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone(abbreviation: time)
        dateFormater.locale = Locale.current
        dateFormater.dateFormat = "HH:mm"
        let formattedString = dateFormater.string(from: date)
        return formattedString
    }
}
