//
//  ProjectHistory.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/29.
//

import Foundation

struct ProjectHistory: Codable, Hashable {
    let id: String
    let history: String
    let timestamp: Date

    init(id: String = UUID().uuidString, history: String, timestamp: Date = Date()) {
        self.id = id
        self.history = history
        self.timestamp = timestamp
    }
}
