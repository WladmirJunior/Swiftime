//
//  TodayViewController.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 04/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit
import SwiftimeDomain

class TodayViewController: UIViewController {

    // MARK: - UI
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var timeInActivityLabel: UILabel!
    @IBOutlet weak var timeInBreakLabel: UILabel!
    
    public var uid: String = ""
    
    // MARK: - Properties
    
    private var isCounting = false
    private var timer: Timer = Timer()
    private var timeInActivity: String?
    private var timeInBreak: String?
    private let viewModel = TodayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayLabel.text = Date().dayOfWeek.localizedCapitalized
        dateLabel.text = Date().dayWithMonth.localizedCapitalized
        timeLabel.text = Date().timeWithSeconds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
        viewModel.createDayIfNotExist(uid) { [weak self] day in
            guard let day = day else { return }
            self?.isCounting = day.isDoingTask
            self?.timeInActivity = day.timeSpendInTasks
            self?.timeInBreak = day.timeInBreak
            self?.updateButtonStatus()
            self?.showActivity()
        }
        viewModel.getTasksOfDay(uid) { [weak self] error in
            if let _ = error {
                self?.showAlert(AndMessage: "Tivemos um problema para pegar suas informações 😕\nPor favor, tente novamente em alguns instantes!")
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        timer.invalidate()
    }
    
    // MARK: - Actions
    
    @IBAction func actionTapped(_ sender: Any) {
        isCounting = !isCounting
        isCounting ? createStart() : createPause()
        updateButtonStatus()
    }
    
    @objc private func updateClock() {
        timeLabel.text = Date().timeWithSeconds
    }
    
    // MARK: - Private
    
    private func updateButtonStatus() {
        if isCounting {
            startButton.setImage(UIImage(named: "stop"), for: .normal)
        } else {
            startButton.setImage(UIImage(named: "start"), for: .normal)
        }
    }
    
    private func showActivity() {
        if let timeInActivity = timeInActivity, let timeInBreak = timeInBreak, timeInActivity != "00:00" && timeInBreak != "00:00" {
            timeInActivityLabel.text = "Em atividade: \(timeInActivity)"
            timeInBreakLabel.text = "Em pausa: \(timeInBreak)"
            stack.isHidden = false
        }
    }
    
    private func createStart() {
        let startText = "Atividade em \(Date().time)"
        let task = Task(text: startText, dateTime: Date().dateTime, type: "S")
        saveTask(task)
    }
    
    private func createPause() {
        let pauseText = "Pausa em \(Date().time)"
        let task = Task(text: pauseText, dateTime: Date().dateTime, type: "P")
        saveTask(task)
    }
    
    private func saveTask(_ task: Task) {
        viewModel.saveInFirestore(uid, isCounting, with: task) { [weak self] error in
            if let error = error {
                self?.showAlert(AndMessage: "Tivemos um problema ao salvar suas informações, tente novamente!")
                print(error)
                return
            }
        }
        tableView.reloadData()
        scrollToBottom()
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.viewModel.items.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.items[indexPath.row].text
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
}
