//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Marcus Benoit on 16.04.24.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String
    var amount: Double
}
