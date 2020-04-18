//
//  LoginViewController.swift
//  Swiftime
//
//  Created by Wladmir Júnior on 04/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        
    }
    
    // MARK: - Actions

    @IBAction func loginTapped(_ sender: Any) {
        emailField.text = "o@gmail.com"
        passwordField.text = "123456"
        
        guard emailField.text != "", passwordField.text != "" else {
            showAlert(AndMessage: "Lembre-se de colocar seu email e sua senha para ter acesso ao Swiftime!")
            return
        }
        
        loginButton.isHidden = true
        activity.startAnimating()
        
        viewModel.login(with: emailField.text!, andPassword: passwordField.text!) { [weak self] sucess, uid, error in
            if error != nil {
                self?.showAlert(AndMessage: "Tivemos algum problema para acessar sua conta 😕\nPor favor, tente novamente em alguns instantes!")
                return
            }
            
            if sucess, let uid = uid {
                self?.emailField.text = ""
                self?.passwordField.text = ""
                self?.performSegue(withIdentifier: "login", sender: uid)
                self?.activity.stopAnimating()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigation = segue.destination as? UINavigationController,
        let tabController = navigation.topViewController as? UITabBarController,
        let viewController = tabController.viewControllers?[0] as? TodayViewController,
        let secondViewController = tabController.viewControllers?[1] as? HistoryViewController else { return }
        viewController.uid = sender as! String
        secondViewController.uid = sender as! String
    }
}
