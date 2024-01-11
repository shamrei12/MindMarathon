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
        RealmManager.shared.addUserExpirience(exp: game)
        RealmManager.shared.addUserscore(score: game * 3)
    }
}
