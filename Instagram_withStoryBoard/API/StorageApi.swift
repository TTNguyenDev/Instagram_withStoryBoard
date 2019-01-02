//
//  StorageApi.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 12/29/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageApi {
    let STORAGE_REF = Storage.storage().reference()
    
    func saveUploadData(image: Data, caption cap: String,  onFail: @escaping (String) -> Void ) {
        let photoIdString = NSUUID().uuidString
        
        let storageRef = STORAGE_REF.child("posts").child(photoIdString)
        let metaDataForImage = StorageMetadata()
        metaDataForImage.contentType = "image/jpeg"
        
        storageRef.putData(image, metadata: metaDataForImage) { (metaData, error) in
            if error != nil {
                onFail((error?.localizedDescription)!)
                return
            }
            
            _ = storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    onFail((error?.localizedDescription)!)
                    return
                }
                let profileImageUrl = url?.absoluteString
                let postReference = Api.post.POST_REF
                let newPostId = postReference.childByAutoId().key
                let newPostReference = postReference.child(newPostId!)
                let uid = Api.user.CURRENT_USER!.uid
                newPostReference.setValue(["photoUrl": profileImageUrl!, "caption": cap, "uid": uid, "likesCount": 0], withCompletionBlock: { (error, ref) in
                    if error != nil {
                        onFail((error?.localizedDescription)!)
                        return
                    }
                    Api.myPost.saveYourOwnPostToMyPost(with: newPostId!)
                    Api.feed.saveYourOwnPostToFeed(with: newPostId!)
                })
            })
        }
    }
    
    func saveDataForNewUser(image: Data, username name: String, userEmail mail: String, onFail: @escaping (String) -> Void) {
        let uid = Api.user.CURRENT_USER?.uid
        let StorageRef = STORAGE_REF.child("profile_image").child(uid!)
        let metaDataForImage = StorageMetadata()
        metaDataForImage.contentType = "image/jpeg"
        
        StorageRef.putData(image, metadata: metaDataForImage) { (metaData, error) in
            if error != nil {
                onFail((error?.localizedDescription)!)
                return
            }
            
            _ = StorageRef.downloadURL(completion: { (url, errors) in
                if errors != nil {
                    onFail((errors?.localizedDescription)!)
                    return
                }
                let profileImageUrl = url?.absoluteString
                let ref = Api.user.USER_REF
                
                let newUserReference = ref.child(uid!)
                newUserReference.setValue(["username": name, "email": mail, "profile_image": profileImageUrl])
            })
        }
    }
}


