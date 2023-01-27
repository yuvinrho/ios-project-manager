//
//  DatabaseManager.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/26.
//

import FirebaseDatabase

struct DatabaseManager: CRUDable {
    typealias DataType = Project

    private let reference = Database.database().reference().child("projects")

    func create(data: Project, completion: @escaping (Result<Bool, Error>) -> ()) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let json = try JSONSerialization.jsonObject(with: encodedData)

            reference.childByAutoId().setValue(json) { (error, _ ) in
                if error != nil {
                    completion(.failure(DatabaseError.createFailedError))
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

    func read(completion: @escaping (Result<[Project], Error>) -> ()) {
        reference.observeSingleEvent(of: .value) { snapshot  in
            guard let json = snapshot.value as? [String: Any] else {
                return completion(.failure(DatabaseError.createFailedError))
            }

            do {
                let data = try JSONSerialization.data(withJSONObject: Array(json.values))
                let response = try JSONDecoder().decode([ProjectResponseDTO].self, from: data)

                completion(.success(response.map { $0.toDomain() }))
            } catch {
                fatalError(ProjectError.decodingError.localizedDescription)
            }
        }
    }

    func read(status: ProjectStatus, completion: @escaping (Result<[Project], Error>) -> ()) {
        reference.queryOrdered(byChild: "status").queryEqual(toValue: status.rawValue).observeSingleEvent(of: .value) { snapshot  in
            guard let json = snapshot.value as? [String: Any] else {
                return completion(.failure(DatabaseError.createFailedError))
            }

            do {
                let data = try JSONSerialization.data(withJSONObject: Array(json.values))
                let response = try JSONDecoder().decode([ProjectResponseDTO].self, from: data)

                completion(.success(response.map { $0.toDomain() }))
            } catch {
                fatalError(ProjectError.decodingError.localizedDescription)
            }
        }
    }

    func update(data item: Project) {
        fatalError()
    }

    func delete(data item: Project) {
        fatalError()
    }
}
