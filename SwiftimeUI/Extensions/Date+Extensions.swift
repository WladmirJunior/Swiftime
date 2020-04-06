//
//  Date+Extensions.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 05/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation

extension Date {
    public var dateTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
    
    public var dayWithMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM 'de' yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
    
    public var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
    
    public var timeWithSeconds: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
    
    public var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
    
    public var dateLikeId: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
}
