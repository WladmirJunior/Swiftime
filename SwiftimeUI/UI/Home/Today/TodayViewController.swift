//
//  TodayViewController.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 04/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
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
    private var items: [Task] = []
    private var timer: Timer = Timer()
    private var timeInActivity: String?
    private var timeInBreak: String?
    let db = Firestore.firestore()
    
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
        createDayIfNotExist() { [weak self] day in
            guard let day = day else { return }
            self?.isCounting = day.isDoingTask
            self?.timeInActivity = day.timeSpendInTasks
            self?.timeInBreak = day.timeInBreak
            self?.updateButtonStatus()
            self?.showActivity()
        }
        getTasksOfDay()
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
        calcHoursInActivity()
    }
    
    @objc private func updateClock() {
        timeLabel.text = Date().timeWithSeconds
    }
    
    // MARK: - Private
    
    private func createDayIfNotExist(completion: @escaping (Day?) -> ()) {
        let tasksRef = db.collection("users").document(uid)
            .collection("days").document(Date().dateLikeId)
        
        tasksRef.getDocument { (document, error) in
            if let error = error {
                print(error)
                completion(nil)
            } else {
                if let document = document, document.exists {
                    let result = Result {
                        try document.data(as: Day.self)
                    }
                    switch result {
                    case .success(let day): completion(day)
                    case .failure(let error): print(error)
                    }
                } else {
                    let day = Day(isDoingTask: false, tasksOfDay: nil, timeSpendInTasks: "00:00", timeInBreak: "00:00")
                    do {
                        try tasksRef.setData(from: day)
                        completion(day)
                    } catch let error { print(error) }
                }
            }
        }
    }
    
    private func updateButtonStatus() {
        if isCounting {
            startButton.setTitle("Pausar", for: .normal)
        } else {
            startButton.setTitle("Iniciar", for: .normal)
        }
    }
    
    private func getTasksOfDay() {
        let tasksRef = db.collection("users").document(uid)
            .collection("days").document(Date().dateLikeId)
            .collection("tasks")
        tasksRef.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let result = Result {
                    try querySnapshot?.documents.compactMap {
                        try $0.data(as: Task.self)
                    }
                }
                switch result {
                case .success(let tasks):
                    if let tasks = tasks {
                        self.items = tasks
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let error): print(error)
                }
            }
        }
    }
    
    private func showActivity() {
        if let timeInActivity = timeInActivity, let timeInBreak = timeInBreak, timeInActivity != "00:00" && timeInBreak != "00:00" {
            timeInActivityLabel.text = "Em atividade: \(timeInActivity)"
            timeInBreakLabel.text = "Em pausa: \(timeInBreak)"
            stack.isHidden = false
        }
    }
    
    private func calcHoursInActivity() {
        if items.count > 0 {
            let inBreakList = items.filter { $0.type == "P" }
            if inBreakList.count > 0 {
                
                if let date = items[0].dateTime.toDate {
                    let actual = inBreakList[0].dateTime.toDate!.timeIntervalSinceReferenceDate
                   let oldTime = date.timeIntervalSinceReferenceDate
                   
                   let calculationTime = actual - oldTime
                   let dateResult = Date(timeIntervalSinceReferenceDate: calculationTime)
                   
                   timeInActivity = dateResult.time
                   timeInActivityLabel.text = "Em atividade: \(timeInActivity ?? "00:00")"
                   timeInBreakLabel.text = "Em pausa: \(timeInBreak ?? "00:00")"
                   self.stack.isHidden = false
               }
                
                
            } else {
                if let date = items[0].dateTime.toDate {
                    let actual = Date().timeIntervalSinceReferenceDate
                    let oldTime = date.timeIntervalSinceReferenceDate
                    
                    let calculationTime = actual - oldTime
                    let dateResult = Date(timeIntervalSinceReferenceDate: calculationTime)
                    
                    timeInActivity = dateResult.time
                    timeInActivityLabel.text = "Em atividade: \(timeInActivity ?? "00:00")"
                    timeInBreakLabel.text = "Em pausa: \(timeInBreak ?? "00:00")"
                    self.stack.isHidden = false
                }
            }
        }
        
//        let inActivityList = items.filter { $0.type == "S" }
//        for task in inActivityList  {
//
//        }
//
//        let inBreakList = items.filter { $0.type == "P" }
    }
    
    private func createStart() {
        let startText = "Atividade em \(Date().time)"
        let task = Task(text: startText, dateTime: Date().dateTime, type: "S")
        saveInFirestore(with: task)
    }
    
    private func createPause() {
        let pauseText = "Pausa em \(Date().time)"
        let task = Task(text: pauseText, dateTime: Date().dateTime, type: "P")
        saveInFirestore(with: task)
    }
    
    private func saveInFirestore(with task: Task) {
        items.append(task)
        tableView.reloadData()
        
        db.collection("users").document(uid)
            .collection("days").document(Date().dateLikeId).setData(["isDoingTask": isCounting]) { [unowned self] error in
            if let error = error {
                self.showAlert(AndMessage: "Aconteceu alguma coisa ao salvar suas informações, tente novamente!")
                print(error)
                return
            }
            do {
                try self.db.collection("users").document(self.uid)
                    .collection("days").document(Date().dateLikeId)
                    .collection("tasks").document().setData(from: task) { [weak self] error in
                        guard let self = self else { return }
                        if let error = error {
                            self.showAlert(AndMessage: "Aconteceu alguma coisa ao salvar suas informações, tente novamente!")
                            print("Error adding document: \(error)")
                        }
                }
            } catch let error {
                print("Error writing task to Firestore: \(error)")
            }
        }
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row].text
        return cell
    }
}
