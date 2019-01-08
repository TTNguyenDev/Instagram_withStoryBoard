//
//  SearchApi.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 1/7/19.
//  Copyright © 2019 TT Nguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SearchApi {
    func searchByString(searchValue: String, completion: @escaping (Users) -> Void) {
        let USER_REF = Database.database().reference().child("users")
        USER_REF.queryOrdered(byChild: "username").queryStarting(atValue: searchValue).queryEnding(atValue: searchValue + "\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach({ (eachUser) in
                let child = eachUser as! DataSnapshot
                if let dictionary = child.value as? NSDictionary {
                    let user = Users.transformUser(dictionary: dictionary, userId: snapshot.key)
                    completion(user)
                }
            })
        }
    }
}
