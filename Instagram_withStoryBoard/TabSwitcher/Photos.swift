//
//  Photos.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class Photos: UIViewController {
    
    var selectedImage: UIImage?

    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var Share_Label: UIButton!
   
    @IBAction func cancelButton(_ sender: Any) {
        clean()
    }
    
    @IBAction func share_button(_ sender: Any) {
        saveDataBase()
    }
    
    fileprivate func clean() {
        imagePost.image = #imageLiteral(resourceName: "Placeholder-image")
        selectedImage = nil
        caption.text = ""
        handlePost()
    }
    
    fileprivate func saveDataBase() {
        SVProgressHUD.show()
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: "gs://instagramstoryboard.appspot.com").child("posts").child(photoIdString)
        let metaDataForImage = StorageMetadata()
        metaDataForImage.contentType = "image/jpeg"
        
        if let profileImg = self.selectedImage {
            storageRef.putData(profileImg.jpegData(compressionQuality: 0.1)!, metadata: metaDataForImage) { (metaData, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    return
                }
                
                _ = storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        return
                    }
                    let profileImageUrl = url?.absoluteString
                    let ref = Database.database().reference()
                    let postReference = ref.child("posts")
                    let newPostId = postReference.childByAutoId().key
                    let newPostReference = postReference.child(newPostId!)
                    let uid = Auth.auth().currentUser?.uid
                    newPostReference.setValue(["photoUrl": profileImageUrl, "caption": self.caption.text!, "uid": uid], withCompletionBlock: { (error, ref) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                            return
                        }
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        self.clean()
                    })
                })
            }
        }
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
    
    @objc fileprivate func chooseProfileImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
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
