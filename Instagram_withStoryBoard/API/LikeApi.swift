//
//  LikeApi.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/25/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class LikeApi {
    let LIKE_REF = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("likes")
    
    
    func increaseLike(for post: Posts, completion: @escaping (Posts) -> Void) {
        let ref =  Api.post.POST_REF.child(post.id!)
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likesCount = post["likesCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    likesCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likesCount += 1
                    likes[uid] = true
                }
                post["likesCount"] = likesCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Posts.transformPostPhoto(dictionary: dict as NSDictionary, key: snapshot!.key)
                completion(post)
            }
        }
    }
}
