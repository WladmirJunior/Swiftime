//
//  FireInstance.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 18/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation
import Firebase

public class FireInstance {
    
    public static let instance = FireInstance()
    public var uid: String = ""
    
    private init() {
        FirebaseApp.configure()
    }
}
