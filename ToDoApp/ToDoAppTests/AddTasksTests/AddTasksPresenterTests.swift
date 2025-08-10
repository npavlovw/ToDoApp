//
//  AddTasksTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 07.08.2025.
//

import XCTest
@testable import ToDoApp

final class AddTaskPresenterTests: XCTestCase {
    
    // Мок для View
    final class MockView: AddTaskViewProtocol {
        var presenter: AddTaskPresenterProtocol?
        
        var didShowSuccess = false
        var didShowError: String?
        
        func showSuccess() {
            didShowSuccess = true
        }
        
        func showError(_ message: String) {
            didShowError = message
        }
    }

    
    // Мок для Interactor
    final class MockInteractor: AddTaskInteractorInputProtocol {
        var didAddTodo: TodoEntity?
        
        func addTodo(_ todo: TodoEntity) {
            didAddTodo = todo
        }
    }
    
    var presenter: AddTaskPresenter!
    var view: MockView!
    var interactor: MockInteractor!
    
    override func setUp() {
        super.setUp()
        view = MockView()
        interactor = MockInteractor()
        presenter = AddTaskPresenter()
        presenter.view = view
        presenter.interactor = interactor
    }
    
    func testAddTaskEmptyTitleShowsError() {
        presenter.addTask(title: "", description: "Desc", date: Date())
        
        XCTAssertEqual(view.didShowError, "Title cannot be empty")
        XCTAssertNil(interactor.didAddTodo)
        XCTAssertFalse(view.didClose)
    }
    
    func testAddTaskValidDataAddsTodo() {
        presenter.addTask(title: "Test", description: "Desc", date: Date())
        
        XCTAssertNil(view.didShowError)
        XCTAssertNotNil(interactor.didAddTodo)
        XCTAssertEqual(interactor.didAddTodo?.title, "Test")
        XCTAssertTrue(view.didClose)
    }
}
