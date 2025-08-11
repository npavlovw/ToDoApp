//
//  TodoNetworkServiceProtocol.swift
//  ToDoApp
//
//  Created by Никита Павлов on 11.08.2025.
//

import Foundation

protocol TodoNetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoEntity], Error>) -> Void)
}
