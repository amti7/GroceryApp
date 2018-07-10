//
//  ViewController.swift
//  GroceryApp
//
//  Created by Kamil Gacek on 07.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
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
            guard let emailTextField = alert.textFields?[0] else { return }
            guard let passwordTextField = alert.textFields?[1] else { return }
            if let emailText = emailTextField.text {
                if let passwordText = passwordTextField.text {
                    self.userArray.append(User(uuid: 123414, email: emailText, password: passwordText))
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

