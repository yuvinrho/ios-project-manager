//
//  ProjectError.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/26.
//

import Foundation

enum ProjectError: LocalizedError {
    case encodingError
    case decodingError

    var errorDescription: String? {
        switch self {
        case .encodingError:
            return "인코딩 에러"
        case .decodingError:
            return "디코딩 에러"
        }
    }
}
