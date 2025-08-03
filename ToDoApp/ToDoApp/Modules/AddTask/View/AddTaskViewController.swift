//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

import Foundation
import UIKit
import SnapKit

final class AddTaskViewController: UIViewController, AddTaskViewProtocol {
    
    var presenter: AddTaskPresenterProtocol?

    //MARK: - UI
    private let backButton = UIButton(type: .system)
    private let titleField = UITextField()
    private let dateLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let descriptionPlaceholder = UILabel()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        makeConstraints()
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
        descriptionTextView.delegate = self
        
        descriptionPlaceholder.text = "Описание"
        descriptionPlaceholder.font = UIFont.systemFont(ofSize: 17)
        descriptionPlaceholder.textColor = .whiteApp
        descriptionPlaceholder.numberOfLines = 0
        descriptionPlaceholder.isUserInteractionEnabled = false
    }
    
    private func makeConstraints() {
        view.addSubview(backButton)
        view.addSubview(titleField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        descriptionTextView.addSubview(descriptionPlaceholder)

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
        descriptionPlaceholder.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.textContainerInset.top)
            $0.leading.equalTo(descriptionTextView.textContainer.lineFragmentPadding)
            $0.trailing.equalToSuperview()
        }
    }
    
    @objc private func didTapBack() {
        let title = titleField.text ?? ""
        let description = descriptionTextView.text ?? ""
        presenter?.didTapSave(title: title, description: description)
    }

    func showSuccess() {
        navigationController?.popViewController(animated: true)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Extensions
extension AddTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionPlaceholder.isHidden = !textView.text.isEmpty
    }
}
