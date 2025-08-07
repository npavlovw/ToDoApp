//
//  MainTodoListPresenterTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 07.08.2025.
//

import XCTest
@testable import ToDoApp

final class MainTodoListPresenterTests: XCTestCase {
    
    var presenter: MainTodoListPresenter!
    var mockView: MockView!
    var mockInteractor: MockInteractor!
    var mockRouter: MockRouter!
    
    override func setUp() {
        super.setUp()
        mockView = MockView()
        mockInteractor = MockInteractor()
        mockRouter = MockRouter()
        presenter = MainTodoListPresenter()
        mockView.presenter = presenter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewDidLoad_shouldFetchTodosAndShowInView() {
        let sampleTodos = [
            TodoEntity(id: 1, title: "Task 1", description: "", date: Date(), isCompleted: false)
        ]
        mockInteractor.stubbedTodos = sampleTodos
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.didFetchTodos)
        XCTAssertTrue(mockView.didShowTodos)
        XCTAssertEqual(mockView.shownTodos, sampleTodos)
    }
    
    func testDidTapAddTask_shouldCallRouter() {
        presenter.didTapAddTask()
        XCTAssertTrue(mockRouter.didCallShowAddTask)
    }
    
    func testDidSelectTodo_shouldCallRouterWithTodo() {
        let todo = TodoEntity(id: 42, title: "Selected", description: "", date: Date(), isCompleted: false)
        presenter.didSelectTodo(todo)
        XCTAssertEqual(mockRouter.selectedTodo?.id, 42)
    }
}

// MARK: - Mocks

final class MockView: MainTodoListViewProtocol {
    var presenter: MainTodoListPresenterProtocol?
    var didShowTodos = false
    var shownTodos: [TodoEntity] = []

    func showTodos(_ todos: [TodoEntity]) {
        didShowTodos = true
        shownTodos = todos
    }
}

final class MockInteractor: MainTodoListInteractorProtocol {
    var presenter: MainTodoListInteractorOutput?
    
    var stubbedTodos: [TodoEntity] = []
    var didFetchTodos = false

    func fetchTodos() {
        didFetchTodos = true
        presenter?.didFetchTodos(stubbedTodos)
    }
}

final class MockRouter: MainTodoListRouterProtocol {
    var didCallShowAddTask = false
    var selectedTodo: TodoEntity?
    
    func navigateToAddTask() {
        didCallShowAddTask = true
    }
    
    func navigateToEditTodo(from view: UIViewController, todo: ToDoApp.TodoEntity) {
        selectedTodo = todo
    }
}
