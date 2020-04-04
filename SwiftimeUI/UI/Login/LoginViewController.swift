//
//  LoginViewController.swift
//  Swiftime
//
//  Created by Wladmir Júnior on 04/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        
    }
    
    // MARK: - Actions

    @IBAction func loginTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "login", sender: nil)
        
        guard let email = emailField.text, let password = passwordField.text else {
            print("Fill all fields!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authDataResult, error in
            guard let authDataResult = authDataResult  else {
                print(error!)
                return
            }
            
            self?.emailField.text = ""
            self?.passwordField.text = ""
            
            print(authDataResult.user.uid)
            print(authDataResult.user.email ?? "")
            
            self?.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    func createUser() {
        guard let email = emailField.text, let password = passwordField.text else {
            print("Fill all fields!")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            guard let authDataResult = authDataResult  else {
                print(error!)
                return
            }
            
            print(authDataResult.user.uid)
            print(authDataResult.user.email ?? "")
        }
    }
}
