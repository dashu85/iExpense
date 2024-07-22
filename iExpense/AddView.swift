//
//  AddView.swift
//  iExpense
//
//  Created by Marcus Benoit on 16.04.24.
//

import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @State private var name = "Name of expense"
    @State private var type = "Personal"
    @State private var value = 0.0
    
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
            .navigationTitle("Add an expense")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        let newExpense = ExpenseItem(name: name, type: type, amount: value)
                        modelContext.insert(newExpense)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    //    do {
    //        let config = ModelConfiguration(isStoredInMemoryOnly: true)
    //        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
    //        let expense = ExpenseItem(name: "ExpenseItem", type: "Business", amount: 200)
    //
    //        return AddView(expense: expense)
    //            .modelContainer(container)
    //    } catch {
    //        return Text("Failed to create container: \(error.localizedDescription)")
    //    }
    AddView()
}
