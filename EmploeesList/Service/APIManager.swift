import Foundation

class APIManager {
    func loadData(_ completion: @escaping ([Employee]?) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") else {
            print("URL error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                print("Error: \(error.debugDescription)")
                return
            }
            
            guard let employees = try? JSONDecoder().decode(Root.self, from: data) else {
                print("ERROR: \(error.debugDescription)")
                return }
            DispatchQueue.main.async {
                completion(employees.company.employees)
            }
        }.resume()
    }
}
