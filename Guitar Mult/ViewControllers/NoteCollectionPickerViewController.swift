import UIKit
import CoreData

class NoteCollectionPickerViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var scaleTableView: UITableView!
    @IBOutlet weak var arpeggioTableView: UITableView!
    @IBOutlet weak var recordingTableView: UITableView!
    
    var currentTableView: UITableView!
    
    var cellReuseIdentifier = "ScalePickerViewCell"
    var pickerList:[String] = []
    var selectedCell = -1
    var backgroundImageID = 4
    var recordingInfo: [String] = []
    var vc: MainViewController?
    var navigatingToPaywall = false
    
    let titleTextDict : [String : String] = [
        "recordingPicker" : "Recordings",
        "arpeggioPicker" : "Arpeggios",
        "scalePicker" : "Scales",
    ]
    
    var paywallThreshold : [String : Int] = [
        "recordingPicker" : 10,
        "arpeggioPicker" : 4,
        "scalePicker" : 5,
    ]
      
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
        
        if appUnlocked == "0" && currentAppVersion != "" {
            for (key,_) in titleTextDict {
                paywallThreshold[key] = levelBarriersLimits[currentAppVersion]?[key]
            }
        }
        
        currentTableView = tableView!
        
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
            let stringsToRemove = ["_","Up","Both","Tempo",":","Thirds","Sequence"]
            for (i,_) in pickerList.enumerated() {
                for str in stringsToRemove {
                    pickerList[i] = pickerList[i].replacingOccurrences(of: str, with: "")
                }
                pickerList[i] = pickerList[i].trimmingCharacters(in: CharacterSet(charactersIn: "0123456789:"))
            }
            
            pickerList = pickerList.uniques
        } else {
            //sort time list?
        }

        let styler: ViewStyler?
        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "MainImage\(backgroundImageID).jpg")
        
        let screenHeight = UIScreen.main.bounds.size.height

        if screenHeight <= 736 {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        } else {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigatingToPaywall = false
        vc!.viewingNoteCollection = true
        self.tabBarController?.title = titleTextDict[self.restorationIdentifier!]
        if !self.restorationIdentifier!.contains("record") {
            let freePlayUserDefault = UserDefaults.standard.object(forKey: "freePlayNoteCollection")
            selectedCell = -1
            for (i,item) in pickerList.enumerated() {
                if item == freePlayUserDefault as! String {
                    selectedCell = i
                    break
                }
            }
            currentTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if navigationController?.viewControllers.index(of: self) == nil && selectedCell > -1 && !self.restorationIdentifier!.contains("record") {
            UserDefaults.standard.set(pickerList[selectedCell], forKey: "freePlayNoteCollection")
        } else if self.restorationIdentifier!.contains("record") && selectedCell > -1 && navigatingToPaywall == false {
            vc!.handleFretOffsetChange()
        }
        switch self.restorationIdentifier! {
        case "scalePicker":
            vc?.lastPickedFreePlayMenuIndex = 0
        case "arpeggioPicker":
            vc?.lastPickedFreePlayMenuIndex = 1
        default:
            vc?.lastPickedFreePlayMenuIndex = 2
        }
        metronome2.stop()
        metronome2.reset()
        vc!.viewingNoteCollection = false
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
        tableView.tableFooterView = UIView(frame: .zero)
        cell.tintColor = UIColor.black
        
        cell.accessoryType = indexPath.row == selectedCell ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if appUnlocked == "0" && indexPath.row > paywallThreshold[self.restorationIdentifier!]! {
            navigationController?.popViewController(animated: false)
            navigatingToPaywall = true
            vc?.presentPaywallPopover();
            return
        }
        
        for row in 0 ..< tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
//                cell.accessoryType = row == indexPath.row ? .checkmark : .none
                cell.accessoryType = .none
            }
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! SettingViewCell
//        cell.accessoryType = .checkmark
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        selectedCell = indexPath.row

        //play sound upon press
        vc?.wt.stopWaitThenOfType(iselector: #selector(vc?.playSoundHelper) as Selector)
        if self.restorationIdentifier == "scalePicker" || self.restorationIdentifier == "arpeggioPicker"  {
            if appUnlocked == "0" && indexPath.row > paywallThreshold[self.restorationIdentifier!]! {
                metronome2.stop()
                metronome2.reset()
            } else {
                vc?.specifiedNoteCollection = vc?.sCollection!.setupSpecifiedNoteCollection(iinput: pickerList[indexPath.row], idirection: "up", istartingNote: "A1") as! [String]
                vc?.met?.startMetro()
                metronome2.tempo = 300
            }
        } else {
            vc?.currentRecordingId = pickerList[selectedCell]
            if vc?.currentRecordingId != "" {
                vc?.playRecording(true)
            }
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as MyCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! SettingViewCell
        // no "if" - the cell is guaranteed to exist
        // ... do stuff to the cell here ...
        cell.textLabel!.text = "butt"// ... whatever
        // ...
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//    }
//
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        vc!.wt.stopWaitThenOfType(iselector: #selector(vc!.playSoundHelper) as Selector)
    }
}
