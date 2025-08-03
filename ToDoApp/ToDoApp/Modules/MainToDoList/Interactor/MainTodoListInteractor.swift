//
//  MainTodoListInteractor.swift
//  ToDoApp
//
//  Created by Никита Павлов on 01.08.2025.
//

import Foundation

protocol MainTodoListInteractorOutput: AnyObject {
    func didFetchTodos(_ todos: [TodoEntity])
}

final class MainTodoListInteractor: MainTodoListInteractorProtocol {
    weak var output: MainTodoListInteractorOutput?
    
    func fetchTodos() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let localTodos = TodoCoreDataService.shared.fetchTodos()
            
            if !localTodos.isEmpty {
                DispatchQueue.main.async {
                    self?.output?.didFetchTodos(localTodos)
                }
            } else {
                TodoNetworkService.shared.fetchTodos { [ weak self ] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let todos):
                            self?.output?.didFetchTodos(todos)
                        case .failure(let error):
                            print("Ошибка загрузки: \(error.localizedDescription)")
                            self?.output?.didFetchTodos([])
                        }
                    }
                }
            }
        }
    }
}
