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
    
    public var uid: String = ""
    
    // MARK: - Properties
    
    private var isCounting = false
    private var items: [Task] = []
    private var timer: Timer = Timer()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayLabel.text = Date().dayOfWeek.localizedCapitalized
        dateLabel.text = Date().dayWithMonth.localizedCapitalized
        timeLabel.text = Date().timeWithSeconds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
        createDayIfNotExist() { day in
        
        }
        getTasksOfDay()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    // MARK: - Actions
    
    @IBAction func actionTapped(_ sender: Any) {
        if isCounting {
            startButton.setTitle("Iniciar", for: .normal)
            createPause()
        } else {
            startButton.setTitle("Pausar", for: .normal)
            createStart()
        }
        
        isCounting = !isCounting
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
                    let day = Day(isDoingTask: false, tasksOfDay: nil, timeSpendInTasks: "00:00")
                    do {
                        try tasksRef.setData(from: day)
                        completion(day)
                    } catch let error { print(error) }
                }
            }
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
    
    private func createStart() {
        let startText = "Atividade iniciada em \(Date().time)"
        let task = Task(text: startText, dateTime: Date().datePTBR)
        saveInFirestore(with: task)
    }
    
    private func createPause() {
        let pauseText = "Atividade pausada em \(Date().time)"
        let task = Task(text: pauseText, dateTime: Date().datePTBR)
        saveInFirestore(with: task)
    }
    
    private func saveInFirestore(with task: Task) {
        do {
            try db.collection("users").document(uid)
                .collection("days").document(Date().dateLikeId)
                .collection("tasks").document().setData(from: task) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        self.items.append(task)
                        self.tableView.reloadData()
                    }
            }
        } catch let error {
            print("Error writing task to Firestore: \(error)")
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
