//
//  EditTaskRouter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 04.08.2025.
//

import UIKit

final class EditTaskRouter: EditTaskRouterProtocol {
    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    static func createModule(with todo: TodoEntity,
                             onUpdate: @escaping (TodoEntity) -> Void) -> UIViewController {
        let view = EditTaskViewController()
        let presenter = EditTaskPresenter(todo: todo)
        let interactor = EditTaskInteractor()
        let router = EditTaskRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view
        
        presenter.onUpdate = onUpdate

        return view
    }
}
