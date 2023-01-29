//
//  Project.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/17.
//

import Foundation

struct Project: Encodable, Hashable {
    let id: String
    var status: ProjectStatus
    var title: String
    var description: String
    var dueDate: Date

    init(id: String = UUID().uuidString,
         status: ProjectStatus,
         title: String,
         description: String,
         dueDate: Date) {
        self.id = id
        self.status = status
        self.title = title
        self.description = description
        self.dueDate = dueDate
    }
}

extension Project {
    var isDueDateExpired: Bool {
        return dueDate.isExpired
    }

    func toDTO() -> ProjectDTO {
        return ProjectDTO(id: self.id,
                          status: self.status,
                          title: self.title,
                          description: self.description,
                          dueDate: self.dueDate,
                          lastModifiedDate: Date())
    }
}
