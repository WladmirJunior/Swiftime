//
//  TodayViewModel.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 17/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation
import SwiftimeDomain
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct FirebaseConstants {
    static let users = "users"
    static let days = "days"
    static let tasks = "tasks"
}

public class TodayViewModel {
    
    private let db = Firestore.firestore()
    public var items: [Task] = []
    
    public func createDayIfNotExist(_ uid: String, completion: @escaping (Day?) -> ()) {
        let tasksRef = db.collection(FirebaseConstants.users).document(uid)
            .collection(FirebaseConstants.days).document(Date().dateLikeId)
        
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
                    let day = Day(isDoingTask: false, day: Date().dateLikeId, tasksOfDay: nil, timeSpendInTasks: "00:00", timeInBreak: "00:00")
                    do {
                        try tasksRef.setData(from: day)
                        completion(day)
                    } catch let error { print(error) }
                }
            }
        }
    }
    
    public func getTasksOfDay(_ uid: String, completion: @escaping(Error?) -> Void) {
        self.items.removeAll()
        let tasksRef = db.collection(FirebaseConstants.users).document(uid)
            .collection(FirebaseConstants.days).document(Date().dateLikeId)
        tasksRef.getDocument { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
                completion(error)
            } else {
                let result = Result {
                    try querySnapshot?.data(as: Day.self)
                }
                switch result {
                case .success(let day):
                    if let day = day, let task = day.tasksOfDay {
                        self.items = task
                    }
                    completion(nil)
                case .failure(let error): completion(error)
                }
            }
        }
    }
    
    public func saveInFirestore(_ uid: String, _ isCounting: Bool, with task: Task, completion: @escaping(Error?) -> Void) {
        items.append(task)
        
        let taskRef = db.collection(FirebaseConstants.users).document(uid).collection(FirebaseConstants.days).document(Date().dateLikeId)
                
        taskRef.updateData(["isDoingTask": isCounting,
                            "day": Date().dateLikeId,
                            "tasks": FieldValue.arrayUnion([["dateTime": task.dateTime,
                                                             "text": task.text,
                                                             "type": task.type]])
                            ]) { error in
            if let error = error {
                completion(error)
                return
            }
        }
    }
}
