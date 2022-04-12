//
//  ContentView.swift
//  JoshanRai-Instafilter
//
//  Created by Joshan Rai on 4/11/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    
    var body: some View {
        Text("Hello, world!")
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .onTapGesture {
                showingConfirmation = true
            }
            .confirmationDialog("Change Background", isPresented: $showingConfirmation, actions: {
                Button("Red", action: {
                    backgroundColor = Color.red
                })
                Button("Green", action: {
                    backgroundColor = Color.green
                })
                Button("Blue", action: {
                    backgroundColor = Color.blue
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Select a new color")
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
