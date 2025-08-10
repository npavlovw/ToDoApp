//
//  EditTaskTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 07.08.2025.
//
//
import XCTest
@testable import ToDoApp

final class EditTaskPresenterTests: XCTestCase {
    
    class MockView: EditTaskViewProtocol {
        var showTodoCalled = false
        var shownTodo: TodoEntity?
        var validationErrorMessage: String?
        var saveSuccessCalled = false
        
        func showTodo(_ todo: TodoEntity) {
            showTodoCalled = true
            shownTodo = todo
        }
        
        func showValidationError(_ message: String) {
            validationErrorMessage = message
        }
        
        func showSaveSuccess() {
            saveSuccessCalled = true
        }
    }
    
    class MockInteractor: EditTaskInteractorProtocol {
        var updateTodoCalled = false
        var updatedTodo: TodoEntity?
        
        func updateTodo(_ todo: TodoEntity) {
            updateTodoCalled = true
            updatedTodo = todo
        }
    }
    
    var presenter: EditTaskPresenter!
    var mockView: MockView!
    var mockInteractor: MockInteractor!
    var updatedTodoFromCallback: TodoEntity?
    
    override func setUp() {
        super.setUp()
        let todo = TodoEntity(id: 1, title: "Old title", description: "Old desc", date: Date(), isCompleted: false)
        presenter = EditTaskPresenter(todo: todo)
        mockView = MockView()
        mockInteractor = MockInteractor()
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.onUpdate = { [weak self] todo in
            self?.updatedTodoFromCallback = todo
        }
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        updatedTodoFromCallback = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_callsShowTodo() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockView.showTodoCalled)
        XCTAssertEqual(mockView.shownTodo?.title, "Old title")
    }
    
    func test_didTapSave_withEmptyTitle_showsValidationError() {
        presenter.didTapSave(title: "   ", description: "desc")
        XCTAssertEqual(mockView.validationErrorMessage, "Введите заголовок")
        XCTAssertFalse(mockInteractor.updateTodoCalled)
    }
    
    func test_didTapSave_withValidTitle_callsUpdateTodo() {
        presenter.didTapSave(title: "New Title", description: "New Desc")
        
        XCTAssertTrue(mockInteractor.updateTodoCalled)
        XCTAssertEqual(mockInteractor.updatedTodo?.title, "New Title")
        XCTAssertEqual(mockInteractor.updatedTodo?.description, "New Desc")
        XCTAssertNotNil(mockInteractor.updatedTodo?.date)  // дата обновлена
        
        presenter.todoDidUpdate()
        
        XCTAssertEqual(updatedTodoFromCallback?.title, "New Title")
        XCTAssertTrue(mockView.saveSuccessCalled)
    }
}
