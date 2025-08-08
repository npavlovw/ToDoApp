//
//  DateFormatter+Extension.swift
//  ToDoApp
//
//  Created by Никита Павлов on 09.08.2025.
//

import Foundation

extension DateFormatter {
    static let todoShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
}
