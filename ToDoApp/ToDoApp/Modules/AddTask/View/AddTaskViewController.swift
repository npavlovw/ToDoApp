//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

import Foundation


final class AddTaskViewController: BaseTaskViewController, AddTaskViewProtocol {
    
    var presenter: AddTaskPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(didTapSaveAndBack), for: .touchUpInside)
    }
    
    // MARK: - AddTaskViewProtocol
    
    func showSuccess() {
        presenter?.didFinishSaving()
    }
    
    func showError(_ message: String) {
        showAlert(title: "Ошибка", message: message)
    }
    
    // MARK: - Actions
    
    func showValidationError(_ message: String) {
        showAlert(title: "Ошибка", message: message)
    }
    
    func showSaveSuccess() {
        (presenter as? AddTaskPresenter)?.router?.dismiss()
    }
    
    @objc private func didTapSaveAndBack() {
        presenter?.didTapSave(title: titleField.text ?? "", description: descriptionTextView.text)
    }
}

