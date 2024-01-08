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
    var dateUpdate: TimeInterval
}

class ProfileManager: Object {
    @objc dynamic var username = ""
    @objc dynamic var nationality = ""
    @objc dynamic var userImage = ""
    @objc dynamic var userExpirience = ""
    @objc dynamic var dateUpdate = ""
    
    convenience init(username: String, nationality: String, userImage: String, userExpirience: String, dateIpdate: TimeInterval) {
        self.init()
        self.username = username
        self.nationality = nationality
        self.userImage = userImage
        self.userExpirience = userExpirience
        self.dateUpdate = dateUpdate
    }
}
