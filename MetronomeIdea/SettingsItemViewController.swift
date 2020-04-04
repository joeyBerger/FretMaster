import Foundation
import UIKit

class SettingsItemViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellReuseIdentifier = "SettingViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//    }
    
    var settingStrings:[String] = []
    var settingsType: String?
    
    func setupSettingsCellData(isettingStrings: [String]) {
        settingStrings = isettingStrings
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingStrings.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier)! as! SettingViewCell
        let labelStr = self.settingStrings[(indexPath as NSIndexPath).row]
        cell.setupCell(isettingLabelText: labelStr)
//        cell.textLabel?.text = labelStr
        tableView.tableFooterView = UIView(frame: .zero)
        
        if (indexPath.row == 1) {
            print("got index")
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            cell.accessoryType = .checkmark
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let someCharacter: Character = "z"
        switch settingsType {
        case "guitarTone":
            //set vc sound to mod
            print("The first letter of the alphabet")
        case "dotValue":
            //set vc dot to mod
            print("The last letter of the alphabet")
        case "clickTone":
            //set vc sound to mod
            print("The last letter of the alphabet")
        default:
            print("error")
        }
        //https://www.youtube.com/watch?time_continue=397&v=5MZ-WJuSdpg&feature=emb_logo
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark

        print("getting here \(indexPath.row)")
    }
}
