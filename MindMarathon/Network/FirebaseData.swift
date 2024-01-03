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
    
    func saveIDPostUser(id: String) {
        let ref = Database.database().reference().child("users")
        
        ref.child("idPosts").getData { (err, snap) in
            ref.child("idPosts").child("\(snap!.childrenCount + 1)").setValue("\(id)")
        }
    }
}

