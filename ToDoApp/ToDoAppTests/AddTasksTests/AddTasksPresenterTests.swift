//
//  AddTasksTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 07.08.2025.
//

//import XCTest
//@testable import ToDoApp
//
//final class AddTaskPresenterTests: XCTestCase {
//    var presenter: AddTaskPresenter!
//    var mockView: MockAddTaskView!
//    var mockInteractor: MockAddTaskInteractor!
//    var mockRouter: MockAddTaskRouter!
//    
//    override func setUp() {
//        super.setUp()
//        presenter = AddTaskPresenter()
//        mockView = MockAddTaskView()
//        mockInteractor = MockAddTaskInteractor()
//        mockRouter = MockAddTaskRouter()
//        
//        presenter.view = mockView
//        presenter.interactor = mockInteractor
//        presenter.router = mockRouter
//    }
//    
//    func testDidTapSave_shouldAddTodoAndClose() {
//        let newTodo = TodoEntity(id: 123, title: "New", description: "", date: Date(), isCompleted: false)
//        
//        presenter.didTapSave(newTodo: newTodo)
//        
//        XCTAssertEqual(mockInteractor.addedTodo?.id, 123)
//        XCTAssertTrue(mockRouter.didCallClose)
//    }
//}
//
//// MARK: - Mocks
//
//final class MockAddTaskView: AddTaskViewProtocol {
//    func close() {}
//}
//
//final class MockAddTaskInteractor: AddTaskInteractorProtocol {
//    var addedTodo: TodoEntity?
//    
//    func addTodo(_ todo: TodoEntity) {
//        addedTodo = todo
//    }
//}
//
//final class MockAddTaskRouter: AddTaskRouterProtocol {
//    var didCallClose = false
//    
//    func close() {
//        didCallClose = true
//    }
//}
