import UIKit

class NoteCollectionPickerViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var scaleTableView: UITableView!
    @IBOutlet weak var arpeggioTableView: UITableView!
    
    var cellReuseIdentifier = "ScalePickerViewCell"
    var pickerList:[String] = [""]
    var selectedCell = 0
    var backgroundImageID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        let tableView = self.restorationIdentifier == "scalePicker" ? scaleTableView : arpeggioTableView
        tableView!.backgroundColor = UIColor.clear
        
        UITabBar.appearance().barTintColor = defaultColor.MenuButtonColor
        tabBarController?.tabBar.barStyle = UIBarStyle.blackOpaque
        tabBarController?.tabBar.isTranslucent = false
        
        pickerList.removeAll()
        let noteCollection = self.restorationIdentifier == "scalePicker" ? LevelConstruct().scale : LevelConstruct().arpeggio
        for exerciseArr in noteCollection {
            for exercise in exerciseArr {
                pickerList.append(exercise)
            }
        }
        let stringsToRemove = ["_","Up","Both","Tempo"]
        for (i,_) in pickerList.enumerated() {
            for str in stringsToRemove {
                pickerList[i] = pickerList[i].replacingOccurrences(of: str, with: "")
            }
        }
        pickerList = pickerList.uniques
        
        let freePlayUserDefault = UserDefaults.standard.object(forKey: "freePlayNoteCollection")
        selectedCell = -1
        for (i,item) in pickerList.enumerated() {
            if item == freePlayUserDefault as! String {
                selectedCell = i
                break
            }
        }
        
        var styler: ViewStyler?
        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "MainImage\(backgroundImageID).jpg")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if navigationController?.viewControllers.index(of: self) == nil && selectedCell > -1 {
            UserDefaults.standard.set(pickerList[selectedCell], forKey: "freePlayNoteCollection")
        }
        super.viewWillDisappear(animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellReuseIdentifier = self.restorationIdentifier == "scalePicker" ? "ScalePickerViewCell" : "ArpeggioPickerViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! SettingViewCell
        let labelStr = ScaleCollection(ivc: MainViewController()).returnReadableScaleName(iinput: pickerList[(indexPath as NSIndexPath).row])
        cell.textLabel?.text = labelStr
        tableView.tableFooterView = UIView(frame: .zero)
        cell.tintColor = UIColor.black
        if indexPath.row == selectedCell {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0 ..< tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        selectedCell = indexPath.row
    }
}
