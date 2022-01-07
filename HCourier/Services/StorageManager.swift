//
//  StorageManager.swift
//  HCourier
//
//  Created by Artur Anissimov on 05.01.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func getAllAddresses(completion: (Result<[Address], Error>) -> Void) {
        
        let fetchRequest = Address.fetchRequest()
        
        do {
            let addresses = try viewContext.fetch(fetchRequest)
            completion(.success(addresses))
        } catch {
            completion(.failure(error))
        }
    }
    
    func addAddressesToCoreData(from data: [AddressData]) {
        data.forEach { address in
            guard let entity = NSEntityDescription.entity(forEntityName: "Address", in: StorageManager.shared.viewContext) else { return}
            let newAddress = NSManagedObject(entity: entity, insertInto: StorageManager.shared.viewContext)
            
            newAddress.setValue(address.street, forKey: "street")
            newAddress.setValue(address.houseNumber, forKey: "houseNumber")
            newAddress.setValue(address.doorCode, forKey: "doorCode")
            newAddress.setValue(address.desc, forKey: "desc")
            newAddress.setValue(address.apartamentNumber, forKey: "apartamentNumber")
        }
    }
    
    func deleteAllAddresses() {
        do {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")
            let deleteAll = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            try viewContext.execute(deleteAll)
            saveContext()
        } catch {
            print("Error! deleteAllAddresses()")
        }
    }
    
    // MARK: - Core Data stack

    private var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Address")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
