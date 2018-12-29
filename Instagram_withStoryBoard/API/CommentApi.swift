//
//  StorageApi.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/24/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    let COMMENT_REF = Database.database().reference().child("comments")
    
    func observe(withKey key: String, completion: @escaping (Comments) -> Void) {
        COMMENT_REF.child(key).observeSingleEvent(of: .value) { (snapShot) in
            if let dictionary = snapShot.value as? NSDictionary {
                let newComment = Comments.transformComments(dictionary: dictionary)
                completion(newComment)
            }
        }
    }
}
