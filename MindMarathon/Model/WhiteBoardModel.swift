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

protocol WhiteBoardProtocol {
    var nameGame: String { get set }
    var timerGame: String { get set }
    var countStep: String { get set }
    var resultGame: String { get set}
}

struct WhiteBoardModel: WhiteBoardProtocol {
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
