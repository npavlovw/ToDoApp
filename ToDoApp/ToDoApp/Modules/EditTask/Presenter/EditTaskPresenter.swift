//
//  EditTaskPresenter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 04.08.2025.
//

import Foundation

final class EditTaskPresenter {
    weak var view: EditTaskViewProtocol?
    var interactor: EditTaskInteractorProtocol?
    var router: EditTaskRouterProtocol?
    
    private var todo: TodoEntity
    var onUpdate: ((TodoEntity) -> Void)?
    
    init(todo: TodoEntity) {
        self.todo = todo
    }
}

extension EditTaskPresenter: EditTaskPresenterProtocol {

    func viewDidLoad() {
        view?.showTodo(todo)
    }

    func didTapSave(title: String?, description: String?) {
        guard let title = title?.trimmingCharacters(in: .whitespacesAndNewlines),
                !title.isEmpty else {
            view?.showValidationError("Введите заголовок")
            return
        }

        todo.title = title
        todo.description = description?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        todo.date = Date()

        interactor?.updateTodo(todo)
    }
}

extension EditTaskPresenter: EditTaskInteractorOutputProtocol {
    func todoDidUpdate() {
        onUpdate?(todo)
        view?.showSaveSuccess()
    }
}
