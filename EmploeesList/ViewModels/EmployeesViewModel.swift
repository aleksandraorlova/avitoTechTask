import Foundation
import Network

class EmployeesViewModel {
    private let service = APIManager()
    private let queue = DispatchQueue(label: "InternetConnectionMonitor")
    private let monitor = NWPathMonitor()
    var connection = false {
        didSet {
            showConnectionLabel?()
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
    
    func getData() {
        service.loadData { data in
            guard let data = data else { return }
            
            self.employeesList.append(contentsOf: data.sorted(by: { $0.name < $1.name }))
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> Employee {
        return employeesList[indexPath.row]
    }
}
