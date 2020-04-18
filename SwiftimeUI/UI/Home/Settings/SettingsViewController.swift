//
//  SettingsViewController.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 13/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Ajustes"
    }
    
    // MARK: - ACTIONS
       
    @IBAction func clearDataToday(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Apagar dados de hoje?", message: "Todos os dados de hoje serão perdidos!", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Apagar", style: .destructive) { [unowned self] action in
            self.viewModel.clearTodayFromFirebase { error in
                if error != nil {
                    self.showAlert(AndMessage: "Erro ao limpar seus dados de hoje 😕\nPor favor, tente novamente em alguns instantes!")
                    return
                }
            }
        })
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func clearAllData(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Apagar todos os dados?", message: "Todos os seus dados serão perdidos!", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Apagar", style: .destructive) { [unowned self] action in
            self.viewModel.clearAllDataFromFirebase { error in
                if error != nil {
                    self.showAlert(AndMessage: "Erro ao limpar seus dados 😕\nPor favor, tente novamente em alguns instantes!")
                    return
                }
            }
        })
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func logoff(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Sair?", message: "Quer mesmo sair do aplicativo?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Sair", style: .destructive) { [unowned self] action in
            self.viewModel.logOff { error in
                if error != nil {
                    self.showAlert(AndMessage: "Erro ao sair 😕\nPor favor, tente novamente em alguns instantes!")
                    return
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showLogin", sender: nil)
                    self.navigationController?.popToRootViewController(animated: false)
                }
            }
        })
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
}
