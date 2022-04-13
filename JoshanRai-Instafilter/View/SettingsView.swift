//
//  SettingsView.swift
//  JoshanRai-Instafilter
//
//  Created by Joshan Rai on 4/12/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                } header: {
                    Text("Preffered Color Scheme")
                }
                Section {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .tint(isDarkMode ? Color(red: 0.477, green: 0.505, blue: 1.000) : .accentColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
