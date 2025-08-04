//
//  EditTaskRouter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 04.08.2025.
//

import UIKit

// EditTaskRouter.swift
final class EditTaskRouter: EditTaskRouterProtocol {
    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    static func createModule(with todo: TodoEntity) -> UIViewController {
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

        return view
    }
}
