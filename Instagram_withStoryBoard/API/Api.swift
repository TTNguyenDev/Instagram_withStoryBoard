//
//  Api.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/24/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation

struct Api {
    static let post = PostApi()
    static let user = UserApi()
    static let comment = CommentApi()
    static let like = LikeApi()
    static let myPost = MyPostApi()
    static let storage = StorageApi()
    static let auth = AuthApi()
    static let follow = FollowApi()
    static let feed = FeedApi()
}

