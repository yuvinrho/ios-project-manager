//
//  HistoryManager.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/30.
//

import Foundation
import FirebaseDatabase

class HistoryManager: RemoteDatabaseManageable {
    typealias DataType = ProjectHistory

    private let reference = Database.database().reference(withPath: "histories")

    func create(data: ProjectHistory, completion: @escaping (Result<Bool, DatabaseError>) -> ()) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let json = try JSONSerialization.jsonObject(with: encodedData)
            reference.child(data.id).setValue(json) { (error, _ ) in
                if error != nil {
                    completion(.failure(.createFailedError))
                } else {
                    completion(.success(true))
                }
            }
        } catch ProjectError.encodingError {
            fatalError(ProjectError.encodingError.localizedDescription)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func read(completion: @escaping (Result<[ProjectHistory], DatabaseError>) -> ()) {
        reference.observeSingleEvent(of: .value) { snapshot  in
            guard let json = snapshot.value as? [String: Any] else {
                return completion(.success([]))
            }

            do {
                let data = try JSONSerialization.data(withJSONObject: Array(json.values))
                let response = try JSONDecoder().decode([ProjectHistory].self, from: data).sorted { $0.timestamp < $1.timestamp }
                completion(.success(response))
            } catch {
                print(error)
            }
        }
    }

    func delete(data: ProjectHistory, completion: @escaping (Result<Bool, DatabaseError>) -> ()) {
        reference.child(data.id).removeValue { error, ref in
            if error != nil {
                completion(.failure(.removeFailedError))
            } else {
                completion(.success(true))
            }
        }
    }
}
