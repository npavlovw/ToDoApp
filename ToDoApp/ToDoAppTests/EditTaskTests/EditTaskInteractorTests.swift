//
//  EditTaskInteractorTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 10.08.2025.
//
import XCTest
@testable import ToDoApp
import CoreData

final class MockCoreDataService: TodoCoreDataService {
    var updateTodoCalled = false
    var updatedTodo: TodoEntity?
    
    override func updateTodo(_ todo: TodoEntity) {
        updateTodoCalled = true
        updatedTodo = todo
    }
}

final class MockOutput: EditTaskInteractorOutputProtocol {
    var todoDidUpdateCalled = false
    
    func todoDidUpdate() {
        todoDidUpdateCalled = true
    }
}

final class EditTaskInteractorTests: XCTestCase {
    
    var interactor: EditTaskInteractor!
    var mockCoreDataService: MockCoreDataService!
    var mockOutput: MockOutput!
    
    override func setUp() {
        super.setUp()
        mockCoreDataService = MockCoreDataService(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        interactor = EditTaskInteractor()
        interactor.output = nil
        
        mockOutput = MockOutput()
        interactor.output = mockOutput
    }
    
    func test_updateTodo_callsCoreDataServiceAndOutput() {
        let todo = TodoEntity(id: 1, title: "Test", description: "Desc", date: Date(), isCompleted: false)
        
        interactor.updateTodo(todo)
        
        XCTAssertTrue(mockOutput.todoDidUpdateCalled)
    }
}
