//
//  RealmManager.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 11.06.23.
//

import Foundation
import RealmSwift

class RealmManager {
    static var shared: RealmManager = {
        let instance = RealmManager()
        return instance
    }()
    
    func saveResult(result: WhiteBoardModel) {
        do {
            let realm = try Realm() // Доступ к хранилищу

            let resultGame = WhiteBoardManager()
            resultGame.nameGame = result.nameGame
            resultGame.timerGame = result.timerGame
            resultGame.countStep = result.countStep
            resultGame.resultGame = result.resultGame
            
            try realm.write {
                realm.add(resultGame)
            }
        } catch {
            // Обработка ошибок
            print("Ошибка при доступе к хранилищу Realm: \(error)")
        }
    }
    
    func getUserStatistics() -> [WhiteBoardManager] {
        var statisticsMassive = [WhiteBoardManager]()
        
        do {
            let realm = try Realm()
            let statistics = realm.objects(WhiteBoardManager.self)
            statisticsMassive = Array(statistics)
        } catch {
            print("Error: \(error)")
        }
        
        return statisticsMassive
    }
    
    func getTasks() -> [TasksManager] {
        var taskMassive = [TasksManager]()
        do {
            let realm = try Realm() // Получение экземпляра Realm
            let tasks = realm.objects(TasksManager.self)
            
            if tasks.isEmpty {
                let massiveTask: [TasksManager] = [
                    TasksManager(condition: "Сыграйте в Быки и коровы", status: false, timeRestart: 1200, finishTime: 0, reward: 10, isRestartTime: false),
                    TasksManager(condition: "Выйграйте в Словус", status: false, timeRestart: 1200, finishTime: 0, reward: 10, isRestartTime: false),
                    TasksManager(condition: "Выиграть в Крестики нолики", status: false, timeRestart: 1200, finishTime: 0, reward: 20, isRestartTime: false),
                    TasksManager(condition: "Сыграйте в Заливку", status: false, timeRestart: 1200, finishTime: 0, reward: 10, isRestartTime: false),
                    TasksManager(condition: "Сыграйте в Бинарио", status: false, timeRestart: 1200, finishTime: 0, reward: 10, isRestartTime: false),
                    TasksManager(condition: "Сыграйте в Цифры", status: false, timeRestart: 1200, finishTime: 0, reward: 40, isRestartTime: false)
                ]

                try realm.write {
                    realm.add(massiveTask)
                }
                taskMassive = Array(tasks)
            } else {
                taskMassive = Array(tasks)
            }
        } catch {
            print("Failed to load game list: \(error)")
        }
        return taskMassive
    }
    
    func taskCompleted(index: Int) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(TasksManager.self)
            
            guard index >= 0 && index < tasks.count else {
                print("Индекс задачи находится вне диапазона")
                return
            }
            
            if (TimeManager.shared.chechConditionTime(finishTime: tasks[index].finishTime) || tasks[index].finishTime == TimeInterval(0)) && !tasks[index].status {
                try realm.write {
                    tasks[index].status = true // Обновление статуса задачи
                    tasks[index].finishTime = TimeInterval(0)
                    tasks[index].isRestartTime = false
                }
            }
        } catch {
            print("Ошибка при обновлении статуса задачи: \(error)")
        }
    }
    
    func awardReceived(index: Int) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(TasksManager.self)
            
            guard index >= 0 && index < tasks.count else {
                print("Индекс задачи находится вне диапазона")
                return
            }
                try realm.write {
                    tasks[index].status = false
                    tasks[index].finishTime = TimeManager.shared.getFinishTime(restartTime: tasks[index].timeRestart)
                    tasks[index].isRestartTime = true
                }
            } catch {
            print("Ошибка при обновлении статуса задачи: \(error)")
        }
    }
    
    func clearRealmDatabase() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error \(error)")
        }
    }

}
