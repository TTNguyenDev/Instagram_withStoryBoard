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
            
            Api.post.likeOfPost(post: post!) { (posts) in
                self.updateLike(post: posts)
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
        
        if count == 0 {
            countLikes_label.text = "Be the first like this"
        }
        
        if count == 1 {
            countLikes_label.text = "\(count) like"
        }
        
        if count != 0 && count != 1 {
            countLikes_label.text = "\(count) likes"
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
    
    @objc fileprivate func likeTap() {
        Api.like.increaseLike(for: post!) { (posts) in
            self.updateLike(post: posts)
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
    }
}
