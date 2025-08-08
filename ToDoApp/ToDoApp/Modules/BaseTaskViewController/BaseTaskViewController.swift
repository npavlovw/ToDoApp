//
//  BaseTaskViewController.swift
//  ToDoApp
//
//  Created by Никита Павлов on 09.08.2025.
//

import UIKit
import SnapKit

class BaseTaskViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - UI
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Назад", for: .normal)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .yellowApp
        button.setTitleColor(.yellowApp, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    let titleField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(
            string: "Название",
            attributes: [.foregroundColor: UIColor.darkGray]
        )
        field.font = .boldSystemFont(ofSize: 34)
        field.textColor = .white
        field.tintColor = .white
        field.borderStyle = .none
        return field
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .whiteApp
        label.text = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        textView.textColor = .whiteApp
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupGestures()
    }
    
    // MARK: - Alert helper
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        [backButton, titleField, dateLabel, descriptionTextView].forEach { view.addSubview($0) }
        
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
    
    private func setupGestures() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    // MARK: - Public
    func configureUI(with todo: TodoEntity) {
        titleField.text = todo.title
        descriptionTextView.text = todo.description
        dateLabel.text = DateFormatter.localizedString(from: todo.date,
                                                       dateStyle: .short,
                                                       timeStyle: .none)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        (navigationController?.viewControllers.count ?? 0) > 1
    }
    
    // MARK: - Actions
    @objc func handleSwipeDown() {
        view.endEditing(true)
    }
}
