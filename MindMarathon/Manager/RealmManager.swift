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
    
    func getResult() -> UserStatisticsModel {
        var userStatistics: [WhiteBoardManager] = []
        var winstrike = 0
        var gameList: Results<WhiteBoardManager>!
        var favoriteGame = String()
        var hourInGame = 0
        
        do {
            let realm = try Realm()
            gameList = realm.objects(WhiteBoardManager.self)
            userStatistics = Array(gameList).reversed()
        } catch {
            print("Failed to load game list: \(error)")
        }
        
        print(userStatistics[0].timerGame)
        return UserStatisticsModel(hoursInGame: 0, favoriteGame: "", winStrike: 0)
    }
    
}
