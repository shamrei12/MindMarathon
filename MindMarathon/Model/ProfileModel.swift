//
//  UserModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 7.01.24.
//

import Foundation
import RealmSwift

struct ProfileModel {
    var username: String
    var nationality: String
    var userImage: String
    var userExpirience: Int
    var userLevel: Int
    var dateUpdate: TimeInterval
    var timeInGame: TimeInterval
    var countGames: Int
    var favoriteGame: String
    var winStrike: Int
    var premiumStatus: TimeInterval
    var userID: UUID
}

class ProfileManager: Object {
    @objc dynamic var username = ""
    @objc dynamic var nationality = ""
    @objc dynamic var userImage = ""
    @objc dynamic var userLevel = 1
    @objc dynamic var userExpirience = 0
    @objc dynamic var dateUpdate = 0
    @objc dynamic var timeInGame = 0
    @objc dynamic var countGames = 0
    @objc dynamic var favoriteGame = ""
    @objc dynamic var winStrike = 0
    @objc dynamic var premiumStatus = TimeInterval(0)
    @objc dynamic var userID = ""
    
    convenience init(username: String, nationality: String, userImage: String, userLevel: Int, userExpirience: Int, dateUpdate: TimeInterval, timeInGame: TimeInterval, countGames: Int, favoriteGame: String, winStrike: Int, premiumStatus: TimeInterval, userID: String) {
        self.init()
        self.username = username
        self.nationality = nationality
        self.userImage = userImage
        self.userLevel = userLevel
        self.userExpirience = userExpirience
        self.dateUpdate = Int(dateUpdate)
        self.timeInGame = Int(timeInGame)
        self.countGames = countGames
        self.favoriteGame = favoriteGame
        self.winStrike = winStrike
        self.premiumStatus = premiumStatus
        self.userID = userID
    }
}
