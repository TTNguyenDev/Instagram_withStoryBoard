//
//  ImageCell.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 12/29/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCell: UICollectionViewCell {
    @IBOutlet var images: UIImageView!
    var post: Posts? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoUrl = post?.imageUrl {
            CacheImage.cacheImage(withUrl: photoUrl, imageContainer: images)
        }
    }
}
