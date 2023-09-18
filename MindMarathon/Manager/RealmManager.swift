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
}
