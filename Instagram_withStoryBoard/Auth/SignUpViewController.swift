//
//  SignUpViewController.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var selectedImage: UIImage?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignUp_Label: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func SignUp_Button(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            SVProgressHUD.dismiss()
            self.saveDataBase()
            self.performSegue(withIdentifier: "TabSwitcher_id", sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clean()
    }
    
    fileprivate func clean() {
        emailTextField.text = ""
        passwordTextField.text = ""
        nameTextField.text = ""
        profileImage.image = #imageLiteral(resourceName: "icons8-user-male-480")
    }
    
    fileprivate func saveDataBase() {
        let uid = Auth.auth().currentUser?.uid
        
        let StorageRef = Storage.storage().reference(forURL: "gs://instagramstoryboard.appspot.com").child("profile_image").child(uid!)
        
        let metaDataForImage = StorageMetadata()
        metaDataForImage.contentType = "image/jpeg"
        
        if let profileImg = self.selectedImage {
            StorageRef.putData(profileImg.jpegData(compressionQuality: 0.1)!, metadata: metaDataForImage) { (metaData, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    return
                }
                
                _ = StorageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        return
                    }
                    let profileImageUrl = url?.absoluteString
                    let ref = Database.database().reference()
                    let userRef = ref.child("users")
                    
                    let newUserReference = userRef.child(uid!)
                    newUserReference.setValue(["username": self.nameTextField.text!, "email": self.emailTextField.text!, "profile_image": profileImageUrl])
                })
            }
        }
    }
    
    @objc fileprivate func handleTextFieldDidChanged() {
        guard let username = nameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, profileImage.image != #imageLiteral(resourceName: "icons8-user-male-480") else {
            SignUp_Label.isEnabled = false
            return
        }
        SignUp_Label.isEnabled = true
        SignUp_Label.tintColor = .white
    }
    
    @objc fileprivate func chooseProfileImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    fileprivate func handleTextField() {
        nameTextField.addTarget(self, action: #selector(handleTextFieldDidChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleTextFieldDidChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextFieldDidChanged), for: .editingChanged)
    }
    
    fileprivate func tapGestureForUIImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUp_Label.isEnabled = false
        handleTextField()
        
        tapGestureForUIImageView()
  
    }
    

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
