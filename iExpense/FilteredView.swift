//
//  FilteredView.swift
//  iExpense
//
//  Created by Marcus Benoit on 03.06.24.
//

import SwiftData
import SwiftUI


struct FilteredView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    
    var body: some View {
        Section("Section") {
            List(expenses) { item in // id: \.id can be left of since ExpenseItem conforms to Identifiable
                    NavigationLink(value: item) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                    .swipeActions {
                                        Button("Delete", systemImage: "trash", role: .destructive) {
                                            modelContext.delete(item)
                                        }
                                    }
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                                .foregroundStyle(colorAmount(item: item))
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Category \(item.type), \(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "EUR")) for \(item.name)")
                    }
                
            }
            //.onDelete(perform: removeItems)
        }
    }
    
    init(showFilter: String, showBoth: Bool, sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(filter: #Predicate<ExpenseItem> { expense in
            if !showBoth {
                expense.type == showFilter } else {
                    expense.type == "Personal" || expense.type == "Business"
                }
        }, sort: sortOrder)
    }
    
    func colorAmount(item: ExpenseItem) -> Color {
        switch item.amount {
            
        case _ where item.amount < 10 :
                .green
        case _ where item.amount < 100 :
                .orange
        default:
                .red
        }
    }
}

#Preview {
    FilteredView(showFilter: "Personal", showBoth: false, sortOrder: [SortDescriptor(\ExpenseItem.name)])
        .modelContainer(for: ExpenseItem.self)
}
