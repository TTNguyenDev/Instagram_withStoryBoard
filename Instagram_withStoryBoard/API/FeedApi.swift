//
//  FeedApo.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 1/2/19.
//  Copyright © 2019 TT Nguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    let FEED_REF = Database.database().reference().child("feed")
    
    func saveYourOwnPostToFeed(with postId: String) {
        FEED_REF.child(Api.user.CURRENT_USER!.uid).child(postId).setValue(true)
    }
    
    func savePostsAfterFollowUser(userId: String) {
        Api.myPost.MYPOST_REF.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let dic = snapshot.value as? NSDictionary {
                for key in dic.allKeys {
                    self.FEED_REF.child(Api.user.CURRENT_USER!.uid).child(key as! String).setValue(true)
                }
            }
        }
    }
    
    func savePostsAfterUnfollowUser(userId: String) {
        Api.myPost.MYPOST_REF.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let dic = snapshot.value as? NSDictionary {
                for key in dic.allKeys {
                    self.FEED_REF.child(Api.user.CURRENT_USER!.uid).child(key as! String).setValue(NSNull())
                }
            }
        }
    }
    
    func loadPostId(completion: @escaping (Posts) -> Void, onFail: @escaping () -> Void) {
        FEED_REF.child(Api.user.CURRENT_USER!.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                for key in dict.allKeys {
                    Api.post.observePostWithId(id: key as! String, completion: { (newPost) in
                       completion(newPost)
                    })
                }
            } else {
                onFail()
            }
        }
    }
    
}
