//
//  MainTodoListInteractor.swift
//  ToDoApp
//
//  Created by Никита Павлов on 01.08.2025.
//

import Foundation

final class MainTodoListInteractor: MainTodoListInteractorProtocol {
    weak var output: MainTodoListInteractorOutput?

    private let userDefaults: UserDefaults
    private let coreDataService: TodoCoreDataService
    private let networkService: TodoNetworkServiceProtocol

    init(userDefaults: UserDefaults = UserDefaults.standard,
         coreDataService: TodoCoreDataService = TodoCoreDataService.shared,
         networkService: TodoNetworkServiceProtocol = TodoNetworkService.shared) {
        self.userDefaults = userDefaults
        self.coreDataService = coreDataService
        self.networkService = networkService
    }
    
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
        !userDefaults.bool(forKey: "hasLaunchedBefore")
    }

    private func fetchRemoteTodos() {
        networkService.fetchTodos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todos):
                    self?.coreDataService.saveTodos(todos)
                    self?.userDefaults.set(true, forKey: "hasLaunchedBefore")
                    self?.output?.didFetchTodos(todos)
                case .failure(let error):
                    print("Ошибка загрузки: \(error.localizedDescription)")
                    self?.output?.didFetchTodos([])
                }
            }
        }
    }

    private func fetchLocalTodos() {
        let localTodos = coreDataService.fetchTodos()
        DispatchQueue.main.async { [weak self] in
            self?.output?.didFetchTodos(localTodos)
        }
    }
}
