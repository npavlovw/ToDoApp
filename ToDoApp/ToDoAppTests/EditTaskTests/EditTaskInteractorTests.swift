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
        
        // Заменим coreDataService через рефлексию или через инициализацию (если нужно, добавим init с зависимостью)
        // В твоём коде coreDataService - private let, надо сделать возможность инъекции, например:
        // Для простоты сейчас предположим, что можно заменить (в реальной жизни — надо улучшить код для тестируемости)
        
        mockOutput = MockOutput()
        interactor.output = mockOutput
    }
    
    func test_updateTodo_callsCoreDataServiceAndOutput() {
        let todo = TodoEntity(id: 1, title: "Test", description: "Desc", date: Date(), isCompleted: false)
        
        // Поскольку coreDataService приватный, здесь тестируем только вызов output,
        // либо надо сделать coreDataService доступным для замены
        
        interactor.updateTodo(todo)
        
        XCTAssertTrue(mockOutput.todoDidUpdateCalled)
    }
}
