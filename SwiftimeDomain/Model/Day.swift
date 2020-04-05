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
    public let tasksOfDay: [Task]?
    public let timeSpendInTasks: String?
    
    public init(isDoingTask: Bool, tasksOfDay: [Task]?, timeSpendInTasks: String?) {
        self.isDoingTask = isDoingTask
        self.tasksOfDay = tasksOfDay
        self.timeSpendInTasks = timeSpendInTasks
    }
    
    enum CodingKeys: String, CodingKey {
        case isDoingTask = "isDoingTask"
        case tasksOfDay = "tasks"
        case timeSpendInTasks = "timeSpend"
    }
}
