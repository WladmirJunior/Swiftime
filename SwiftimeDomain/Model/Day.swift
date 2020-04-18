//
//  Day.swift
//  SwiftimeDomain
//
//  Created by Wladmir Edmar Silva Junior on 05/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation

public struct Day: Codable {
    public let isDoingTask: Bool
    public let day: String
    public let tasksOfDay: [Task]?
    public let timeSpendInTasks: String?
    public let timeInBreak: String?
    
    public init(isDoingTask: Bool, day: String, tasksOfDay: [Task]?, timeSpendInTasks: String?, timeInBreak: String?) {
        self.isDoingTask = isDoingTask
        self.day = day
        self.tasksOfDay = tasksOfDay
        self.timeSpendInTasks = timeSpendInTasks
        self.timeInBreak = timeInBreak
    }
    
    enum CodingKeys: String, CodingKey {
        case isDoingTask = "isDoingTask"
        case day
        case tasksOfDay = "tasks"
        case timeSpendInTasks = "timeSpend"
        case timeInBreak
    }
}
