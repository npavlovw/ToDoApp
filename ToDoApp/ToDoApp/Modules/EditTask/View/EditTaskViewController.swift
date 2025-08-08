//
//  EditTaskViewController.swift
//  ToDoApp
//
//  Created by Никита Павлов on 04.08.2025.
//

import Foundation
import UIKit

final class EditTaskViewController: BaseTaskViewController, EditTaskViewProtocol {
    
    var presenter: EditTaskPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(didTapSaveAndBack), for: .touchUpInside)
        presenter?.viewDidLoad()
    }
    
    func showTodo(_ todo: TodoEntity) {
        configureUI(with: todo)
    }
    
    func showValidationError(_ message: String) {
        showAlert(title: "Ошибка", message: message)
    }
    
    func showSaveSuccess() {
        (presenter as? EditTaskPresenter)?.router?.dismiss()
    }
    
    @objc private func didTapSaveAndBack() {
        presenter?.didTapSave(title: titleField.text, description: descriptionTextView.text)
    }
}

