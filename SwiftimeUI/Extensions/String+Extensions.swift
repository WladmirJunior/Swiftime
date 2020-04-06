//
//  String+Extensions.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 06/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation

extension String {
    
    public func toDateFormat(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date
    }

    public var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)
        return date
    }
}
