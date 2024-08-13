//
//  whatnextApp.swift
//  whatnext
//
//  Created by Sid Ajay on 8/11/24.
//

import SwiftUI
import SwiftData

@main

struct whatnextApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Task.self)
            .environmentObject(UserSettings())
    }
}
