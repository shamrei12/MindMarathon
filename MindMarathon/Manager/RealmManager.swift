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
    
    enum TypeData {
        case userLevel
    }

    func saveResult(result: WhiteBoardModel) {
        do {
            let realm = try Realm()
            
            let resultGame = WhiteBoardManager()
            resultGame.nameGame = result.nameGame
            resultGame.timerGame = result.timerGame
            resultGame.countStep = result.countStep
            resultGame.resultGame = result.resultGame
            
            try realm.write {
                realm.add(resultGame)
            }
        } catch {
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
            let realm = try Realm() 
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
    
    func firstCreateUserProfile(userName: String) {
        var profileMassive = [ProfileManager]()
        
        do {
            let realm = try Realm()
            let tasks = realm.objects(ProfileManager.self)
            
            profileMassive = [ProfileManager(username: userName, nationality: "world", userImage: "userImage", userLevel: 1, userExpirience: 0, dateUpdate: 0, timeInGame: 0, countGames: 0, favoriteGame: "isHaveData", winStrike: 0, premiumStatus: TimeInterval(0), userID: "\(UserDefaultsManager.shared.getUIID())", userScore: 800)]
            
            try realm.write {
                realm.add(profileMassive)
            }
        } catch {
            print("error")
        }
    }
    
    func actualityProfileData() {
        let userStatistics = getUserStatistics()
        let resultGame = userStatistics.map { $0.resultGame }
        var seconds = 0
        let labelGame = userStatistics.map { $0.nameGame }
        
        for i in userStatistics {
            seconds += i.timerGame
        }
       
        let favoriteGame = mostFrequentWord(in: labelGame) ?? "isHaveData"
        let countWinStrike = getWinStrike(massive: resultGame)
        
        do {
            let realm = try Realm()
            let tasks = realm.objects(ProfileManager.self)
         
            try realm.write {
                tasks[0].favoriteGame = favoriteGame
                tasks[0].timeInGame = seconds
                tasks[0].countGames = userStatistics.count
                tasks[0].winStrike = countWinStrike
            }
        } catch {
            print("error")
        }
    }
    
    func getWinStrike(massive: [String]) -> Int {
        var countWinStrike = 0
        var tempCountWinStrike = 0
        
        for i in massive {
            if i == "win" {
                tempCountWinStrike += 1
                countWinStrike = max(countWinStrike, tempCountWinStrike)
            } else {
                tempCountWinStrike = 0
            }
        }
        return countWinStrike
    }
    
    func mostFrequentWord(in words: [String]) -> String? {
        let wordCounts = words.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
        return wordCounts.max { $0.1 < $1.1 }?.key.localize()
    }
    
    func getUserProfileData() -> [ProfileManager] {
        var userProfile = [ProfileManager]()
        
        do {
            let realm = try Realm()
            let statistics = realm.objects(ProfileManager.self)
            userProfile = Array(statistics)
        } catch {
            print("Error: \(error)")
        }
        return userProfile
    }
    
    func addUserExpirience(exp: Int) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(ProfileManager.self)
         
            try realm.write {
                tasks[0].userExpirience = exp
            }
        } catch {
            print("error")
        }
    }
    
    func changeUserLevel(level: Int) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(ProfileManager.self)
         
            try realm.write {
                tasks[0].userLevel = level
            }
        } catch {
            print("error")
        }
    }
    
    func addPremiumStatus(status: TimeInterval) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(ProfileManager.self)
         
            try realm.write {
                tasks[0].premiumStatus = status
                tasks[0].userScore += 800
            }
        } catch {
            print("error")
        }
    }
    
    func getUserId() -> String {
        var statisticsMassive = String()
        
        do {
            let realm = try Realm()
            let statistics = realm.objects(ProfileManager.self)
            statisticsMassive = statistics[0].userID
        } catch {
            print("Error: \(error)")
        }
        
        return statisticsMassive
    }
    
    func addUserscore(score: Int) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(ProfileManager.self)
         
            try realm.write {
                tasks[0].userScore += score
            }
        } catch {
            print("error")
        }
    }
    
    func changeUserNationality(country: String) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(ProfileManager.self)
         
            try realm.write {
                tasks[0].nationality = country
            }
        } catch {
            print("error")
        }
    }
    
    func changeUserData(typeData: TypeData, data: Any) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(ProfileManager.self)
            
            try realm.write {
                if typeData == .userLevel {
                    if let level = data as? Int {
                        tasks[0].userLevel = level
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
    func changeUsername(name: String) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(ProfileManager.self)
         
            try realm.write {
                tasks[0].username = name
            }
        } catch {
            print("error")
        }

    }
}


