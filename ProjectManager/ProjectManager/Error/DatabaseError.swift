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
    case updateFailedError
    case removeFailedError
    case connectFailedError

    var errorDescription: String? {
        switch self {
        case .createFailedError:
            return "데이터베이스에 프로젝트 생성실패"
        case .readFailedError:
            return "데이터베이스에서 프로젝트를 읽어올 수 없음"
        case .updateFailedError:
            return "데이터베이스에서 프로젝트 업데이트 실패"
        case .removeFailedError:
            return "데이터베이스에서 프로젝xm 삭제 실패"
        case .connectFailedError:
            return "인터넷에 연결할 수 없음"
        }
    }
}
