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
    /*var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Task.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()*/

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Task.self)
        //.modelContainer(sharedModelContainer)
    }
}
