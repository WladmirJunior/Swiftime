//
//  SettingsViewModel.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 18/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI
import FirebaseFirestore

class SettingsViewModel {
    
    private let db = Firestore.firestore()
    let fireInstace = FireInstance.instance
    
    public func clearTodayFromFirebase(completion: @escaping((Error?) -> Void)) {
        let tasksRef = db.collection(FirebaseConstants.users).document(fireInstace.uid)
        .collection(FirebaseConstants.days).document(Date().dateLikeId)
        
        tasksRef.delete { error in
            if let error = error {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    public func clearAllDataFromFirebase(completion: @escaping((Error?) -> Void)) {
        let daysRef = db.collection(FirebaseConstants.users).document(fireInstace.uid)
        .collection(FirebaseConstants.days)
        
        daysRef.getDocuments { (querySnapshot, error) in
            for document in querySnapshot!.documents {
                document.reference.delete()
            }
        }
        completion(nil)
    }
    
    public func logOff(completion: @escaping((Error?) -> Void)) {
         do {
           try Auth.auth().signOut()
            completion(nil)
         } catch let signOutError as NSError {
           print ("Error signing out: %@", signOutError)
            completion(signOutError)
         }
    }
}
