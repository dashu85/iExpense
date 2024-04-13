//
//  ContentView.swift
//  iExpense
//
//  Created by Marcus Benoit on 12.04.24.
//

import SwiftUI
import Observation

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

struct ContentView: View {
    @State private var user = User()
    
    @State private var showingSheet = false
    
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
