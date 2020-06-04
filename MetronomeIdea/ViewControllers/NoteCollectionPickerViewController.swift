import UIKit
import CoreData

class NoteCollectionPickerViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var scaleTableView: UITableView!
    @IBOutlet weak var arpeggioTableView: UITableView!
    @IBOutlet weak var recordingTableView: UITableView!
    
    var cellReuseIdentifier = "ScalePickerViewCell"
    var pickerList:[String] = []
    var selectedCell = -1
    var backgroundImageID = 0
    var recordingInfo: [String] = []
    var vc: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        
        var tableView = scaleTableView
        if self.restorationIdentifier == "arpeggioPicker" {
            tableView = arpeggioTableView
        } else if self.restorationIdentifier == "recordingPicker" {
            tableView = recordingTableView
            let fetchRequest: NSFetchRequest<RecordingData> = RecordingData.fetchRequest()
            if let results = try? globalDataController.viewContext.fetch(fetchRequest) {
                for result in results {
                    pickerList.append(result.id!)
                }
                pickerList.reverse()
                for (i,id) in pickerList.enumerated() {
                    if id == vc?.currentRecordingId {
                        selectedCell = i
                        break
                    }
                }
            }
        }
        
        UITabBar.appearance().tintColor = UIColor.white
        tableView!.backgroundColor = UIColor.clear
        
        UITabBar.appearance().barTintColor = defaultColor.MenuButtonColor
        tabBarController?.tabBar.barStyle = UIBarStyle.blackOpaque
        tabBarController?.tabBar.isTranslucent = false
       
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
        if !self.restorationIdentifier!.contains("record") {
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
        } else {
            //sort time list?
        }

        var styler: ViewStyler?
        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "MainImage\(backgroundImageID).jpg")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if navigationController?.viewControllers.index(of: self) == nil && selectedCell > -1 && !self.restorationIdentifier!.contains("record") {
            UserDefaults.standard.set(pickerList[selectedCell], forKey: "freePlayNoteCollection")
        } else if self.restorationIdentifier!.contains("record") && selectedCell > -1 {
        }
        switch self.restorationIdentifier! {
        case "scalePicker":
            vc?.lastPickedFreePlayMenuIndex = 0
        case "arpeggioPicker":
            vc?.lastPickedFreePlayMenuIndex = 1
        default:
            vc?.lastPickedFreePlayMenuIndex = 2
        }
        vc?.wt.stopWaitThenOfType(iselector: #selector(vc?.playSoundHelper) as Selector)
        UIView.setAnimationsEnabled(false)
        super.viewWillDisappear(animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cellReuseIdentifier = self.restorationIdentifier == "scalePicker" ? "ScalePickerViewCell" : "ArpeggioPickerViewCell"
        if self.restorationIdentifier == "scalePicker" {
            cellReuseIdentifier = "ScalePickerViewCell"
        } else if self.restorationIdentifier == "arpeggioPicker" {
            cellReuseIdentifier = "ArpeggioPickerViewCell"
        } else {
            cellReuseIdentifier = "RecordingPickerViewCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! SettingViewCell
        let labelStr = !cellReuseIdentifier.contains("Record") ? ScaleCollection(ivc: MainViewController()).returnReadableScaleName(iinput: pickerList[(indexPath as NSIndexPath).row]) : pickerList[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = labelStr
//        cell.textLabel?.textColor = defaultColor.MenuButtonTextColor
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
        
        //play sound upon press
        vc?.wt.stopWaitThenOfType(iselector: #selector(vc?.playSoundHelper) as Selector)
        if self.restorationIdentifier == "scalePicker" || self.restorationIdentifier == "arpeggioPicker"  {
            vc?.setupMenuNoteCollectionPlayback(iinput: pickerList[indexPath.row])
        } else {
            vc?.currentRecordingId = pickerList[selectedCell]
            if vc?.currentRecordingId != "" {
                vc?.playRecording()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
}
