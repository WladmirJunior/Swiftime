//
//  UIViewController+Extensions.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 05/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String? = "", AndMessage message: String, completion: ((UIAlertAction) -> (Void))? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        self.present(alertViewController, animated: true, completion: nil)
    }
}
