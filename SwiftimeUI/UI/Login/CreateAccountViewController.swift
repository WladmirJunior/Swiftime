//
//  CreateAccountViewController.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 05/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit

public class CreateAccountViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    
    private let viewModel = CreateAccountViewModel()
    
    public override func viewDidLoad() {
        
    }
    
    // MARK: - Actions
    @IBAction func createAccount(_ sender: Any) {
        guard emailField.text != "", passField.text != "", confirmPassField.text != "" else {
            showAlert(AndMessage: "Precisamos dessa informação, não desanime, são apenas 3 campos! 😅")
            return
        }
        
        guard passField.text ==  confirmPassField.text else {
            showAlert(AndMessage: "Você pode escolher a primera ou a segunda senha, mas você precisa preencher a mesma senha nos dois campos!")
            return
        }
        
        guard passField.text!.count >= 6 else {
            showAlert(AndMessage: "Sua senha está muito curta, crie uma senha mais forte com pelo menos 6 dígitos!")
            return
        }
        
        viewModel.createUser(with: emailField.text!, andPassword: passField.text!) { (sucess, error) in
            guard let error = error  else {
                DispatchQueue.main.async {
                    self.showAlert(withTitle: "Muito bem!!!", AndMessage: "Agora você parte do Swiftime!") { action in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                return
            }
            self.showAlert(AndMessage: "Tivemos algum problema para criar sua conta 😕\nPor favor, tente novamente em alguns instantes!")
            print(error)
        }
    }
}
