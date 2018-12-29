//
//  CommentCellTableViewCell.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/23/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import SDWebImage

class CommentCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    var comments: Comments? {
        didSet {
            commentText.text = comments?.comment
        }
    }
    
    var user: Users? {
        didSet {
            username.text = user?.username
            if let photoUrlString = user?.profile_image {
                let photoUrl = URL(string: photoUrlString)
                self.profileImage.sd_setImage(with: photoUrl, placeholderImage: #imageLiteral(resourceName: "Profile_Selected"))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
