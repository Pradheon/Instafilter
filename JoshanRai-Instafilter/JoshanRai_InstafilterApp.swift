//
//  JoshanRai_InstafilterApp.swift
//  JoshanRai-Instafilter
//
//  Created by Joshan Rai on 4/11/22.
//

import SwiftUI

@main
struct JoshanRai_InstafilterApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
