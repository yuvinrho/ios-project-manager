//
//  CRUDable.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/17.
//

protocol CRUDable {
    associatedtype DataType

    func create(data: DataType, completion: @escaping (Result<Bool, Error>) -> ())
    func read(completion: @escaping (Result<[DataType], Error>) -> ())
    func update(data: DataType)
    func delete(data: DataType)
}
