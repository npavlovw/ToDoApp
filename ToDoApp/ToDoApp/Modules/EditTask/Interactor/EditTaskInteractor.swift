//
//  EditTaskInteractor.swift
//  ToDoApp
//
//  Created by Никита Павлов on 04.08.2025.
//

final class EditTaskInteractor: EditTaskInteractorProtocol {
    weak var output: EditTaskInteractorOutputProtocol?
    let coreDataService = TodoCoreDataService.shared

    func updateTodo(_ todo: TodoEntity) {
        coreDataService?.updateTodo(todo)
        output?.todoDidUpdate()
    }
}
