//
//  TasksManager.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.11.23.
//

import Foundation


class CheckTaskManager {
    static var shared: CheckTaskManager = {
        let instance = CheckTaskManager()
        return instance
    }()
    
    func checkPlayGame(game: Int) {
        switch game {
        case 0:
            RealmManager.shared.taskCompleted(index: 0)
        case 1:
            RealmManager.shared.taskCompleted(index: 1)
        case 2:
            RealmManager.shared.taskCompleted(index: 2)
        case 3:
            RealmManager.shared.taskCompleted(index: 3)
        case 4:
            RealmManager.shared.taskCompleted(index: 4)
        case 5:
            RealmManager.shared.taskCompleted(index: 5)
        default:
            print("Error")
        }
    }
}
