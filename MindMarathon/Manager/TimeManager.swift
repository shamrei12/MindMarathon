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
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
    
    func convertToMinutesWhiteBoard(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
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
    
    func getFinishTimeForTask(taskTime: TimeInterval) -> Int {
        let currentTimeInterval = getCurrentTime()
        let finishTimeInterval = getFinishTime(restartTime: taskTime)
        
        return Int(finishTimeInterval - currentTimeInterval)
    }
    
    func getFinishTimeForTimer(finishTime: TimeInterval) -> Int {
        return Int(finishTime - getCurrentTime())
    }
    
    func getFinishTime(restartTime: TimeInterval) -> TimeInterval {
        return getCurrentTime() + restartTime
    }
    
    func getCurrentTime() -> TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    func chechConditionTime(finishTime: TimeInterval) -> Bool {
        return finishTime <= getCurrentTime() ? true : false
    }
    
    func getEndlessPremium() -> TimeInterval {
        let startOfYear1970 = Date(timeIntervalSince1970: 0) // Начало Unix time

        let yearsToAdd = 100
        let secondsInAYear = 365.25 * 24 * 60 * 60 // Среднее количество секунд в году (учитывая високосные года)
        let secondsIn100Years = Double(yearsToAdd) * secondsInAYear

        let dateIn100Years = startOfYear1970.addingTimeInterval(secondsIn100Years)
        let unixTimeIn100Years = dateIn100Years.timeIntervalSince1970

        return unixTimeIn100Years
    }
}
