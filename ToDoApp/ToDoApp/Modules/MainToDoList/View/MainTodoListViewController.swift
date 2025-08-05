//
//  ViewController.swift
//  ToDoApp
//
//  Created by Никита Павлов on 31.07.2025.
//

import UIKit
import SnapKit

class MainTodoListViewController: UIViewController, MainTodoListViewProtocol {
    var presenter: MainTodoListPresenterProtocol?
    private var todos: [TodoEntity] = []

    func showTodos(_ todos: [TodoEntity]) {
        self.todos = todos
        tableView.reloadData()
        
        taskCountLabel.text = "\(todos.count) Задач"
    }
    
    
    //MARK: - UI
    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let bottomBar = UIView()
    private let taskCountLabel = UILabel()
    private let addBtn = UIButton()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        presenter?.viewDidLoad()
        setupUI()
        makeConstraints()
    }

    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .black
        
        //Title
        titleLabel.text = "Задачи"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textColor = .white
        
        //SearchBar
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .grayApp
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .grayApp
            textField.textColor = .whiteApp
            textField.leftView?.tintColor = .whiteApp
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [
                    .foregroundColor: UIColor.whiteApp
                ]
            )
            textField.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        //TableView
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "ToDoCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        //BottomBar
        bottomBar.backgroundColor = .grayApp
        taskCountLabel.textColor = .white
        taskCountLabel.font = UIFont.systemFont(ofSize: 11)
        
        //AddBtn
        let icon = UIImage(systemName: "square.and.pencil")
        addBtn.setImage(icon, for: .normal)
        addBtn.tintColor = .yellowApp
        addBtn.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(bottomBar)
        bottomBar.addSubview(taskCountLabel)
        bottomBar.addSubview(addBtn)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.leading.equalToSuperview().offset(20)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
        }
        
        bottomBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(83)
        }
        
        taskCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20.5)
        }
        
        addBtn.snp.makeConstraints {
            $0.centerY.equalTo(taskCountLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    @objc private func didTapAdd() {
        presenter?.didTapAddTask()
    }
    
    private func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    func insertTodo(_ todo: TodoEntity) {
        todos.insert(todo, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        taskCountLabel.text = "\(todos.count) Задач"
    }
    
    private func makeContextMenu(for todo: TodoEntity, at indexPath: IndexPath) -> UIMenu {
        
        let edit = UIAction(title: "Редактировать", image: UIImage(named: "EditApp")) { _ in
            self.editTodo(todo)
        }

        let share = UIAction(title: "Поделиться", image: UIImage(named: "ShareApp")) { _ in
            self.shareTodo(todo)
        }

        let delete = UIAction(title: "Удалить",
                              image: UIImage(named: "TrashApp"),
                              attributes: [.destructive]) { _ in
            self.deleteTodo(at: indexPath)
        }

        return UIMenu(title: "", children: [edit, share, delete])
    }
    
    private func makePreviewController(for todo: TodoEntity) -> UIViewController {
        let preview = UIViewController()
        preview.view.backgroundColor = .darkGray
        preview.view.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.text = todo.title

        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = todo.description

        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateLabel.text = formatter.string(from: todo.date)

        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.distribution = .fill

        preview.view.addSubview(stack)

        stack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        let screenWidth = UIScreen.main.bounds.width
        let targetWidth = screenWidth * 0.9
        
        preview.view.setNeedsLayout()
        preview.view.layoutIfNeeded()

        let targetSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
        let fittedSize = preview.view.systemLayoutSizeFitting(targetSize)

        preview.preferredContentSize = CGSize(width: targetSize.width, height: fittedSize.height)

        return preview
    }

    private func editTodo(_ todo: TodoEntity) {
        self.presenter?.didSelectTodo(todo)
}

    private func shareTodo(_ todo: TodoEntity) {
        let activityVC = UIActivityViewController(
            activityItems: [todo.title, todo.description],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }

    private func deleteTodo(at indexPath: IndexPath) {
        let todo = todos[indexPath.row]

        TodoCoreDataService.shared.deleteTodoFromCoreData(with: todo.id)

        todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        taskCountLabel.text = "\(todos.count) Задач"
    }
    
    func updateTodo(_ updatedTodo: TodoEntity) {
        if let index = todos.firstIndex(where: { $0.id == updatedTodo.id }) {
            todos[index] = updatedTodo
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }

}

    //MARK: - Extension
extension MainTodoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = todos[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(
            title: todo.title,
            description: todo.description,
            date: format(todo.date),
            isDone: todo.isCompleted)
        
        cell.onToggleStatus = { [weak self] in
            guard let self else { return }
            var todo = self.todos[indexPath.row]
            todo.isCompleted.toggle()
            
            TodoCoreDataService.shared.updateTodoStatus(id: todo.id, isCompleted: todo.isCompleted)

            self.todos[indexPath.row] = todo
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let todo = todos[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            return self.makePreviewController(for: todo)
        }, actionProvider: { _ in
            return self.makeContextMenu(for: todo, at: indexPath)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        presenter?.didSelectTodo(todo)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteTodo(at: indexPath)
        }
    }
}
