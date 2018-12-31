//
//  MyPostApi.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 12/28/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class MyPostApi {
    let MYPOST_REF = Database.database().reference().child("myPost")
    func observe(completion: @escaping (Posts) -> Void) {
        let currentUser = Auth.auth().currentUser?.uid
        MYPOST_REF.child(currentUser!).observeSingleEvent(of: .value) { (snapshot) in
            Api.post.observePostWithId(id: snapshot.key
                , completion: { (post) in
                    print(post)
            })
            
        }
    }
    
    func getPostFromServer(completion: @escaping (Posts) -> Void) -> UInt {
        return MYPOST_REF.child(Api.user.CURRENT_USER!.uid).observe(.childAdded) { (snapshot) in
            print(snapshot.key)
            Api.post.observePostWithId(id: snapshot.key, completion: { (post) in
                completion(post)
            })
        }
    }
}
