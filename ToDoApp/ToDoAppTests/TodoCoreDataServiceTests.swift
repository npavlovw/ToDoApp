//
//  TodoCoreDataServiceTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 07.08.2025.
//

import XCTest
import CoreData
@testable import ToDoApp

final class TodoCoreDataServiceTests: XCTestCase {
    var service: TodoCoreDataService!
    var persistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        
        persistentContainer = NSPersistentContainer(name: "ToDoApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Load persistent stores")
        persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    
        service = TodoCoreDataService(context: persistentContainer.viewContext)
    }
    
    override func tearDown() {
        service = nil
        persistentContainer = nil
        super.tearDown()
    }
    
    func testAddTodo() {
        let todo = TodoEntity(
            id: 1,
            title: "Test task",
            description: "Test description",
            date: Date(),
            isCompleted: false
        )
        
        service.addTodo(todo)
        
        let fetchedTodos = service.fetchTodos()
        XCTAssertEqual(fetchedTodos.count, 1)
        XCTAssertEqual(fetchedTodos.first?.id, todo.id)
        XCTAssertEqual(fetchedTodos.first?.title, todo.title)
    }
    
    func testUpdateTodo() {
        let todo = TodoEntity(id: 2, title: "Old Title", description: "Old Desc", date: Date(), isCompleted: false)
        service.addTodo(todo)

        let updatedTodo = TodoEntity(id: 2, title: "New Title", description: "New Desc", date: Date(), isCompleted: true)
        service.updateTodo(updatedTodo)

        let fetchedTodos = service.fetchTodos()
        XCTAssertEqual(fetchedTodos.count, 1)
        XCTAssertEqual(fetchedTodos.first?.title, "New Title")
        XCTAssertEqual(fetchedTodos.first?.description, "New Desc")
        XCTAssertTrue(fetchedTodos.first?.isCompleted == true)
    }
    
    func testDeleteTodo() {
        let todo = TodoEntity(id: 3, title: "To Delete", description: "", date: Date(), isCompleted: false)
        service.addTodo(todo)

        service.deleteTodo(withID: 3)

        let fetchedTodos = service.fetchTodos()
        XCTAssertTrue(fetchedTodos.isEmpty)
    }
    
    func testUpdateStatus() {
        let todo = TodoEntity(id: 4, title: "Status Test", description: "", date: Date(), isCompleted: false)
        service.addTodo(todo)

        service.updateStatus(for: 4, isCompleted: true)

        let fetchedTodos = service.fetchTodos()
        XCTAssertTrue(fetchedTodos.first?.isCompleted == true)
    }

    func testDeleteAllTodos() {
        let todos = [
            TodoEntity(id: 5, title: "Todo1", description: "", date: Date(), isCompleted: false),
            TodoEntity(id: 6, title: "Todo2", description: "", date: Date(), isCompleted: true)
        ]
        service.saveTodos(todos)

        service.deleteAllTodos()

        let fetchedTodos = service.fetchTodos()
        XCTAssertTrue(fetchedTodos.isEmpty)
    }
}
