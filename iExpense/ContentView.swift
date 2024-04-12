//
//  ContentView.swift
//  iExpense
//
//  Created by Marcus Benoit on 12.04.24.
//

import SwiftUI

@Observable // added so swift can observe if the instance of a class changes, @state doesn't check for that https://www.hackingwithswift.com/books/ios-swiftui/using-state-with-classes
class User {
    var firstName = "Marco"
    var lastName = "Reus"
}

struct ContentView: View {
    @State private var user = User()
    
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
    }
}

#Preview {
    ContentView()
}
