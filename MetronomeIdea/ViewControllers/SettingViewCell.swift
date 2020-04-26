import UIKit

class SettingViewCell: UITableViewCell {
    
    @IBOutlet weak var SettingLabel: UILabel!
    
    func setupCell(isettingLabelText: String = "") {
        SettingLabel.text = isettingLabelText
    }
}
