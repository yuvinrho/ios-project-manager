//
//  DatabaseManager.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/26.
//

import FirebaseDatabase

class DatabaseManager: RemoteDatabaseManageable {
    private let reference = Database.database().reference(withPath: "projects")

    func create(data: Project, completion: @escaping (Result<Bool, DatabaseError>) -> ()) {
        do {
            let encodedData = try JSONEncoder().encode(data.toDTO())
            let json = try JSONSerialization.jsonObject(with: encodedData)
            reference.child(data.id).setValue(json) { (error, ref ) in
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

    func read(status: ProjectStatus? = nil, completion: @escaping (Result<[Project], DatabaseError>) -> ()) {
        let reference = status == nil ? reference : reference.queryOrdered(byChild: "status").queryEqual(toValue: status?.rawValue)

        reference.observeSingleEvent(of: .value) { snapshot  in
            guard let json = snapshot.value as? [String: Any] else {
                return completion(.success([]))
            }

            do {
                let data = try JSONSerialization.data(withJSONObject: Array(json.values))
                let response = try JSONDecoder()
                    .decode([ProjectDTO].self, from: data)
                    .sorted { $0.lastModifiedDate < $1.lastModifiedDate }
                completion(.success(response.map { $0.toDomain() }))
            } catch {
                print(error)
            }
        }
    }

    func update(data: Project, completion: @escaping (Result<Bool, DatabaseError>) -> ()) {
        do {
            let encodedData = try JSONEncoder().encode(data.toDTO())
            let json = try JSONSerialization.jsonObject(with: encodedData)

            reference.child(data.id).setValue(json) { (error, _ ) in
                if error != nil {
                    completion(.failure(.updateFailedError))
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

    func delete(data: Project, completion: @escaping (Result<Bool, DatabaseError>) -> ()) {
        reference.child(data.id).removeValue { error, _ in
            if error != nil {
                completion(.failure(.removeFailedError))
            } else {
                completion(.success(true))
            }
        }
    }
}
