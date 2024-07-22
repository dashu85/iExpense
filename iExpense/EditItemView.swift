//
//  EditItemView.swift
//  iExpense
//
//  Created by Marcus Benoit on 31.05.24.
//

import SwiftData
import SwiftUI

struct EditItemView: View {
    @Bindable var expense: ExpenseItem
    
    var body: some View {
        Form {
            TextField("Name: ", text: $expense.name)
            TextField("Type: ", text: $expense.type)
            TextField("Amount: ", value: $expense.amount, format: .currency(code: "EUR"))
                .keyboardType(.decimalPad)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        let expense = ExpenseItem(name: "ExpenseItem", type: "Business", amount: 200)
        
        return EditItemView(expense: expense)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
