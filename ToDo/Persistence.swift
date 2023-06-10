//
//  Persistence.swift
//  ToDo
//
//  Created by Emir Safa Yavuz on 10.06.2023.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Hata durumunu kontrol et
                print("Unresolved error \(error), \(error.userInfo)")
            } else {
                let viewContext = self.container.viewContext
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ToDoItem")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try viewContext.execute(batchDeleteRequest)
                } catch {
                    print("Error deleting existing records: \(error)")
                }

                
                // Hata yok, ToDo öğelerini oluştur
                for i in 1...10 {
                    let todoItem = ToDoItem(context: viewContext)
                    todoItem.title = "ToDo \(i)"
                    todoItem.isCompleted = false
                    // Ek özellikleri burada ayarlayabilirsiniz
                    print(todoItem.title ?? "")
                }
                
                // Değişiklikleri kaydet
                do {
                    try viewContext.save()
                } catch {
                    print("Error saving context: \(error)")
                }
            }
        })

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
