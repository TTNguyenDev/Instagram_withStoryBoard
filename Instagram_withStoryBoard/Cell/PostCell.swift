//
//  PostCell.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PostCell: UITableViewCell {
    
    var post: Posts? {
        didSet {
            caption.text = post?.caption
            if let photoUrlString = post?.imageUrl {
                CacheImage.cacheImage(withUrl: photoUrlString, imageContainer: postImage)
            }
            
            Api.post.POST_REF.child(post!.id!).observeSingleEvent(of: .value) { (snapShot) in
                if let dictionary = snapShot.value as? [String: Any] {
                    let post = Posts.transformPostPhoto(dictionary: dictionary as NSDictionary, key: snapShot.key)
                    self.updateLike(post: post)
                }
            }
            
            updateLike(post: post!)
            Api.post.POST_REF.child((post?.id)!).observe(.childChanged) { (snapShot) in
                self.countLikes_label.text = "\(snapShot.value!) likes"
            }
        }
    }
    var user: Users? {
        didSet {
            username.text = user?.username
            if let photoString = user?.profile_image {
                CacheImage.cacheImageWithPlaceHolder(withUrl: photoString, imageContainer: self.profileImage, placeHolderImage: #imageLiteral(resourceName: "Profile_Selected"))
            }
        }
    }
    var homeVC: Home?
    var postRef: DatabaseReference!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var like_Button: UIImageView!
    @IBOutlet weak var comment_button: UIImageView!
    @IBOutlet weak var share_button: UIImageView!
    @IBOutlet weak var countLikes_label: UILabel!
    @IBOutlet weak var caption: UILabel!
    
    func updateLike(post: Posts) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        like_Button.image = UIImage(named: imageName)
        guard let count = post.likesCount else {
            return
        }
        
        if count == 1 {
            countLikes_label.text = "\(count) like"
        }
        
        if count != 0 && count != 1 {
            countLikes_label.text = "\(count) likes"
        }
        
        if count == 0 {
            countLikes_label.text = "Be the first like this"
        }
    }
    
    fileprivate func tapGestureForComment() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(commentTap))
        comment_button.addGestureRecognizer(tapGesture)
        comment_button.isUserInteractionEnabled = true
    }
    
    fileprivate func tapGestureForLike() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTap))
        like_Button.addGestureRecognizer(tapGesture)
        like_Button.isUserInteractionEnabled = true
    }
    
    fileprivate func tapGestureForPostImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTap_DoubleGesture))
        tapGesture.numberOfTapsRequired = 2
        postImage.addGestureRecognizer(tapGesture)
        postImage.isUserInteractionEnabled = true
    }
    
    @objc fileprivate func likeTap() {
        postRef = Api.post.POST_REF.child(post!.id!)
        increaseLike(for: postRef)
    }
    
    @objc fileprivate func likeTap_DoubleGesture() {
        postRef = Api.post.POST_REF.child(post!.id!)
        increaseLike(for: postRef)
    }
    
    fileprivate func increaseLike(for ref: DatabaseReference) {
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
                self.updateLike(post: post)
            }
        }
    }
    
    @objc fileprivate func commentTap() {
        if let id = post?.id {
            homeVC?.performSegue(withIdentifier: "commentSegue", sender: id)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestureForComment()
        tapGestureForLike()
        tapGestureForPostImage()
    }
}
