//
//  ViewController.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SignInViewController: UIViewController {
    //Testing smartGit to clone project

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SignIn_Outlet: UIButton!
    @IBAction func SignIn_Button(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: PasswordTextField.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "signIn_id", sender: nil)
            SVProgressHUD.dismiss()
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "signIn_id", sender: nil)
        }
        clean()
    }
    
    fileprivate func clean() {
        emailTextField.text = ""
        PasswordTextField.text = ""
    }
    
    fileprivate func handleTextField() {
        emailTextField.addTarget(self, action: #selector(handleTextFieldDidChanged), for: .editingChanged)
        PasswordTextField.addTarget(self, action: #selector(handleTextFieldDidChanged), for: .editingChanged)
    }
    
    @objc fileprivate func handleTextFieldDidChanged() {
        guard let email = emailTextField.text, !email.isEmpty, let password = PasswordTextField.text, !password.isEmpty else {
            return
        }
        SignIn_Outlet.isEnabled = true
        SignIn_Outlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignIn_Outlet.isEnabled = false
        handleTextField()
    }


}

