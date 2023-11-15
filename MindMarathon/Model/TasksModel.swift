//
//  TasksModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import Foundation
import RealmSwift

struct TasksModel {
    var condition: String
    var status: Bool
    var timeRestart: TimeInterval
    var finishTime: TimeInterval
    var reward: Int
}

class TasksManager: Object {
    @objc dynamic var condition = ""
    @objc dynamic var status = false
    @objc dynamic var timeRestart =  TimeInterval(0)
    @objc dynamic var finishTime = TimeInterval(0)
    @objc dynamic var reward = 0
    
    convenience init(condition: String, status: Bool, timeRestart: TimeInterval, finishTime: TimeInterval, reward: Int) {
        self.init()
        
        self.condition = condition
        self.status = status
        self.timeRestart = timeRestart
        self.finishTime = finishTime
        self.reward = reward
    }
}




