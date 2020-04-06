//
//  Task.swift
//  SwiftimeDomain
//
//  Created by Wladmir Edmar Silva Junior on 05/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation

public struct Task: Codable {
    public let text: String
    public let dateTime: String
    public let type: String
    
    public init(text: String, dateTime: String, type: String) {
        self.text = text
        self.dateTime = dateTime
        self.type = type
    }
    
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case dateTime = "dateTime"
        case type
    }
}
