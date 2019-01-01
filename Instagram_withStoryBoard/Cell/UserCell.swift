//
//  UserCellTableViewCell.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 1/1/19.
//  Copyright © 2019 TT Nguyen. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var followState: UIButton!
    
    var isFollow: Bool?
    
    var user: Users? {
        didSet {
            username.text = user?.username
            if let photoString = user?.profile_image {
                CacheImage.cacheImageWithPlaceHolder(withUrl: photoString, imageContainer: self.profileImage, placeHolderImage: #imageLiteral(resourceName: "Profile_Selected"))
                changeFollowButton()
            }
        }
    }
    
    func changeFollowButton(){
        Api.follow.status(withUID: user!.id!) { (status) in
            if status {
                self.followState.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                self.followState.setTitle("Following", for: .normal)
                self.isFollow = true
            } else {
                self.followState.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                self.followState.setTitle("Follow", for: .normal)
                self.isFollow = false
            }
        }
    }

    
    @IBAction func followButton(_ sender: Any) {
        if isFollow! {
            Api.follow.unfollow(withUID: user!.id!)
        } else {
            Api.follow.follow(withUID: user!.id!)
        }
        changeFollowButton()
    }
    
    
}
