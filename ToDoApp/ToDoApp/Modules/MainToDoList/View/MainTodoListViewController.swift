//
//  ViewController.swift
//  ToDoApp
//
//  Created by Никита Павлов on 31.07.2025.
//

import UIKit
import SnapKit
import Speech

class MainTodoListViewController: UIViewController, MainTodoListViewProtocol {
    var presenter: MainTodoListPresenterProtocol?
    private var todos: [TodoEntity] = []
    var filteredTodos: [TodoEntity] = []
    var isSearching = false
    
    //MARK: - UI
    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    private let micButton = UIButton()
    private let tableView = UITableView()
    private let bottomBar = UIView()
    private let taskCountLabel = UILabel()
    private let addBtn = UIButton()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        presenter?.viewDidLoad()
        setupUI()
        makeConstraints()
        allowMicrophone()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
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
        searchBar.delegate = self
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
            
        //micButton
        micButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        micButton.tintColor = .lightGray
        micButton.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
        
        //TableView
        tableView.backgroundColor = .black
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
        view.addSubview(micButton)
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
        
        micButton.snp.makeConstraints {
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.trailing.equalTo(searchBar.snp.trailing).inset(8)
            $0.width.height.equalTo(24)
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
    
    // MARK: - Actions
    
    func showTodos(_ todos: [TodoEntity]) {
        self.todos = todos
            .sorted {
                if $0.isCompleted == $1.isCompleted {
                    return $0.date < $1.date
                }
                return !$0.isCompleted && $1.isCompleted
            }
        
        tableView.reloadData()
        
        taskCountLabel.text = "\(todos.count) Задач"
    }
    
    func allowMicrophone () {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            default:
                print("Speech recognition not authorized")
            }
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
            if self.isSearching {
                let fullIndex = self.todos.firstIndex(where: { $0.id == todo.id })
                let filteredIndex = self.filteredTodos.firstIndex(where: { $0.id == todo.id })

                if let fullIndex = fullIndex {
                    self.todos.remove(at: fullIndex)
                }
                if let filteredIndex = filteredIndex {
                    self.filteredTodos.remove(at: filteredIndex)
                    self.tableView.deleteRows(at: [IndexPath(row: filteredIndex, section: 0)], with: .automatic)
                } else {
                    self.tableView.reloadData()
                }
            } else {
                self.todos.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
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

        TodoCoreDataService.shared.deleteTodo(withID: todo.id)

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

    @objc private func micButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            startListening()
        }
    }

    private func startListening() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { return }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    self?.searchBar.text = bestString
                }
            }

            if error != nil || (result?.isFinal ?? false) {
                self?.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

    //MARK: - Extension
extension MainTodoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredTodos.count : todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = isSearching ? filteredTodos[indexPath.row] : todos[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .black
        
        cell.configure(
            todo: todo,
            dateText: format(todo.date),
            onToggleStatus: { [weak self] tappedTodo in
                guard let self else { return }

                let newStatus = !tappedTodo.isCompleted
                TodoCoreDataService.shared.updateStatus(for: tappedTodo.id, isCompleted: newStatus)

                if let index = self.todos.firstIndex(where: { $0.id == tappedTodo.id }) {
                    self.todos[index].isCompleted = newStatus
                }
                if self.isSearching, let index = self.filteredTodos.firstIndex(where: { $0.id == tappedTodo.id }) {
                    self.filteredTodos[index].isCompleted = newStatus
                }
                
                self.todos.sort {
                    if $0.isCompleted == $1.isCompleted {
                        return $0.date < $1.date
                    }
                    return !$0.isCompleted && $1.isCompleted
                }
                self.filteredTodos.sort {
                    if $0.isCompleted == $1.isCompleted {
                        return $0.date < $1.date
                    }
                    return !$0.isCompleted && $1.isCompleted
                }

                self.tableView.reloadData()
            }
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let todo = isSearching ? filteredTodos[indexPath.row] : todos[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            return self.makePreviewController(for: todo)
        }, actionProvider: { _ in
            return self.makeContextMenu(for: todo, at: indexPath)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = isSearching ? filteredTodos[indexPath.row] : todos[indexPath.row]
        presenter?.didSelectTodo(todo)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteTodo(at: indexPath)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

extension MainTodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            tableView.reloadData()
            return
        }

        isSearching = true
        filteredTodos = todos
            .filter { todo in
                todo.title.lowercased().contains(searchText.lowercased()) ||
                todo.description.lowercased().contains(searchText.lowercased())
            }
            .sorted {
                if $0.isCompleted == $1.isCompleted {
                    return $0.date < $1.date
                }
                return !$0.isCompleted && $1.isCompleted
            }

        tableView.reloadData()
    }
}
