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
