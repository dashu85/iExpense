//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Marcus Benoit on 12.04.24.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
