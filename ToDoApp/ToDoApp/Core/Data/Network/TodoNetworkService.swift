//
//  TodoNetworkService.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

import Foundation

struct TodoResponse: Codable {
    let todos: [TodoDTO]
}

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
}

enum NetworkError: Error {
    case invalidURL
    case noData
}


final class TodoNetworkService: TodoNetworkServiceProtocol{
    static let shared = TodoNetworkService()
    
    private init() {}
    
    func fetchTodos(completion: @escaping (Result<[TodoEntity], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)
                let todos = decoded.todos.map {
                    TodoEntity(
                        id: $0.id,
                        title: "Task \($0.id)",
                        description: $0.todo,
                        date: Date(),
                        isCompleted: $0.completed
                    )
                }
                completion(.success(todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
