//
//  CacheImage.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 12/29/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation
import SDWebImage

class CacheImage {
    static func cacheImage(withUrl urlString: String, imageContainer img: UIImageView) {
        let url = URL(string: urlString)
        img.sd_setImage(with: url)
    }
    
    static func cacheImageWithPlaceHolder(withUrl urlString: String, imageContainer img: UIImageView, placeHolderImage imgPlaceholder: UIImage) {
        let url = URL(string: urlString)
        img.sd_setImage(with: url, placeholderImage: imgPlaceholder)
    }
}
