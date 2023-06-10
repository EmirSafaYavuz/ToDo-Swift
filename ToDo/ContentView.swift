//
//  ContentView.swift
//  ToDo
//
//  Created by Emir Safa Yavuz on 10.06.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
        let persistenceController = PersistenceController.shared
    
    var body: some View {
        TabView{
            ToDoView()
                .tabItem{
                    Image(systemName: "list.bullet")
                    Text("ToDo")
                }
            
            CompletedView()
                .tabItem{
                    Image(systemName: "checkmark")
                    Text("Completed")
                }
            
            PendingView()
                .tabItem{
                    Image(systemName: "clock")
                    Text("Pending")
                }
            
            OverdueView()
                .tabItem{
                    Image(systemName: "clock.badge.exclamationmark")
                    Text("Overdue")
                }
        }
    }
}
