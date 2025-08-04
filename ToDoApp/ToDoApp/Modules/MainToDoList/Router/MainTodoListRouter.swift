//
//  MainToDoListRouter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 01.08.2025.
//

import UIKit

final class MainTodoListRouter: MainTodoListRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = MainTodoListViewController()
        let presenter = MainTodoListPresenter()
        let interactor = MainTodoListInteractor()
        let router = MainTodoListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.output = presenter
        router.viewController = view

        return view
    }
    
    func navigateToAddTask() {
        let addTaskVC = AddTaskRouter.createModule { [weak self] newTask in
            guard let self, let vc = self.viewController as? MainTodoListViewController else { return }
            
            vc.insertTodo(newTask)
            }
        
        viewController?.navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    func navigateToEditTodo(from view: UIViewController, todo: TodoEntity) {
        let editVC = EditTaskRouter.createModule(with: todo)
        viewController?.navigationController?.pushViewController(editVC, animated: true)
    }
}
