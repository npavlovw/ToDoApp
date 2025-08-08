//
//  AddTaskProtocols.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

// MARK: - View
protocol AddTaskViewProtocol: AnyObject {
    var presenter: AddTaskPresenterProtocol? { get set }
    func showSuccess()
    func showError(_ message: String)
}

// MARK: - Presenter
protocol AddTaskPresenterProtocol: AnyObject {
    func didTapSave(title: String, description: String)
    func didSaveTodo(_ todo: TodoEntity)
    func didFinishSaving()
}

// MARK: - Interactor
protocol AddTaskInteractorProtocol: AnyObject {
    func saveTodo(title: String, description: String)
}

// MARK: - Router
protocol AddTaskRouterProtocol: AnyObject {
    func dismiss()
}
