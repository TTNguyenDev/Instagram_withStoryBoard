//
//  SignUpViewController.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var selectedImage: UIImage?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignUp_Label: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func SignUp_Button(_ sender: Any) {
        CustomAlert.stopAnimation()
        Api.auth.createUser(email: emailTextField.text!, password: passwordTextField.text!, onFail: { (error) in
            CustomAlert.showError(withMessage: error)
            return
        }) {
            CustomAlert.stopAnimation()
            self.saveDataBase()
            self.performSegue(withIdentifier: "TabSwitcher_id", sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    fileprivate func saveDataBase() {
        if let profileImg = self.selectedImage {
            Api.storage.saveDataForNewUser(image: profileImg.jpegData(compressionQuality: 0.1)!, username: nameTextField.text!, userEmail: emailTextField.text!) { (error) in
                CustomAlert.showError(withMessage: error)
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
        tapGestureForUIImageView()
        handleTextField()
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
