//
//  HistoryViewModel.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 18/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation
import SwiftimeDomain
import FirebaseFirestore
import FirebaseFirestoreSwift

public class HistoryViewModel {
    
    private let db = Firestore.firestore()
    public var items: [Day] = []
    
    public func loadAllTasks(_ uid: String, completion: @escaping(Error?) -> Void) {
        let tasksRef = db.collection(FirebaseConstants.users).document(uid)
            .collection(FirebaseConstants.days)
        
        tasksRef.getDocuments { (document, error) in
            if let error = error {
                print(error)
                completion(nil)
            } else {
                let result = Result {
                    try document?.documents.compactMap {
                        try $0.data(as: Day.self)
                    }
                }
                switch result {
                case .success(let days):
                    if let days = days {
                        self.items = days
                        completion(nil)
                    }
                case .failure(let error): completion(error)
                }
            }
        }
    }
}
