//
//  AppDelegate.swift
//  Swiftime
//
//  Created by Wladmir Júnior on 04/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit
import SwiftimeUI
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let frameworkBundle = Bundle(identifier: "com.wlad.Swiftime.SwiftimeUI")
        let storyboard = UIStoryboard(name: "Main", bundle: frameworkBundle)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
                
        return true
    }
}

