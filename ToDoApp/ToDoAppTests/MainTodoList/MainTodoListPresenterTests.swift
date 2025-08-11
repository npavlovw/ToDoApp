//
//  MainTodoListPresenterTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 07.08.2025.
//

import XCTest
@testable import ToDoApp

final class MainTodoListPresenterTests: XCTestCase {
    
    class MockView: MainTodoListViewProtocol {
        var shownTodos: [TodoEntity]?
        func showTodos(_ todos: [TodoEntity]) {
            shownTodos = todos
        }
    }
    
    class MockInteractor: MainTodoListInteractorProtocol {
        var fetchTodosCalled = false
        func fetchTodos() {
            fetchTodosCalled = true
        }
    }
    
    class MockRouter: MainTodoListRouterProtocol {
        var navigateToAddTaskCalled = false
        var navigatedEditTodo: TodoEntity?
        
        func navigateToAddTask() {
            navigateToAddTaskCalled = true
        }
        
        func navigateToEditTodo(todo: TodoEntity) {
            navigatedEditTodo = todo
        }
    }
    
    var presenter: MainTodoListPresenter!
    var view: MockView!
    var interactor: MockInteractor!
    var router: MockRouter!
    
    override func setUp() {
        super.setUp()
        presenter = MainTodoListPresenter()
        view = MockView()
        interactor = MockInteractor()
        router = MockRouter()
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }
    
    func test_viewDidLoad_callsFetchTodos() {
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.fetchTodosCalled)
    }
    
    func test_didTapAddTask_callsRouter() {
        presenter.didTapAddTask()
        XCTAssertTrue(router.navigateToAddTaskCalled)
    }
    
    func test_didSelectTodo_callsRouterWithTodo() {
        let todo = TodoEntity(id: 1, title: "Test", description: "Desc", date: Date(), isCompleted: false)
        presenter.didSelectTodo(todo)
        XCTAssertEqual(router.navigatedEditTodo?.id, todo.id)
    }
    
    func test_didFetchTodos_passesDataToView() {
        let todos = [
            TodoEntity(id: 1, title: "One", description: "", date: Date(), isCompleted: false),
            TodoEntity(id: 2, title: "Two", description: "", date: Date(), isCompleted: false)
        ]
        
        presenter.didFetchTodos(todos)
        XCTAssertEqual(view.shownTodos?.count, 2)
        XCTAssertEqual(view.shownTodos?.first?.title, "One")
    }
}
