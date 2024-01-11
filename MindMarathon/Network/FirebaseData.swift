//
//  FirebaseData.swift
//  TakeMeHome
//
//  Created by Алексей Шамрей on 15.02.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseDatabase

protocol FirebaseProtocol {
    //    func save(posts: [AdvertProtocol])
    //    func load() -> [AdvertProtocol]
}

class FirebaseData: FirebaseProtocol {
    var currentUploadTask: StorageUploadTask?
    
    func refGetData(from profile: [ProfileManager]) {
        let ref = Database.database().reference().child("users").child("\(profile[0].userID)")
        
        ref.observeSingleEvent(of: .value) { _ in
            let userData = [
                "username": profile[0].username,
                "nationality": profile[0].nationality,
                "userImage": profile[0].userImage,
                "userExpirience": profile[0].userExpirience,
                "userLevel": profile[0].userLevel,
                "dateUpdate": profile[0].dateUpdate,
                "timeInGame": profile[0].timeInGame,
                "countGames": profile[0].countGames,
                "favoriteGame": profile[0].favoriteGame,
                "winStrike": profile[0].winStrike,
                "premiumStatus": profile[0].premiumStatus,
                "userID": profile[0].userID,
                "userScore": profile[0].userScore
            ]
            ref.setValue(userData) { (error, _) in
                if let error = error {
                    // Обработка ошибки при сохранении данных
                    print("Ошибка при сохранении данных: \(error.localizedDescription)")
                } else {
                    // Данные успешно сохранены
                    print("Данные успешно сохранены")
                }
            }
        }
    }
    
    func getUserProfile(id: String, completion: @escaping ([ProfileManager]) -> Void) {
        var resultMass = [ProfileManager]()
        let ref = Database.database().reference().child("users").child("\(id)")
        
        ref.observeSingleEvent(of: .value) { snap in
            if let snapshots = snap.children.allObjects as? [DataSnapshot] {
                if snap.children.allObjects is [DataSnapshot] {
                    if let profile = snap.value as? Dictionary<String, AnyObject> {
                        let username = profile["username"] as? String ?? ""
                        let nationality = profile["nationality"] as? String ?? ""
                        let userImage = profile["userImage"] as? String ?? ""
                        let userExperience = profile["userExperience"] as? Int ?? 0
                        let userLevel = profile["userLevel"] as? Int ?? 0
                        let dateUpdate = profile["dateUpdate"] as? TimeInterval ?? 0
                        let timeInGame = profile["timeInGame"] as? TimeInterval ?? 0
                        let countGames = profile["countGames"] as? Int ?? 0
                        let favoriteGame = profile["favoriteGame"] as? String ?? ""
                        let winStrike = profile["winStrike"] as? Int ?? 0
                        let premiumStatus = profile["premiumStatus"] as? TimeInterval ?? TimeInterval(0)
                        let userID = profile["userID"] as? String ?? ""
                        let userScore = profile["userScore"] as? Int ?? 0
                        
                        let profileManager = ProfileManager(username: username, nationality: nationality, userImage: userImage, userLevel: userLevel, userExpirience: userExperience, dateUpdate: dateUpdate, timeInGame: timeInGame, countGames: countGames, favoriteGame: favoriteGame, winStrike: winStrike, premiumStatus: premiumStatus, userID: userID, userScore: userScore)
                        
                        resultMass.append(profileManager)
                    }
                }
            }
            completion(resultMass)
        }
    }
    
    func getUserProfiles(completion: @escaping ([ProfileManager]) -> Void) {
        var resultMass = [ProfileManager]()
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value) { snap in
            if let snapshots = snap.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let profile = snap.value as? Dictionary<String, AnyObject> {
                        let username = profile["username"] as? String ?? ""
                        let nationality = profile["nationality"] as? String ?? ""
                        let userImage = profile["userImage"] as? String ?? ""
                        let userExperience = profile["userExperience"] as? Int ?? 0
                        let userLevel = profile["userLevel"] as? Int ?? 0
                        let dateUpdate = profile["dateUpdate"] as? TimeInterval ?? 0
                        let timeInGame = profile["timeInGame"] as? TimeInterval ?? 0
                        let countGames = profile["countGames"] as? Int ?? 0
                        let favoriteGame = profile["favoriteGame"] as? String ?? ""
                        let winStrike = profile["winStrike"] as? Int ?? 0
                        let premiumStatus = profile["premiumStatus"] as? TimeInterval ?? TimeInterval(0)
                        let userID = profile["userID"] as? String ?? ""
                        let userScore = profile["userScore"] as? Int ?? 0
                        
                        let profileManager = ProfileManager(username: username, nationality: nationality, userImage: userImage, userLevel: userLevel, userExpirience: userExperience, dateUpdate: dateUpdate, timeInGame: timeInGame, countGames: countGames, favoriteGame: favoriteGame, winStrike: winStrike, premiumStatus: premiumStatus, userID: userID, userScore: userScore)
                        
                        resultMass.append(profileManager)
                    }
                }
            }
            completion(resultMass)
        }
    }
    
    func getUserStatus(id: String, completion: @escaping (Bool) -> Void) {
        var result: Bool = false
        let ref = Database.database().reference().child("users").child("\(id)")
        
        ref.observe(.value) { snap in
            if let snapshots = snap.children.allObjects as? [DataSnapshot] {
                if let profile = snap.value as? [String: Any] {
                    result = profile["premiumStatus"] as? Bool ?? false
                }
            }
            completion(result)
        }
    }
    
    func givePremium(id: String) {
        let ref = Database.database().reference().child("users")
        ref.child("premiumUser").getData { (err, snap) in
            ref.setValue("\(id)")
        }
    }
}
