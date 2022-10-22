import Foundation
import Network

class EmployeesViewModel {
    private let service = APIManager()
    private let dataStoreManager = DataStoreManager()
    private let queue = DispatchQueue(label: "InternetConnectionMonitor")
    private let monitor = NWPathMonitor()
    var connection = false {
        didSet {
            if oldValue != connection {
                showConnectionLabel?()
            }
        }
    }

    var employeesList = [Employee]() {
        didSet {
            reloadTableView?()
        }
    }
    
    var reloadTableView: (() -> Void)?
    var showConnectionLabel: (() -> Void)?
    
    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connection = true
            } else {
                self.connection = false
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func getStoredData() {
        guard var storedData = self.dataStoreManager.fetchData() else { return }
        
        if !storedData.isEmpty {
            storedData = storedData.sorted(by: { $0.name ?? "" < $1.name ?? ""})
            let currentTime = Date()
            guard let saveTime = storedData[0].saveTime else { return }
                    
            let diff = Calendar.current.dateComponents([.second], from: saveTime, to: currentTime)
            guard let diffSeconds = diff.second else { return }
            
            if diffSeconds >= 3600 {
                dataStoreManager.removeAllData()
                self.employeesList.removeAll()
            } else {
                convertStoredData(from: storedData)
            }
        } else { return }
    }
    
    func getData() {
        service.loadData { data in
            guard let data = data else { return }
            
            for item in data {
                self.dataStoreManager.saveData(from: item)
            }
            
            self.getStoredData()
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> Employee {
        return employeesList[indexPath.row]
    }
    
    private func convertStoredData(from model: [EmployeeDataModel]) {
        for item in model {
            let newData = Employee(
                name: item.name ?? "",
                phoneNumber: item.phoneNumber ?? "",
                skills: item.skills?.components(separatedBy: ", ") ?? [])
            employeesList.append(newData)
        }
    }
}
