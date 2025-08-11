//
//  MainToDoListProtocols.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

import UIKit

// MARK: - Interactor
protocol MainTodoListInteractorProtocol: AnyObject {
    func fetchTodos()
}

protocol MainTodoListInteractorOutput: AnyObject {
    func didFetchTodos(_ todos: [TodoEntity])
}

// MARK: - Presenter
protocol MainTodoListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapAddTask()
    func didSelectTodo(_ todo: TodoEntity)
}

// MARK: - View
protocol MainTodoListViewProtocol: AnyObject {
    func showTodos(_ todos: [TodoEntity])
}

// MARK: - Router
protocol MainTodoListRouterProtocol: AnyObject {
    func navigateToAddTask()
    func navigateToEditTodo(todo: TodoEntity)
}
