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
    
    var userArray: [User] = []
    
    override func viewDidLoad() {
        roundTheButton(buttonToRound: loginButton)
        roundTheButton(buttonToRound: signUpButton)
        
        super.viewDidLoad()
    }

    @IBAction func didClickedSignUp(_ sender: Any) {
    
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
            
            Auth.auth().createUser(withEmail: emailString, password: passwordString)
        
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

