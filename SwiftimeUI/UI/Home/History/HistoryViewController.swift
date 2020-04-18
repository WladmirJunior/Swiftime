//
//  HistoryViewController.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 18/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    // MARK: UI
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    public var uid: String = ""
    
    let viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        viewModel.loadAllTasks(uid) { [weak self] error in
            if let _ = error {
                self?.showAlert(AndMessage: "Tivemos um problema para pegar suas informações 😕\nPor favor, tente novamente em alguns instantes!")
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.items[section].tasksOfDay?.count ?? 0 == 0 {
            return 1
        } else {
            return viewModel.items[section].tasksOfDay?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        cell.textLabel?.numberOfLines = 0
        
        if viewModel.items[indexPath.section].tasksOfDay?.count ?? 0 > 0 {
            cell.textLabel?.text = viewModel.items[indexPath.section].tasksOfDay![indexPath.row].text
        } else {
            cell.textLabel?.text = "Não existe registo de atividades para este dia."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = HeaderViewCell(frame: .zero)
        cell.titleLabel.text = viewModel.items[section].day
        return cell
    }
}
