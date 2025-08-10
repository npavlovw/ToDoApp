//
//  AddTaskInterractorTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 10.08.2025.
//

import XCTest
@testable import ToDoApp
import CoreData

final class AddTaskInteractorTests: XCTestCase {
    
    class MockCoreDataService: TodoCoreDataService {
        var addedTodo: TodoEntity?
        
        override func addTodo(_ todo: TodoEntity) {
            addedTodo = todo
        }
    }
    
    class MockPresenter: AddTaskPresenterProtocol {
        var savedTodo: TodoEntity?
        func didSaveTodo(_ todo: TodoEntity) {
            savedTodo = todo
        }
        func didTapSave(title: String, description: String) {}
        func didFinishSaving() {}
    }
    
    var interactor: AddTaskInteractor!
    var coreDataService: MockCoreDataService!
    var presenter: MockPresenter!
    
    override func setUp() {
        super.setUp()
        coreDataService = MockCoreDataService(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        interactor = AddTaskInteractor(coreDataService: coreDataService)
        presenter = MockPresenter()
        interactor.presenter = presenter
    }
    
    func testSaveTodoCallsAddTodoAndPresenter() {
        interactor.saveTodo(title: "Test", description: "Description")
        
        XCTAssertNotNil(coreDataService.addedTodo)
        XCTAssertEqual(coreDataService.addedTodo?.title, "Test")
        XCTAssertEqual(coreDataService.addedTodo?.description, "Description")
        
        XCTAssertNotNil(presenter.savedTodo)
        XCTAssertEqual(presenter.savedTodo?.title, "Test")
    }
}

final class AddTaskPresenterTests: XCTestCase {
    
    class MockView: AddTaskViewProtocol {
        var presenter: AddTaskPresenterProtocol?
        
        var errorMessage: String?
        var successShown = false
        
        func showError(_ message: String) {
            errorMessage = message
        }
        
        func showSuccess() {
            successShown = true
        }
    }
    
    class MockInteractor: AddTaskInteractorProtocol {
        var savedTitle: String?
        var savedDescription: String?
        
        func saveTodo(title: String, description: String) {
            savedTitle = title
            savedDescription = description
        }
    }
    
    var presenter: AddTaskPresenter!
    var view: MockView!
    var interactor: MockInteractor!
    
    override func setUp() {
        super.setUp()
        presenter = AddTaskPresenter()
        view = MockView()
        interactor = MockInteractor()
        
        presenter.view = view
        presenter.interactor = interactor
        view.presenter = presenter
    }
    
    func testDidTapSaveWithEmptyTitleShowsError() {
        presenter.didTapSave(title: " ", description: "Desc")
        XCTAssertEqual(view.errorMessage, "Введите заголовок задачи")
        XCTAssertNil(interactor.savedTitle)
    }
    
    func testDidTapSaveWithValidTitleCallsSave() {
        presenter.didTapSave(title: "Title", description: "Desc")
        XCTAssertEqual(interactor.savedTitle, "Title")
        XCTAssertEqual(interactor.savedDescription, "Desc")
        XCTAssertNil(view.errorMessage)
    }
    
    func testDidSaveTodoCallsOnTaskAddedAndShowSuccess() {
        var calledTask: TodoEntity?
        presenter.onTaskAdded = { todo in
            calledTask = todo
        }
        
        let todo = TodoEntity(id: 1, title: "Test", description: "Desc", date: Date(), isCompleted: false)
        presenter.didSaveTodo(todo)
        
        XCTAssertTrue(view.successShown)
        XCTAssertEqual(calledTask?.id, todo.id)
    }
}
