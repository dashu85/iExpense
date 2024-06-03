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
            TextField("Amount: ", value: $expense.amount, )
        }
    }
}

#Preview {
    EditItemView()
}
