//
//  AddTaskInteractor.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

import Foundation

final class AddTaskInteractor: AddTaskInteractorProtocol {
    weak var presenter: AddTaskPresenterProtocol?
    private let coreDataService: TodoCoreDataService
    
    init(coreDataService: TodoCoreDataService = .shared) {
        self.coreDataService = coreDataService
    }

    func saveTodo(title: String, description: String) {
        let id = Int64(Date().timeIntervalSince1970)
        
        let newTodo = TodoEntity(
            id: Int(id),
            title: title,
            description: description,
            date: Date(),
            isCompleted: false
        )
        
        coreDataService.addTodo(newTodo)
        presenter?.didSaveTodo(newTodo)
    }
}
