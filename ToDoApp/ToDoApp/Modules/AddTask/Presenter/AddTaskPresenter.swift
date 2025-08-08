//
//  AddTaskPresenter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

final class AddTaskPresenter: AddTaskPresenterProtocol {
    var onTaskAdded: ((TodoEntity) -> Void)?
    weak var view: AddTaskViewProtocol?
    var interactor: AddTaskInteractorProtocol?
    var router: AddTaskRouterProtocol?

    func didTapSave(title: String, description: String) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            view?.showError("Введите заголовок задачи")
            return
        }
        interactor?.saveTodo(title: title, description: description)
    }
    
    func didSaveTodo(_ todo: TodoEntity) {
        onTaskAdded?(todo)
        view?.showSuccess()
    }
    
    func didFinishSaving() {
        router?.dismiss()
    }

}
