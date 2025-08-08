//
//  Todo+Extensions.swift
//  ToDoApp
//
//  Created by Никита Павлов on 08.08.2025.
//

import Foundation

extension Todo {
    func toEntity() -> TodoEntity {
        TodoEntity(
            id: Int(self.id),
            title: self.title ?? "",
            description: self.todoDesc ?? "",
            date: self.date ?? Date(),
            isCompleted: self.isCompleted
        )
    }

    func update(with entity: TodoEntity) {
        self.title = entity.title
        self.todoDesc = entity.description
        self.date = entity.date
        self.isCompleted = entity.isCompleted
    }
}
