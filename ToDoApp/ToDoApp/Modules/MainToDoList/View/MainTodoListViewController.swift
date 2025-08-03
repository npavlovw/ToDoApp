//
//  ViewController.swift
//  ToDoApp
//
//  Created by Никита Павлов on 31.07.2025.
//

import UIKit
import SnapKit

class MainTodoListViewController: UIViewController {
    
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
        setupUI()
        makeConstraints()
    }

    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .black
        self.navigationController?.isNavigationBarHidden = true
        
        //Title
        titleLabel.text = "Задачи"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textColor = .white
        
        //SearchBar
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .grayApp //по макету не понятен цвет (написан, что белый, хотя по изображению он не чисто белый)
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .grayApp
            textField.textColor = .whitaApp
            textField.leftView?.tintColor = .whitaApp
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [
                    .foregroundColor: UIColor.whitaApp
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
        updateTaskCount()
        
        //AddBtn
        let icon = UIImage(systemName: "square.and.pencil")
        addBtn.setImage(icon, for: .normal)
        addBtn.tintColor = .yellowApp
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
    
    private func updateTaskCount() {
        taskCountLabel.text = "N Задач"
    }
}

    //MARK: - Extension
extension MainTodoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(
            title: "Title",
            description: "Description",
            date: "Date",
            isDone: indexPath.row % 2 == 0)
        return cell
    }
}
