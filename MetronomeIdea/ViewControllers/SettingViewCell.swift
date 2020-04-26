import UIKit

class SettingViewCell: UITableViewCell {
    @IBOutlet var SettingLabel: UILabel!

    func setupCell(isettingLabelText: String = "") {
        SettingLabel.text = isettingLabelText
    }
}
