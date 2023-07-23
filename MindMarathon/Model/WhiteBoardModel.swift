//
//  WhiteBoardModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 11.06.23.
//

import Foundation
import RealmSwift

enum ResultGame {
    case win, lose
}

struct WhiteBoardModel {
    var nameGame: String
    var resultGame: String
    var countStep: String
    var timerGame: String

}

class WhiteBoardManager: Object {
    @objc dynamic var nameGame = ""
    @objc dynamic var resultGame = ""
    @objc dynamic var countStep = ""
    @objc dynamic var timerGame = ""
    
    convenience init(nameGame: String, resultGame: String, countStep: String, timerGame: String) {
        self.init()
        self.nameGame = nameGame
        self.resultGame = resultGame
        self.countStep = countStep
        self.timerGame = timerGame
    }
}
