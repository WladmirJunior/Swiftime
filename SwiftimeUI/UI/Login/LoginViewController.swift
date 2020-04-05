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
        guard emailField.text != "", passwordField.text != "" else {
            showAlert(AndMessage: "Lembre-se de colocar seu email e sua senha para ter acesso ao Swiftime!")
            return
        }
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authDataResult, error in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigation = segue.destination as? UINavigationController,
        let tabController = navigation.topViewController as? UITabBarController,
        let viewController = tabController.viewControllers?[0] as? TodayViewController else { return }
        viewController.uid = sender as! String
    }
}
