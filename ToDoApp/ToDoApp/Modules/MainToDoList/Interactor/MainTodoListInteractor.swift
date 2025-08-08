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
            if self?.isFirstLaunch() == true {
                self?.fetchRemoteTodos()
            } else {
                self?.fetchLocalTodos()
            }
        }
    }

    private func isFirstLaunch() -> Bool {
        !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }

    private func fetchRemoteTodos() {
        TodoNetworkService.shared.fetchTodos { [weak self] result in
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
    }

    private func fetchLocalTodos() {
        let localTodos = TodoCoreDataService.shared.fetchTodos()
        DispatchQueue.main.async { [weak self] in
            self?.output?.didFetchTodos(localTodos)
        }
    }
}
