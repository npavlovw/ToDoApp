//
//  TodoCoreDataService.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

import CoreData

class TodoCoreDataService {
    private(set) static var shared: TodoCoreDataService!
    
    private let context: NSManagedObjectContext

    static func initializeShared(with context: NSManagedObjectContext) {
        self.shared = TodoCoreDataService(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public API
    
    func fetchTodos() -> [TodoEntity] {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()

        do {
            let results = try context.fetch(request)
            return results.map { $0.toEntity() }
        } catch {
            print("Ошибка загрузки из CoreData: \(error)")
            return []
        }
    }

    func saveTodos(_ todos: [TodoEntity]) {
        deleteAllTodos()
        todos.forEach { createTodoObject(from: $0) }
        saveContext()
    }
    
    func addTodo(_ todo: TodoEntity) {
        createTodoObject(from: todo)
        saveContext()
    }
    
    func updateTodo(_ todo: TodoEntity) {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()

        do {
            if let object = try context.fetch(request).first {
                object.update(with: todo)
                saveContext()
            }
        } catch {
            print("Ошибка обновления задачи: \(error)")
        }
    }
    
    func updateStatus(for id: Int, isCompleted: Bool) {
        let request = fetchRequest(withID: id)
        do {
            if let object = try context.fetch(request).first {
                object.isCompleted = isCompleted
                saveContext()
            }
        } catch {
            print("Status update error: \(error)")
        }
    }

    func deleteTodo(withID id: Int) {
        let request = fetchRequest(withID: id)
        do {
            if let object = try context.fetch(request).first {
                context.delete(object)
                saveContext()
            } else {
                print("No object found with ID: \(id)")
            }
        } catch {
            print("Delete error: \(error)")
        }
    }

    func deleteAllTodos() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Todo.fetchRequest()
        if context.persistentStoreCoordinator?.persistentStores.first?.type == NSInMemoryStoreType {
            // Для тестов
            if let todos = try? context.fetch(fetchRequest) as? [NSManagedObject] {
                for todo in todos {
                    context.delete(todo)
                }
                try? context.save()
            }
        } else {
            // Для обычного стора
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            _ = try? context.execute(deleteRequest)
            try? context.save()
        }
    }


    // MARK: - Private Helpers
    
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("CoreData save error: \(error)")
        }
    }
    
    private func fetchRequest(withID id: Int) -> NSFetchRequest<Todo> {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        return request
    }
    
    private func createTodoObject(from entity: TodoEntity) {
        let todo = Todo(context: context)
        todo.id = Int64(entity.id)
        todo.title = entity.title
        todo.todoDesc = entity.description
        todo.date = entity.date
        todo.isCompleted = entity.isCompleted
    }
}
