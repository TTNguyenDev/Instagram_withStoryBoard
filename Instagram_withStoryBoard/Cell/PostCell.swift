//
//  PostCell.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import SDWebImage

class PostCell: UITableViewCell {
    
    var post: Posts? {
        didSet {
            caption.text = post?.caption
            if let photoUrlString = post?.imageUrl {
                let photoUrl = URL(string: photoUrlString)
                postImage.sd_setImage(with: photoUrl, placeholderImage: #imageLiteral(resourceName: "Placeholder-image"))
            }
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var like_Button: UIImageView!
    @IBOutlet weak var comment_button: UIImageView!
    @IBOutlet weak var share_button: UIImageView!
    @IBOutlet weak var countLikes_label: UILabel!
    @IBOutlet weak var caption: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}
