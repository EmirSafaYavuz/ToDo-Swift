//
//  ToDoApp.swift
//  ToDo
//
//  Created by Emir Safa Yavuz on 10.06.2023.
//

import SwiftUI

@main
struct ToDoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
