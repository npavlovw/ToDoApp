//
//  EditTaskViewController.swift
//  ToDoApp
//
//  Created by Никита Павлов on 04.08.2025.
//

import UIKit

final class EditTaskViewController: UIViewController, EditTaskViewProtocol {
    var presenter: EditTaskPresenterProtocol!
    
    private let backButton = UIButton(type: .system)
    private let titleField = UITextField()
    private let dateLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        makeConstraints()
        presenter.viewDidLoad()
    }

    //MARK: - setup UI
    private func setupUI() {
        
        //BackButton
        backButton.setTitle("  Назад", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .yellowApp
        backButton.setTitleColor(.yellowApp, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        backButton.semanticContentAttribute = .forceLeftToRight
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        
        // Title
        titleField.attributedPlaceholder = NSAttributedString(
            string: "Название",
            attributes: [
                .foregroundColor: UIColor.whiteApp
            ]
        )
        titleField.font = UIFont.boldSystemFont(ofSize: 34)
        titleField.textColor = .white
        titleField.backgroundColor = .clear
        titleField.borderStyle = .none
        titleField.tintColor = .white
        
        // Date
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .whiteApp
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateLabel.text = formatter.string(from: Date())
        
        descriptionTextView.font = UIFont.systemFont(ofSize: 17)
        descriptionTextView.textColor = .whiteApp
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
    }
    
    private func makeConstraints() {
        view.addSubview(backButton)
        view.addSubview(titleField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)

        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().offset(8)
        }
        titleField.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleField.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    func showTodo(_ todo: TodoEntity) {
        titleField.text = todo.title
        descriptionTextView.text = todo.description
    }

    func showValidationError(_ message: String) {
        // Покажи алерт или метку
    }

    func showSaveSuccess() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapBack() {
        presenter.didTapSave(title: titleField.text, description: descriptionTextView.text)
    }
}
