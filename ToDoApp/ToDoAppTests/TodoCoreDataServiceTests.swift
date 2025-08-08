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
    var sut: TodoCoreDataService!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        
        let container = NSPersistentContainer(name: "ToDoApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                XCTFail("Failed to load store: \(error)")
            }
        }

        context = container.viewContext
        sut = TodoCoreDataService(context: context)
    }
    
    override func tearDown() {
        sut = nil
        context = nil
        super.tearDown()
    }
    
    func testAddTodo_shouldSaveTodoInCoreData() {
        let todo = TodoEntity(
            id: 1,
            title: "Test task",
            description: "Test description",
            date: Date(),
            isCompleted: false
        )
        
        sut.addTodo(todo)
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let results = try? context.fetch(fetchRequest)
        
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.title, "Test task")
        XCTAssertEqual(results?.first?.todoDesc, "Test description")
    }
    
    func testFetchTodo_shouldReturnSavedTodos() {
        let todo1 = TodoEntity(id: 1, title: "A", description: "A desc", date: Date(), isCompleted: false)
        let todo2 = TodoEntity(id: 2, title: "B", description: "B desc", date: Date(), isCompleted: true)
        sut.addTodo(todo1)
        sut.addTodo(todo2)

        let todos = sut.fetchTodos()

        XCTAssertEqual(todos.count, 2)
        XCTAssertEqual(todos.first?.title, "A")
    }
    
    func testUpdateTodoStatus_shouldChangeIsCompleted() {
        let todo = TodoEntity(id: 10, title: "To update", description: "", date: Date(), isCompleted: false)
        sut.addTodo(todo)
        
        sut.updateStatus(id: 10, isCompleted: true)
        
        let fetched = sut.fetchTodos().first(where: { $0.id == 10 })
        XCTAssertTrue(fetched?.isCompleted == true)
    }
    
    func testDeleteTodo_shouldRemoveFromCoreData() {
        let todo = TodoEntity(id: 99, title: "To delete", description: "", date: Date(), isCompleted: false)
        sut.addTodo(todo)
        
        sut.deleteTodo(with: 99)
        
        let results = sut.fetchTodos()
        XCTAssertTrue(results.isEmpty)
    }
    
    func testFetchTodos_whenNoData_shouldReturnEmptyArray() {
        let todos = sut.fetchTodos()
        XCTAssertTrue(todos.isEmpty)
    }
    
    func testAddTodo_withSameID_shouldUpdateExisting() {
        let id = 100
        let todo1 = TodoEntity(id: id, title: "First", description: "", date: Date(), isCompleted: false)
        let todo2 = TodoEntity(id: id, title: "Updated", description: "", date: Date(), isCompleted: true)
        
        sut.addTodo(todo1)
        sut.addTodo(todo2)
        
        let result = sut.fetchTodos().first(where: { $0.id == id })
        XCTAssertEqual(result?.title, "Updated")
        XCTAssertTrue(result?.isCompleted == true)
    }
}
