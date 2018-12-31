//
//  Posts.swift
//  Instargram
//
//  Created by TT Nguyen on 11/16/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation

class Posts {
    var caption: String?
    var imageUrl: String?
    var uid: String?
    var id: String?
    var likesCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
}

extension Posts {
    static func transformPostPhoto(dictionary: NSDictionary, key: String) -> Posts {
        let post = Posts()
        post.caption = dictionary["caption"] as? String
        post.imageUrl = dictionary["photoUrl"] as? String
        post.uid = dictionary["uid"] as? String
        post.id = key
        post.likesCount = dictionary["likesCount"] as? Int
        post.likes = dictionary["likes"] as? Dictionary<String, Any>
        
        if let currentUser = Api.user.CURRENT_USER?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUser] != nil
            }
        }
        return post
    }
}
