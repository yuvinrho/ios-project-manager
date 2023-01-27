//
//  DatabaseError.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/28.
//

import Foundation

enum DatabaseError: LocalizedError {
    case createFailedError
    case readFailedError

    var createFailedError: String? {
        switch self {
        case .createFailedError:
            return "데이터베이스에 프로젝트 생성실패"
        case .readFailedError:
            return "데이터베이스에서 프로젝트를 읽어올 수 없음"
        }
    }
}
