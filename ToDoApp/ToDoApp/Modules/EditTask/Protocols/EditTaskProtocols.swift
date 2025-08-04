//
//  EditTaskProtocols.swift
//  ToDoApp
//
//  Created by Никита Павлов on 04.08.2025.
//

// EditTaskViewProtocol.swift
protocol EditTaskViewProtocol: AnyObject {
    func showTodo(_ todo: TodoEntity)
    func showValidationError(_ message: String)
    func showSaveSuccess()
}

// EditTaskPresenterProtocol.swift
protocol EditTaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String?, description: String?)
}

// EditTaskInteractorProtocol.swift
protocol EditTaskInteractorProtocol: AnyObject {
    func updateTodo(_ todo: TodoEntity)
}

protocol EditTaskInteractorOutputProtocol: AnyObject {
    func todoDidUpdate()
}

// EditTaskRouterProtocol.swift
protocol EditTaskRouterProtocol: AnyObject {
    func dismiss()
}
