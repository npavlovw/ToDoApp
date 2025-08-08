//
//  EditTaskProtocols.swift
//  ToDoApp
//
//  Created by Никита Павлов on 04.08.2025.
//

protocol EditTaskViewProtocol: AnyObject {
    func showTodo(_ todo: TodoEntity)
    func showValidationError(_ message: String)
    func showSaveSuccess()
}

protocol EditTaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String?, description: String?)
}

protocol EditTaskInteractorProtocol: AnyObject {
    func updateTodo(_ todo: TodoEntity)
}

protocol EditTaskInteractorOutputProtocol: AnyObject {
    func todoDidUpdate()
}

protocol EditTaskRouterProtocol: AnyObject {
    func dismiss()
}
