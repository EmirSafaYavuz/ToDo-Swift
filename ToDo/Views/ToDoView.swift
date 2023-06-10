//
//  ToDoView.swift
//  ToDo
//
//  Created by Emir Safa Yavuz on 10.06.2023.
//

import SwiftUI
import CoreData

struct ToDoView: View {
    @State private var isShowingAddItemSheet = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.time?.endTime, ascending: true)],
        predicate: NSPredicate(format: "isCompleted == false"),
        animation: .default)
    private var items: FetchedResults<ToDoItem>
    
    
    var body: some View {
        NavigationView {
            List() {
                ForEach(items) { item in
                    NavigationLink(destination: Text("Item at \(item.time?.startTime ?? Date(), formatter: itemFormatter)")) {
                        Text(item.title ?? "")
                    }
                    .padding(.vertical, 10)
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            // Tamamlama işlemi
                            item.isCompleted = true
                            // İlgili değişiklikleri kaydetmek için gerekli işlemler
                            do {
                                try viewContext.save()
                            } catch {
                                // Hata durumu
                            }
                        }) {
                            Label("Completed", systemImage: "checkmark")
                                .foregroundColor(.green)
                        }
                        .tint(.green)
                    }
                    .swipeActions(edge: .leading){
                        Button(action: {
                            deleteItems(offsets: IndexSet(integer: items.firstIndex(of: item)!))
                        }) {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                        .tint(.red)
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isShowingAddItemSheet = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .sheet(isPresented: $isShowingAddItemSheet) {
                        AddItemView()
                    }
                }
            }
            .navigationTitle("Todo's")
            
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = ToDoItem(context: viewContext)
            newItem.time?.startTime = Date()
            newItem.time?.endTime = Date()
            newItem.isCompleted = false
            newItem.title = "Deneme"
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    struct ToDoView_Previews: PreviewProvider {
        static var previews: some View {
            ToDoView()
        }
    }
}
