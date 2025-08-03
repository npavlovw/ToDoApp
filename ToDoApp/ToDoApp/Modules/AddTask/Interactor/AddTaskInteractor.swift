//
//  AddTaskInteractor.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

import Foundation

final class AddTaskInteractor: AddTaskInteractorProtocol {
    weak var presenter: AddTaskPresenter?
    var coreDataService = TodoCoreDataService.shared

    func saveTodo(title: String, description: String) {
        let id = Int64(Date().timeIntervalSince1970)
        let date = Date()
        
        let newTodo = TodoEntity(
            id: Int(id),
            title: title,
            description: description,
            date: date,
            isCompleted: false
        )
        
        coreDataService.addTodo(newTodo)
        presenter?.didSaveTodo(newTodo)
    }
}
