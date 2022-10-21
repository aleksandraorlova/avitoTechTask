import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var connectionLabel: UILabel!
    private var viewModel = EmployeesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: EmployeeTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func initViewModel() {
        viewModel.showConnectionLabel = { [self] in
            if self.viewModel.connection && self.viewModel.employeesList.isEmpty {
                self.viewModel.getData()
            }

            DispatchQueue.main.async {
                self.changeConnectionLabel()
            }
        }

        viewModel.checkConnection()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func changeConnectionLabel() {
        connectionLabel.isHidden = viewModel.connection ? true : false
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.employeesList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.id, for: indexPath) as? EmployeeTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.cellModel = cellViewModel
        cell.selectionStyle = .none
        return cell
    }
}

