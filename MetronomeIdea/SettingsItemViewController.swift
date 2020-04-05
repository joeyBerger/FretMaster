import Foundation
import UIKit

class SettingsItemViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var settingStrings:[String] = []
    var settingsType: String?
    var initialCheckmarkIdx = 0
    let cellReuseIdentifier = "SettingViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.backgroundColor = UIColor.black
        //TODO: style table cell
        
        
        print("settingsType \(settingsType)")
        let defaultKey = UserDefaults.standard.object(forKey: settingsType!)
        initialCheckmarkIdx = settingStrings.firstIndex(of: defaultKey! as! String)!
    }
    
    func setupSettingsCellData(isettingsType: String, isettingStrings: [String]) {
        settingsType = isettingsType
        settingStrings = isettingStrings
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingStrings.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier)! as! SettingViewCell
        let labelStr = self.settingStrings[(indexPath as NSIndexPath).row]
//        cell.setupCell(isettingLabelText: labelStr)
        cell.textLabel?.text = labelStr
        tableView.tableFooterView = UIView(frame: .zero)
        
        if (indexPath.row == self.initialCheckmarkIdx) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.black
        //TODO: style table cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(settingStrings[indexPath.row], forKey: settingsType!)
        //https://www.youtube.com/watch?time_continue=397&v=5MZ-WJuSdpg&feature=emb_logo
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
}
