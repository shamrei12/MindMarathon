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
    
    func getTaks() -> [TasksManager] {
        var taskMassive = [TasksManager]()
        clearRealmDatabase()
        do {
            let realm = try Realm() // Получение экземпляра Realm
            let tasks = realm.objects(TasksManager.self)
            
            if tasks.isEmpty {
                let massiveTask: [TasksManager] = [TasksManager(condition: "Выйграйте в любую игру", status: true, timeRestart: 10, finishTime: 10, reward: 10), TasksManager(condition: "Сыграйте в крестики нолики", status: false, timeRestart: 10, finishTime: 150, reward: 10), TasksManager(condition: "Закрасте поле в игре заливка в зеленый цвет", status: true, timeRestart: 10, finishTime: 0, reward: 100), TasksManager(condition: "Победите в крестики нолики 3 раза подряд", status: false, timeRestart: 10, finishTime: 0, reward: 20), TasksManager(condition: "В игре быки и коровы угадайте число за 7 попыток", status: false, timeRestart: 10, finishTime: 0, reward: 100) ]
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
