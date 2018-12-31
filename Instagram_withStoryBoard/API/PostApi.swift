//
//  PostApi.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/24/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi {
    let POST_REF = Database.database().reference().child("posts")
    func observe(completion: @escaping (Posts) -> Void) {
        POST_REF.observe(.childAdded) { (snapShot) in
            if let dictionary = snapShot.value as? NSDictionary {
                let newPost = Posts.transformPostPhoto(dictionary: dictionary, key: snapShot.key)
                completion(newPost)
            }
        }
    }
    
    func observePostWithId(id: String, completion: @escaping (Posts) -> Void) {
        POST_REF.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                let newPost = Posts.transformPostPhoto(dictionary: dictionary, key: snapshot.key)
                completion(newPost)
            }
        }
    }
    
    func likeOfPost(post: Posts, completion: @escaping (Posts) -> Void) {
        POST_REF.child(post.id!).observeSingleEvent(of: .value) { (snapShot) in
            if let dictionary = snapShot.value as? [String: Any] {
                let posts = Posts.transformPostPhoto(dictionary: dictionary as NSDictionary, key: snapShot.key)
                completion(posts)
            }
        }
    }
}
