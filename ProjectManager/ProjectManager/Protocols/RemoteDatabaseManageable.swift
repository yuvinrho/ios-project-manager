//
//  RemoteDatabaseManageable.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/30.
//

import FirebaseDatabase

protocol RemoteDatabaseManageable {
    associatedtype DataType: Encodable

    func create(data: DataType, completion: @escaping (Result<Bool, DatabaseError>) -> ())
    func read(completion: @escaping (Result<[DataType], DatabaseError>) -> ())
    func update(data: DataType, completion: @escaping (Result<Bool, DatabaseError>) -> ())
    func delete(data: DataType, completion: @escaping (Result<Bool, DatabaseError>) -> ())
    func isConnected(completion: @escaping (Bool) -> ())
}

extension RemoteDatabaseManageable {
    var connectedReference: DatabaseReference {
        return Database.database().reference(withPath: ".info/connected")
    }

    func isConnected(completion: @escaping (Bool) -> ()) {
        connectedReference.observe(.value) { snapshot in
            if snapshot.value as? Bool ?? false {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func create(data: DataType, completion: @escaping (Result<Bool, DatabaseError>) -> ()) {

    }

    func read(completion: @escaping (Result<[DataType], DatabaseError>) -> ()) {

    }

    func update(data: DataType, completion: @escaping (Result<Bool, DatabaseError>) -> ()) {

    }

    func delete(data: DataType, completion: @escaping (Result<Bool, DatabaseError>) -> ()) {
    
    }
}
