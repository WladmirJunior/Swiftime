//
//  LoginViewController.swift
//  Swiftime
//
//  Created by Wladmir Júnior on 04/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        FirebaseApp.configure()
    }
    
    // MARK: - Actions

    @IBAction func loginTapped(_ sender: Any) {
        
        emailField.text = "wlad@gmail.com"
        passwordField.text = "123456"
        
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
            
            let db = Firestore.firestore()
                        
            db.collection("users").document(authDataResult.user.uid)
                .setData(["email": authDataResult.user.email!]) { (error) in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with ID: \(authDataResult.user.uid)")
                    self?.performSegue(withIdentifier: "login", sender: authDataResult.user.uid)
                }
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigation = segue.destination as? UINavigationController,
        let tabController = navigation.topViewController as? UITabBarController,
        let viewController = tabController.viewControllers?[0] as? TodayViewController else { return }
        viewController.uid = sender as! String
    }
}
