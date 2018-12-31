//
//  UserApi.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/24/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    let USER_REF = Database.database().reference().child("users")
    let AUTH = Auth.auth()
    var CURRENT_USER: User? {
        if let current = Auth.auth().currentUser {
            return current
        }
        return nil
    }
    
    func observe(withID id: String,completion: @escaping (Users) -> Void) {
        USER_REF.child(id).observeSingleEvent(of: .value) { (snapShot) in
            if let dict = snapShot.value as? NSDictionary {
                let user = Users.transformUser(dictionary: dict)
                completion(user)
            }
        }
    }
    

    func observeCurrentUser(completion: @escaping (Users) -> Void) {
        let id = Auth.auth().currentUser?.uid
        USER_REF.child(id!).observeSingleEvent(of: .value) { (snapShot) in
            if let dict = snapShot.value as? NSDictionary {
                let user = Users.transformUser(dictionary: dict)
                completion(user)
            }
        }
    }
}
