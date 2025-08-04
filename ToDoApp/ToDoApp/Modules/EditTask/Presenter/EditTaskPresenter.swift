//
//  EditTaskPresenter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 04.08.2025.
//

import Foundation

final class EditTaskPresenter: EditTaskPresenterProtocol {
    weak var view: EditTaskViewProtocol?
    var interactor: EditTaskInteractorProtocol!
    var router: EditTaskRouterProtocol!
    
    private var todo: TodoEntity
    
    init(todo: TodoEntity) {
        self.todo = todo
    }

    func viewDidLoad() {
        view?.showTodo(todo)
    }

    func didTapSave(title: String?, description: String?) {
        guard let title = title, !title.isEmpty else {
            view?.showValidationError("Введите заголовок")
            return
        }
        guard let description = description, !description.isEmpty else {
            view?.showValidationError("Введите описание")
            return
        }

        todo.title = title
        todo.description = description
        todo.date = Date()

        interactor.updateTodo(todo)
    }
}

extension EditTaskPresenter: EditTaskInteractorOutputProtocol {
    func todoDidUpdate() {
        view?.showSaveSuccess()
    }
}
