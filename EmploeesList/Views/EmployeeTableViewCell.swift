import UIKit

class EmployeeTableViewCell: UITableViewCell {
    static let id = "EmployeeTableViewCell"
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var phoneLabel: UILabel!
    @IBOutlet private var skillsLabel: UILabel!
    var cellModel: Employee? {
        didSet {
            nameLabel.text = cellModel?.name
            phoneLabel.text = cellModel?.phoneNumber
            skillsLabel.text = cellModel?.skills.joined(separator: ", ")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
