import Foundation
import CoreData

class DataStoreManager {
    static let instance = DataStoreManager()
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EmploeesList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = DataStoreManager.persistentContainer.viewContext
    
    func saveContext () {
        let context = DataStoreManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveData(from model: Employee) {
        let employee = EmployeeDataModel(context: viewContext)
        employee.name = model.name
        employee.phoneNumber = model.phoneNumber
        employee.skills = model.skills.joined(separator: ", ")
        let dateToday = Date()
        employee.saveTime = dateToday
        do {
            try viewContext.save()
            print("Successful save.")
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    func fetchData() -> [EmployeeDataModel]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeDataModel")
        if let records = try? viewContext.fetch(fetchRequest) as? [EmployeeDataModel] {
            print("Successful fetch.")
            return records
        } else {
            print("Could not fetch.")
            return nil
        }
    }
    
    func removeAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeDataModel")
        if let records = try? viewContext.fetch(fetchRequest) as? [EmployeeDataModel] {
            for item in records {
                viewContext.delete(item)
                try? viewContext.save()
            }
        }
    }
}
