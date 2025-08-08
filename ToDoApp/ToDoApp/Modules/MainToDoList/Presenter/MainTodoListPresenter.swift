//
//  MainTodoListPresenter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 01.08.2025.
//

import UIKit

final class MainTodoListPresenter: MainTodoListPresenterProtocol {
    
    weak var view: MainTodoListViewProtocol?
    var interactor: MainTodoListInteractorProtocol?
    var router: MainTodoListRouterProtocol?

    func viewDidLoad() {
        interactor?.fetchTodos()
    }
    
    func didTapAddTask() {
        router?.navigateToAddTask()
    }
    
    func didSelectTodo(_ todo: TodoEntity) {
        router?.navigateToEditTodo(todo: todo)
    }
}

extension MainTodoListPresenter: MainTodoListInteractorOutput {
    func didFetchTodos(_ todos: [TodoEntity]) {
        view?.showTodos(todos)
    }
}
