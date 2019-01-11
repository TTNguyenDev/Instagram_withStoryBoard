//
//  Photos.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Photos: UIViewController, NVActivityIndicatorViewable {
    var selectedImage: UIImage?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var Share_Label: UIButton!
    
    @IBAction func cancelButton(_ sender: Any) {
        clean()
    }
    
    @IBAction func share_button(_ sender: Any) {
        saveDataBase()
    }
    
    @objc fileprivate func chooseProfileImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    fileprivate func handlePost() {
        if selectedImage != nil {
            Share_Label.isEnabled = true
            self.navigationItem.rightBarButtonItem!.isEnabled = true
            Share_Label.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        } else {
            Share_Label.isEnabled = false
            self.navigationItem.rightBarButtonItem!.isEnabled = false
            Share_Label.setTitleColor(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), for: .normal)
        }
    }
    
    fileprivate func tapGestureForUIImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        imagePost.addGestureRecognizer(tapGesture)
        imagePost.isUserInteractionEnabled = true
    }
    
    fileprivate func clean() {
        imagePost.image = #imageLiteral(resourceName: "Placeholder-image")
        selectedImage = nil
        caption.text = ""
        handlePost()
    }
    
    fileprivate func saveDataBase() {
        let size = CGSize(width: 50, height: 50)
        let indicatorType = NVActivityIndicatorType.init(rawValue: 26)
       startAnimating(size, message: "Loading...", messageFont: UIFont.systemFont(ofSize: 15), type: indicatorType, color: .orange, padding: 2, displayTimeThreshold: 2, minimumDisplayTime: 2, backgroundColor: .white, textColor: .orange, fadeInAnimation: nil)
        
        if let profileImg = self.selectedImage {
            Api.storage.saveUploadData(image: profileImg.jpegData(compressionQuality: 0.1)!, caption: caption.text, onFail: { (error) in
                CustomAlert.showError(withMessage: error)
            }) {
                NVActivityIndicatorPresenter.sharedInstance.setMessage("Successful")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.stopAnimating(nil)
                }
            }
            self.clean()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureForUIImageView()
    }
}

extension Photos: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imagePost.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
