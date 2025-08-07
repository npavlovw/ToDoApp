//
//  ToDoEntity.swift
//  ToDoApp
//
//  Created by Никита Павлов on 01.08.2025.
//
import Foundation

struct TodoEntity: Equatable {
    let id: Int
    var title: String
    var description: String
    var date: Date
    var isCompleted: Bool
}
