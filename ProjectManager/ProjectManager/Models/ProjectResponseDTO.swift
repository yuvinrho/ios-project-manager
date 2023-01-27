//
//  ProjectResponseDTO.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/26.
//

import Foundation

struct ProjectResponseDTO: Decodable {
    let id: UUID
    let status: ProjectStatus
    let title: String
    let description: String
    let dueDate: Date
}

extension ProjectResponseDTO {
    func toDomain() -> Project {
        return Project(status: self.status,
                       title: self.title,
                       description: self.description,
                       dueDate: self.dueDate)
    }
}
