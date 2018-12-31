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
    let POST_COMMENT_REF = Database.database().reference().child("post-comments")
    
    func observe(withKey key: String, completion: @escaping (Comments) -> Void) {
        COMMENT_REF.child(key).observeSingleEvent(of: .value) { (snapShot) in
            if let dictionary = snapShot.value as? NSDictionary {
                let newComment = Comments.transformComments(dictionary: dictionary)
                completion(newComment)
            }
        }
    }
    
    func sendMessToServer(mess: String, postId: String, onFail: @escaping (String) -> Void) {
        let newCommentId = COMMENT_REF.childByAutoId().key
        let newCommentRef = COMMENT_REF.child(newCommentId!)
        
        let currentId = Api.user.CURRENT_USER?.uid
        newCommentRef.setValue(["uid": currentId, "comment": mess]) { (error, refs) in
            if error != nil {
                onFail((error?.localizedDescription)!)
                return
            }
            
            //recognize which post has comment
            let postComment = self.POST_COMMENT_REF.child(postId).child(newCommentId!)
            postComment.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    onFail((error?.localizedDescription)!)
                    return
                }
            })
        }
    }
    
    func loadComment(postId: String, onSuccess: @escaping (Comments) -> Void) {
        POST_COMMENT_REF.child(postId).observe(.childAdded) { (snapShot) in
            Api.comment.observe(withKey: snapShot.key, completion: { (newComment) in
                onSuccess(newComment)
            })
        }
    }
}
