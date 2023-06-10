//
//  AddItemView.swift
//  ToDo
//
//  Created by Emir Safa Yavuz on 10.06.2023.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var newItemTitle = ""
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    TextField("New Item", text: $newItemTitle)
                        .padding(10)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    DatePicker("Due Date", selection: $dueDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    
                    Button("Add Item") {
                        let newItem = ToDoItem(context: viewContext)
                        newItem.title = newItemTitle
                        newItem.time?.startTime = Date()
                        newItem.time?.endTime = dueDate
                        newItem.isCompleted = false
                        // Set additional properties of the ToDoItem
                        
                        do {
                            try viewContext.save()
                        } catch {
                            // Handle the error
                            print("Error saving context: \(error)")
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderless)
                    .padding(10)
                    
                    Spacer()
                }
                .navigationTitle("Add")
                .frame(maxHeight: geometry.size.height)
                .cornerRadius(10)
            }
        }
    }
}



struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
