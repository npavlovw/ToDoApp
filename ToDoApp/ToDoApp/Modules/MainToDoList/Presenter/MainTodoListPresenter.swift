//
//  MainTodoListPresenter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 01.08.2025.
//

final class MainTodoListPresenter: MainTodoListPresenterProtocol {
    weak var view: MainTodoListViewProtocol?
    var interactor: MainTodoListInteractorProtocol?

    func viewDidLoad() {
        interactor?.fetchTodos()
    }
}

extension MainTodoListPresenter: MainTodoListInteractorOutput {
    func didFetchTodos(_ todos: [TodoEntity]) {
        view?.showTodos(todos)
    }
}
