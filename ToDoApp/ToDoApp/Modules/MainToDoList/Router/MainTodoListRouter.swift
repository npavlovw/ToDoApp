//
//  MainToDoListRouter.swift
//  ToDoApp
//
//  Created by Никита Павлов on 01.08.2025.
//

import UIKit

final class MainTodoListRouter {
    static func createModule() -> UIViewController {
        let view = MainTodoListViewController()
        let presenter = MainTodoListPresenter()
        let interactor = MainTodoListInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter

        return view
    }
}
