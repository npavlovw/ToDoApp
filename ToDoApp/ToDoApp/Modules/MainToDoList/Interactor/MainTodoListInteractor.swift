//
//  MainTodoListInteractor.swift
//  ToDoApp
//
//  Created by Никита Павлов on 01.08.2025.
//

import Foundation

final class MainTodoListInteractor: MainTodoListInteractorProtocol {
    weak var output: MainTodoListInteractorOutput?
    
    func fetchTodos() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")

            if isFirstLaunch {
                TodoNetworkService.shared.fetchTodos { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let todos):
                            TodoCoreDataService.shared.saveTodos(todos)
                            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                            self?.output?.didFetchTodos(todos)
                        case .failure(let error):
                            print("Ошибка загрузки: \(error.localizedDescription)")
                            self?.output?.didFetchTodos([])
                        }
                    }
                }
            } else {
                let localTodos = TodoCoreDataService.shared.fetchTodos()
                DispatchQueue.main.async {
                    self?.output?.didFetchTodos(localTodos)
                }
            }
        }
    }
}
