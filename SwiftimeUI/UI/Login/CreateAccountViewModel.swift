//
//  CreateAccountViewModel.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 17/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation
import FirebaseUI

public class CreateAccountViewModel {
    
    public func createUser(with user: String, andPassword password: String, completion: @escaping(Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: user, password: password) { authDataResult, error in
            guard let error = error  else {
                completion(true, nil)
                return
            }
            completion(false, error)
        }
    }
}
