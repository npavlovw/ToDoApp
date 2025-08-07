//
//  EditTaskTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 07.08.2025.
//
//
//import XCTest
//@testable import ToDoApp
//
//final class EditTaskPresenterTests: XCTestCase {
//    var presenter: EditTaskPresenter!
//    var mockView: MockEditTaskView!
//    var mockInteractor: MockEditTaskInteractor!
//    var mockRouter: MockEditTaskRouter!
//    
//    override func setUp() {
//        super.setUp()
//        presenter = EditTaskPresenter()
//        mockView = MockEditTaskView()
//        mockInteractor = MockEditTaskInteractor()
//        mockRouter = MockEditTaskRouter()
//        
//        presenter.view = mockView
//        presenter.interactor = mockInteractor
//        presenter.router = mockRouter
//    }
//    
//    func testViewDidLoad_shouldShowTodo() {
//        let todo = TodoEntity(id: 1, title: "Test", description: "Desc", date: Date(), isCompleted: false)
//        presenter.todo = todo
//        
//        presenter.viewDidLoad()
//        
//        XCTAssertTrue(mockView.didShowTodo)
//        XCTAssertEqual(mockView.shownTodo?.id, 1)
//    }
//    
//    func testDidTapSave_shouldUpdateAndClose() {
//        let updated = TodoEntity(id: 2, title: "Updated", description: "", date: Date(), isCompleted: true)
//        
//        presenter.didTapSave(updatedTodo: updated)
//        
//        XCTAssertEqual(mockInteractor.updatedTodo?.id, 2)
//        XCTAssertTrue(mockRouter.didCallClose)
//    }
//}
//
//// MARK: - Mocks
//
//final class MockEditTaskView: EditTaskViewProtocol {
//    var didShowTodo = false
//    var shownTodo: TodoEntity?
//    
//    func showTodo(_ todo: TodoEntity) {
//        didShowTodo = true
//        shownTodo = todo
//    }
//    
//    func close() {}
//}
//
//final class MockEditTaskInteractor: EditTaskInteractorProtocol {
//    var updatedTodo: TodoEntity?
//    
//    func updateTodo(_ todo: TodoEntity) {
//        updatedTodo = todo
//    }
//}
//
//final class MockEditTaskRouter: EditTaskRouterProtocol {
//    var didCallClose = false
//    
//    func close() {
//        didCallClose = true
//    }
//}
