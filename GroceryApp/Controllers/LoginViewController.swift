//
//  ViewController.swift
//  GroceryApp
//
//  Created by Kamil Gacek on 07.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var userLoginTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    let loginToList = "LoginToList"
    
    override func viewDidLoad() {
        roundTheButton(buttonToRound: loginButton)
        roundTheButton(buttonToRound: signUpButton)
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth , user in
            if user != nil {
                guard let user = user else { return }
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
                self.userLoginTextField.text = nil
                self.userPasswordTextField.text = nil
            }
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Sign In Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func didClickLogIn(_ sender: Any) {
        guard
            let email = userLoginTextField.text,
            let password = userPasswordTextField.text,
            email.count > 0,
            password.count > 3,
            email.contains("@")
            else {
              showAlert(message: "Your email or password does not meeet requirements")
              return
        }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func didClickSignUp(_ sender: Any) {
        let alert = UIAlertController(title: "Creating New User", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Email"
        }
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Pasword"
        }
    
        let saveAction = UIAlertAction(title: "Sign Up", style: .default){  _ in
            guard let emailTextField = alert.textFields?[0], let passwordTextField = alert.textFields?[1] else { return }
            
            guard let emailString = emailTextField.text, let passwordString = passwordTextField.text else { return }
            
            Auth.auth().createUser(withEmail: emailString, password: passwordString)  { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: emailString, password: passwordString)
                }
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func roundTheButton(buttonToRound: UIButton){
        buttonToRound.layer.cornerRadius = 10
        buttonToRound.clipsToBounds = true
    }
}

