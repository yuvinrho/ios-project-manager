//
//  ProjectResponseDTO.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/26.
//

import Foundation

struct ProjectDTO: Codable {
    let id: String
    let status: ProjectStatus
    let title: String
    let description: String
    let dueDate: Date
    let lastModifiedDate: Date
}

extension ProjectDTO {
    func toDomain() -> Project {
        return Project(id: self.id,
                       status: self.status,
                       title: self.title,
                       description: self.description,
                       dueDate: self.dueDate)
    }
}
