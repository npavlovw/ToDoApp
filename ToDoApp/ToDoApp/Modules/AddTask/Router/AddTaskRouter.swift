//
//  AddTaskRouter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

import UIKit

final class AddTaskRouter: AddTaskRouterProtocol {
    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    static func createModule(onTaskAdded: @escaping (TodoEntity) -> Void) -> UIViewController {
        let view = AddTaskViewController()
        let presenter = AddTaskPresenter()
        let interactor = AddTaskInteractor()
        let router = AddTaskRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.onTaskAdded = onTaskAdded
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
