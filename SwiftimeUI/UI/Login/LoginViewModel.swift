//
//  LoginViewModel.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 17/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI
import FirebaseFirestore

public class LoginViewModel {
    
    let fireinstance: FireInstance
    
    public init() {
        fireinstance = FireInstance.instance
    }
    
    public func login(with user: String, andPassword password: String, completion: @escaping(Bool, String?,  Error?) -> Void) {
        Auth.auth().signIn(withEmail: user, password: password) { [unowned self] authDataResult, error in
            guard let authDataResult = authDataResult  else {
                print(error!)
                return
            }
            
            let db = Firestore.firestore()
            
            db.collection("users").document(authDataResult.user.uid)
                .setData(["email": authDataResult.user.email!]) { (error) in
                if let error = error {
                    print("Error adding document: \(error)")
                    completion(false, nil, error)
                } else {
                    print("Document added with ID: \(authDataResult.user.uid)")
                    self.fireinstance.uid = authDataResult.user.uid
                    completion(true, authDataResult.user.uid, nil)
                }
            }
        }
    }
}

