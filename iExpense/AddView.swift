//
//  AddView.swift
//  iExpense
//
//  Created by Marcus Benoit on 16.04.24.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var value = 0.0
    
    var expenses: Expenses
    
    let types = ["Personal", "Business"]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Please enter a name", text: $name)
                
                Picker("Type: ", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $value, format: .currency(code: "EUR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: value)
                    expenses.items.append(item)
                        dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
