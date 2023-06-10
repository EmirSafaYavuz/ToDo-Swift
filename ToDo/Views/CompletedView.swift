//
//  CompletedView.swift
//  ToDo
//
//  Created by Emir Safa Yavuz on 10.06.2023.
//

import SwiftUI

struct CompletedView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.time?.endTime, ascending: true)],
        predicate: NSPredicate(format: "isCompleted == true"),
        animation: .default)
    private var items: FetchedResults<ToDoItem>
    
    var body: some View {
        NavigationView {
            List {
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("Completed")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedView()
    }
}
