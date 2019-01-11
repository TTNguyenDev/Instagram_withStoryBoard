//
//  Alert .swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 12/29/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import Foundation
import SVProgressHUD
import NVActivityIndicatorView

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
    
    static func showAlert(withMessage mess: String) {
        SVProgressHUD.showInfo(withStatus: mess)
    }
    
    static func stopAnimation() {
        SVProgressHUD.dismiss()
    }
    
//    static func loadingAnimationWithNVActivityIndicator(vc: UIViewController) {
//        let size = CGSize(width: 30, height: 30)
//        let indicatorType = NVActivityIndicatorType.init(rawValue: 8)
//        vc.startAnimating(size, message: "Loading...", messageFont: UIFont.boldSystemFont(ofSize: 20), type: indicatorType, color: .red, padding: 2, displayTimeThreshold: 2, minimumDisplayTime: 2, backgroundColor: .white, textColor: .red, fadeInAnimation: nil)
//        
//    }
    
    
}

