//
//  TodayViewController.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 04/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    // MARK: - UI
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Properties
    
    var isCounting = false
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func actionTapped(_ sender: Any) {
        if isCounting {
            startButton.setTitle("Iniciar", for: .normal)
            createStart()
        } else {
            startButton.setTitle("Pausar", for: .normal)
            createPause()
        }
        
        isCounting = !isCounting
    }
    
    // MARK: - Private
    
    private func createStart() {
        let startText = "Atividade iniciada em \(Date().timePTBR)"
        items.append(startText)
        tableView.reloadData()
    }
    
    private func createPause() {
        let startText = "Atividade pausada em \(Date().timePTBR)"
        items.append(startText)
        tableView.reloadData()
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

extension Date {
    public var datePTBR: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
    
    public var timePTBR: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
}
