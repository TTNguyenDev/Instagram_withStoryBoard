//
//  Alert .swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 12/29/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation
import SVProgressHUD

class CustomAlert {
    static func showSuccess(withMessage mess: String) {
        SVProgressHUD.showSuccess(withStatus: mess)
    }
    
    static func showError(withMessage mess: String) {
        SVProgressHUD.showError(withStatus: mess)
    }
    
    static func loadingAnimation() {
        SVProgressHUD.show()
    }
    
    static func stopAnimation() {
        SVProgressHUD.dismiss()
    }
    
    
}

