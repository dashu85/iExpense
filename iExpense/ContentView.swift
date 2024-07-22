//
//  ContentView.swift
//  iExpense
//
//  Created by Marcus Benoit on 12.04.24.
//

import SwiftData
import SwiftUI
import Observation
// Preparation examples
// in UserDefaults shouldn't be stored more than 512 KB! - because it will be loaded every time the app starts

/* Important: When it comes to you submitting an app to the App Store, Apple asks that you let them know why you're loading and saving data using UserDefaults. This also applies to the @AppStorage property wrapper. It's nothing to worry about, they just want to make sure developers aren't trying to identify users across apps.
 */

@Observable // added so swift can observe if the instance of a class changes, @state doesn't check for that https://www.hackingwithswift.com/books/ios-swiftui/using-state-with-classes and https://www.hackingwithswift.com/books/ios-swiftui/sharing-swiftui-state-with-observable. For classes @State is just there to keep the object alive.
class User {
    var firstName = "Marco"
    var lastName = "Reus"
}

struct secondView: View {
    var name: String
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("Hello \(name)")
        
        Button("Dismiss") {
            dismiss()
        }
    }
}

struct UserCodable: Codable {
    var firstName: String
    var lastName: String
}

// App iExpense ----------------------------------------
//@Observable
//class Expenses {
//    var items = [ExpenseItem]() {
//        didSet {
//            if let encoded = try? JSONEncoder().encode(items) {
//                UserDefaults.standard.set(encoded, forKey: "Items")
//            }
//        }
//    }
//
//    init() {
//        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
//            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
//                items = decodedItems
//                return
//            }
//        }
//        items = []
//    }
//}


struct ContentView: View {
    // Preparation examples
    @State private var exampleNumber = ["1. Using @State with classes (@Observable)", "2. Showing and hiding views (sheet)", "3. Deleting items using .onDelete", "4. Storing user settings using UserDefaults", "5. Storing settings using AppStorage", "6. Archiving Object with Codable", "7. iExpense"]
    @State private var selectedExample = "7. iExpense"
    
    
    @State private var user = User() // @Observable
    
    @State private var showingSheet = false
    
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    
    @State private var tapCountUserDefaults = UserDefaults.standard.integer(forKey: "tap")
    
    @AppStorage("tapCountAppStorage") private var tapCountAppStorage = 0 // accessing UserDefaults through AppStorage property wrapper, "tapCountAppStorage" is the UserDefaults key - it doesn't have to match the property name!
    
    @State private var userCodable = UserCodable(firstName: "Taylor", lastName: "Swift")
    
    // App iExpense -------------------------------------
    //@State private var expenses = Expenses() // empty array from Expenses class
    
    // Challenge 1 - Project 12
    @Environment(\.modelContext) var modelContext
    @State private var filterBy = ""
    @State private var showBoth = true
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
    ]
    @State private var path = [ExpenseItem]()
    
    @State private var showingAddExpense = false
    
    // Project 9 - challenge 1
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker(selection: $selectedExample, label: Text("picker label")) {
                    ForEach(exampleNumber, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.inline)
            }
            
            switch selectedExample {
                
            case "1. Using @State with classes (@Observable)" :
                ScrollView {
                    VStack {
                        Text("Your name is \(user.firstName) \(user.lastName).")
                        
                        TextField("First name:", text: $user.firstName)
                            .padding(10)
                            .background(.green)
                        TextField("Last name:", text: $user.lastName)
                            .padding(10)
                            .background(.gray)
                    }
                    .padding()
                    .background(.yellow)
                    
                    Text("""
                When we use @State, we’re asking SwiftUI to watch a property for changes. So, if we change a string, flip a Boolean, add to an array, and so on, the property has changed and SwiftUI will re-invoke the body property of the view.
                
                When User was a struct, every time we modified a property of that struct Swift was actually creating a new instance of the struct. @State was able to spot that change, and automatically reloaded our view. Now that we have a class, that behavior no longer happens: Swift can just modify the value directly.
                
                Remember how we had to use the mutating keyword for struct methods that modify properties? This is because if we create the struct’s properties as variable but the struct itself is constant, we can’t change the properties – Swift needs to be able to destroy and recreate the whole struct when a property changes, and that isn’t possible for constant structs. Classes don’t need the mutating keyword, because even if the class instance is marked as constant Swift can still modify variable properties.
                
                I know that all sounds terribly theoretical, but here’s the twist: now that User is a class the property itself isn’t changing, so @State doesn’t notice anything and can’t reload the view. Yes, the values inside the class are changing, but @State doesn’t monitor those, so effectively what’s happening is that the values inside our class are being changed but the view isn’t being reloaded to reflect that change.
                
                We can fix this problem with one small change: I'd like you to add the line @Observable before the class.
                """)
                }
                
                
            case "2. Showing and hiding views (sheet)":
                
                VStack {
                    Text("Your name is \(user.firstName) \(user.lastName).")
                    
                    TextField("First name:", text: $user.firstName)
                        .padding(10)
                        .background(.green)
                    TextField("Last name:", text: $user.lastName)
                        .padding(10)
                        .background(.gray)
                }
                .padding()
                .background(.yellow)
                
                Button("Show Sheet") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    secondView(name: user.firstName)
                }
                
            case "3. Deleting items using .onDelete" :
                
                VStack {
                    List {
                        ForEach(numbers, id: \.self) {
                            Text("Row \($0)")
                        }
                        .onDelete(perform: { indexSet in
                            removeRows(at: indexSet)
                        })
                    }
                    
                    Button("Add Number") {
                        numbers.append(currentNumber)
                        currentNumber += 1
                    }
                }
                .toolbar {
                    EditButton()
                }
                
                
            case "4. Storing user settings using UserDefaults" :
                
                VStack {
                    Button("Tap count:  \(tapCountUserDefaults)") {
                        tapCountUserDefaults += 1
                        UserDefaults.standard.set(tapCountUserDefaults, forKey: "tap")
                    }
                }
            case "5. Storing settings using AppStorage" :
                
                VStack {
                    Button("Tap count App Storage: \(tapCountAppStorage)") {
                        tapCountAppStorage += 1
                    }
                }
                
            case "4. Archiving Object with Codable" :
                
                VStack {
                    Text("Your name is \(user.firstName) \(user.lastName).")
                    
                    TextField("First name:", text: $user.firstName)
                        .padding(10)
                        .background(.green)
                    TextField("Last name:", text: $user.lastName)
                        .padding(10)
                        .background(.gray)
                }
                .padding()
                .background(.yellow)
                
                Button("Show Sheet") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    secondView(name: user.firstName)
                }
                
            case "6. Archiving Object with Codable" :
                
                Button("Save User") {
                    let encoder = JSONEncoder()
                    
                    if let data = try? encoder.encode(userCodable) {
                        UserDefaults.standard.set(data, forKey: ("UserData"))
                    }
                }
                
                Text("""
                    That accesses UserDefaults directly rather than going through @AppStorage, because the @AppStorage property wrapper just doesn’t work here.
                     
                    That data constant is a new data type called, perhaps confusingly, Data. It’s designed to store any kind of data you can think of, such as strings, images, zip files, and more. Here, though, all we care about is that it’s one of the types of data we can write straight into UserDefaults.
                    
                    When we’re coming back the other way – when we have JSON data and we want to convert it to Swift Codable types – we should use JSONDecoder rather than JSONEncoder(), but the process is much the same.
                    """)
                
            case "7. iExpense" :
                NavigationStack(path: $path) {
                    FilteredView(showFilter: filterBy, showBoth: showBoth, sortOrder: sortOrder)
                    
                    
                    //                        Section {
                    //                            ForEach(expenses) { item in // id: \.id can be left of since ExpenseItem conforms to Identifiable
                    //                                if item.type == "Personal" {
                    //                                    NavigationLink(value: item) {
                    //                                        HStack {
                    //                                            VStack(alignment: .leading) {
                    //                                                Text(item.name)
                    //                                                    .font(.headline)
                    //                                                Text(item.type)
                    //                                            }
                    //
                    //                                            Spacer()
                    //
                    //                                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    //                                                .foregroundStyle(colorAmount(item: item))
                    //                                        }
                    //                                    }
                    //                                }
                    //                            }
                    //                            //.onDelete(perform: removeItems)
                    //                        }
                    
                        .navigationTitle("iExpense")
                        .navigationDestination(for: ExpenseItem.self) { item in
                            EditItemView(expense: item)
                        }
                        .toolbar {
                            Button("Add expense", systemImage: "plus") {
                                showingAddExpense = true
                            }
                            
                            // Challenge 3 
                            Menu("Filter", systemImage: "equal.square") {
                                
                                Button("Show Both") {
                                    showBoth = true
                                }
                                
                                Button("Show Personal") {
                                    showBoth = false
                                    filterBy = "Personal"
                                }
                                
                                Button("Show Business") {
                                    showBoth = false
                                    filterBy = "Business"
                                }
                            }
                        }
                        .sheet(isPresented: $showingAddExpense) {
                            AddView()
                        }
                }
                
            default:
                Text("something went wrong")
            }
            
            Spacer()
            
        }
    }
    
    func removeRows(at offset: IndexSet) {
        numbers.remove(atOffsets: offset)
    }
    
    //    func removeItems(at offset: IndexSet) {
    //        expenses.remove(atOffsets: offset)
    //    }
}

#Preview {
    ContentView()
}
