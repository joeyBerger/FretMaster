import Foundation
import UIKit

class SettingsItemViewController : UIViewController, UITableViewDataSource {

    let cellReuseIdentifier = "SettingViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//    }
    
    var settingStrings:[String] = []
    
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let selectedTrail = trails[indexPath.row]
//
//        if let viewController = storyboard?.instantiateViewController(identifier: "TrailViewController") as? TrailViewController {
//            viewController.trail = selectedTrail
//            navigationController?.pushViewController(viewController, animated: true)
//        }
        
        print("getting here")
    }
}
