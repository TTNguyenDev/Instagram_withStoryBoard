//
//  HeaderProfileCollectionReusableView.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 12/28/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    
    func updateView() {
        Api.user.observeCurrentUser { (user) in
            self.userName.text = user.username
            if let photoUrlString = user.profile_image {
                CacheImage.cacheImageWithPlaceHolder(withUrl: photoUrlString, imageContainer: self.profileImage, placeHolderImage: #imageLiteral(resourceName: "Profile_Selected"))
            }
        }
    }
}
