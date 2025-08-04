//
//  TodoCoreDataService.swift
//  ToDoApp
//
//  Created by Никита Павлов on 03.08.2025.
//

import Foundation
import CoreData
import UIKit

final class TodoCoreDataService {
    private(set) static var shared: TodoCoreDataService!

    static func initializeShared(with context: NSManagedObjectContext) {
        self.shared = TodoCoreDataService(context: context)
    }
    
    private let context: NSManagedObjectContext

    private init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveTodos(_ todos: [TodoEntity]) {
        deleteAllTodos()

        for todo in todos {
            let cdTodo = Todo(context: context)
            cdTodo.id = Int64(todo.id)
            cdTodo.title = todo.title
            cdTodo.todoDesc = todo.description
            cdTodo.date = todo.date
            cdTodo.isCompleted = todo.isCompleted
        }

        saveContext()
    }
    
    func updateTodo(_ todo: TodoEntity) {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", todo.id)

        do {
            if let cdTodo = try context.fetch(request).first {
                cdTodo.title = todo.title
                cdTodo.todoDesc = todo.description
                cdTodo.date = todo.date
                cdTodo.isCompleted = todo.isCompleted
                saveContext()
            }
        } catch {
            print("Ошибка обновления задачи: \(error)")
        }
    }

    func fetchTodos() -> [TodoEntity] {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()

        do {
            let results = try context.fetch(request)
            return results.map {
                TodoEntity(
                    id: Int($0.id),
                    title: $0.title ?? "",
                    description: $0.todoDesc ?? "",
                    date: $0.date ?? Date(),
                    isCompleted: $0.isCompleted
                )
            }
        } catch {
            print("Ошибка загрузки из CoreData: \(error)")
            return []
        }
    }

    func addTodo(_ todo: TodoEntity) {
        let cdTodo = Todo(context: context)
        cdTodo.id = Int64(todo.id)
        cdTodo.title = todo.title
        cdTodo.todoDesc = todo.description
        cdTodo.date = todo.date
        cdTodo.isCompleted = todo.isCompleted
        saveContext()
    }
    
    func deleteTodoFromCoreData(with id: Int) {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            if let todoObject = try context.fetch(fetchRequest).first {
                context.delete(todoObject)
                try context.save()
            } else {
                print("⚠️ Не найден объект с id: \(id)")
            }
        } catch {
            print("❌ Ошибка при удалении объекта из Core Data: \(error)")
        }
    }


    func deleteAllTodos() {
        let request: NSFetchRequest<NSFetchRequestResult> = Todo.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Ошибка удаления: \(error)")
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения CoreData: \(error)")
            }
        }
    }
    
    func updateTodoStatus(id: Int, isCompleted: Bool) {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        do {
            if let todo = try context.fetch(request).first {
                todo.isCompleted = isCompleted
                saveContext()
            }
        } catch {
            print("Ошибка обновления статуса задачи: \(error)")
        }
    }
}
