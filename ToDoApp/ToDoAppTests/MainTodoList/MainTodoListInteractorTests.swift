//
//  MainTodoListInteractorTests.swift
//  ToDoApp
//
//  Created by Никита Павлов on 10.08.2025.
//

import XCTest
import CoreData

@testable import ToDoApp

final class MainTodoListInteractorTests: XCTestCase {

    // MARK: - Mocks
    
    final class MockUserDefaults: UserDefaults {
        var boolValue = false
        var setCalledForKey: String?

        override func bool(forKey defaultName: String) -> Bool {
            return boolValue
        }

        override func set(_ value: Any?, forKey defaultName: String) {
            setCalledForKey = defaultName
        }
    }

    final class MockCoreDataService: TodoCoreDataService {
        var savedTodos: [TodoEntity] = []
        var fetchCalled = false

        override init(context: NSManagedObjectContext) {
            super.init(context: context)
        }

        override func saveTodos(_ todos: [TodoEntity]) {
            savedTodos = todos
        }

        override func fetchTodos() -> [TodoEntity] {
            fetchCalled = true
            return savedTodos
        }
    }

    final class MockNetworkService: TodoNetworkServiceProtocol {
        var fetchCalled = false
        var resultToReturn: Result<[TodoEntity], Error>?

        func fetchTodos(completion: @escaping (Result<[TodoEntity], Error>) -> Void) {
            fetchCalled = true
            if let result = resultToReturn {
                completion(result)
            }
        }
    }

    final class MockOutput: MainTodoListInteractorOutput {
        var didFetchTodosCalled = false
        var receivedTodos: [TodoEntity]?

        func didFetchTodos(_ todos: [TodoEntity]) {
            didFetchTodosCalled = true
            receivedTodos = todos
        }
    }

    // MARK: - Helpers

    private func makeInMemoryContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "ToDoApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        return container.viewContext
    }

    // MARK: - Tests

    func testFetchTodos_FirstLaunch_FetchesFromNetwork() {
        let context = makeInMemoryContext()
        let mockUserDefaults = MockUserDefaults()
        mockUserDefaults.boolValue = false

        let mockCoreData = MockCoreDataService(context: context)
        let mockNetwork = MockNetworkService()
        let expectedTodos = [
            TodoEntity(id: 1, title: "Test1", description: "", date: Date(), isCompleted: false),
            TodoEntity(id: 2, title: "Test2", description: "", date: Date(), isCompleted: true)
        ]
        mockNetwork.resultToReturn = .success(expectedTodos)

        let interactor = MainTodoListInteractor(userDefaults: mockUserDefaults,
                                                coreDataService: mockCoreData,
                                                networkService: mockNetwork)

        let mockOutput = MockOutput()
        interactor.output = mockOutput

        let expectation = self.expectation(description: "Fetch todos from network")

        interactor.fetchTodos()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockNetwork.fetchCalled)
            XCTAssertEqual(mockCoreData.savedTodos.count, expectedTodos.count)
            XCTAssertEqual(mockUserDefaults.setCalledForKey, "hasLaunchedBefore")
            XCTAssertTrue(mockOutput.didFetchTodosCalled)
            XCTAssertEqual(mockOutput.receivedTodos?.count, expectedTodos.count)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testFetchTodos_FirstLaunch_NetworkFailure_ReturnsEmpty() {
        let context = makeInMemoryContext()
        let mockUserDefaults = MockUserDefaults()
        mockUserDefaults.boolValue = false

        let mockCoreData = MockCoreDataService(context: context)
        let mockNetwork = MockNetworkService()
        mockNetwork.resultToReturn = .failure(NSError(domain: "Test", code: 1, userInfo: nil))

        let interactor = MainTodoListInteractor(userDefaults: mockUserDefaults,
                                                coreDataService: mockCoreData,
                                                networkService: mockNetwork)

        let mockOutput = MockOutput()
        interactor.output = mockOutput

        let expectation = self.expectation(description: "Network failure returns empty todos")

        interactor.fetchTodos()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockNetwork.fetchCalled)
            XCTAssertTrue(mockCoreData.savedTodos.isEmpty)
            XCTAssertNil(mockUserDefaults.setCalledForKey)
            XCTAssertTrue(mockOutput.didFetchTodosCalled)
            XCTAssertEqual(mockOutput.receivedTodos?.count, 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testFetchTodos_NotFirstLaunch_FetchesFromCoreData() {
        let context = makeInMemoryContext()
        let mockUserDefaults = MockUserDefaults()
        mockUserDefaults.boolValue = true

        let mockCoreData = MockCoreDataService(context: context)
        let expectedTodos = [
            TodoEntity(id: 3, title: "Local1", description: "", date: Date(), isCompleted: false)
        ]
        mockCoreData.savedTodos = expectedTodos

        let mockNetwork = MockNetworkService()

        let interactor = MainTodoListInteractor(userDefaults: mockUserDefaults,
                                                coreDataService: mockCoreData,
                                                networkService: mockNetwork)

        let mockOutput = MockOutput()
        interactor.output = mockOutput

        let expectation = self.expectation(description: "Fetch todos from CoreData")

        interactor.fetchTodos()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(mockNetwork.fetchCalled)
            XCTAssertTrue(mockCoreData.fetchCalled)
            XCTAssertTrue(mockOutput.didFetchTodosCalled)
            XCTAssertEqual(mockOutput.receivedTodos?.count, expectedTodos.count)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
