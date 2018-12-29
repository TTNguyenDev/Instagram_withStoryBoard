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
    
}
