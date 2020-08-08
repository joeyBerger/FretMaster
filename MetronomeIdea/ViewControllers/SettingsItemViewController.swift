import Foundation
import UIKit

class SettingsItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var settingStrings: [String] = []
    var settingsType: String?
    var initialCheckmarkIdx = 0
    var selectedCell = 0
    let cellReuseIdentifier = "SettingViewCell"
    let sc = SoundController(isubInstances: 10)
    let soundStringDict = [
        "clickTone_Digital": "Click_Digital",
        "clickTone_Woodblock1": "Click_Woodblock1",
        "clickTone_Woodblock2": "Click_Woodblock2",
        "guitarTone_Acoustic": "Selection_Acoustic",
        "guitarTone_Rock": "Selection_Rock",
        "guitarTone_Jazz": "Selection_Jazz",
    ]
    let titleTextDict : [String : String] = [
        "fretDot" : "Fretboard Dot",
        "guitarTone" : "Guitar Sound",
        "clickTone" : "Click Sound",
        "freePlay" : "Free Play",
        "rhythmicAccuracy" : "Rhythmic Accuracy",
        "volumeControl" : "Control Volume"
    ]
    var changeButton = UIButton()
    var backgroundImageID = 0
    var volumeSlider = UISlider()
    let volumeTypes = ["masterVol", "guitarVol", "clickVol"]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let styler = ViewStyler(ivc: self)
        styler.displayTitle(self,navigationController!,titleTextDict[settingsType!]!)
        if settingsType! == "volumeControl" {
            let width = UIScreen.main.bounds.size.width*0.8
            volumeSlider = UISlider(frame:CGRect(x: 0, y: 0, width: width, height: 20))
            volumeSlider.center = self.view.center
            volumeSlider.addTarget(self, action: #selector(onSliderChange(_:)), for: .valueChanged)
//            volumeSlider.tintColor = UIColor.green
            //main color
            volumeSlider.thumbTintColor = defaultColor.ProgressTrackColor
            volumeSlider.minimumTrackTintColor = defaultColor.ProgressTrackColor
            //other color
            volumeSlider.maximumTrackTintColor = defaultColor.ProgressBarColor
            //Inverted::
            //main color
//            volumeSlider.thumbTintColor = defaultColor.ProgressBarColor
//            volumeSlider.minimumTrackTintColor = defaultColor.ProgressBarColor
            //other color
//            volumeSlider.maximumTrackTintColor = defaultColor.ProgressTrackColor
            for volStr in volume.volumeTypes.keys {
                if UserDefaults.standard.object(forKey: volStr) != nil {
                    volume.volumeTypes[volStr] = (UserDefaults.standard.object(forKey: volStr) as! Float)
                }
            }
            volumeSlider.setValue(volume.volumeTypes[volumeTypes[initialCheckmarkIdx]]!, animated: true)
            view.addSubview(volumeSlider)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        self.tableView.backgroundColor = UIColor.clear

        if let defaultKey = UserDefaults.standard.object(forKey: settingsType!) {
            initialCheckmarkIdx = settingStrings.firstIndex(of: defaultKey as! String)!
            if settingsType! == "volumeControl" {
                volumeSlider.setValue(volume.volumeTypes[volumeTypes[initialCheckmarkIdx]]!, animated: true)
            }
        }
        if settingsType == "backgroundPick" {
            setupBackgroundPickButton()
            initialCheckmarkIdx = 0
            selectedCell = 0
        }
        
        var styler: ViewStyler?
        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "SettingsImage\(backgroundImageID).jpg")
    }
    
    @objc func onSliderChange(_ sender:UISlider!) {
        volume.volumeTypes[volumeTypes[selectedCell]] = sender.value
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if navigationController?.viewControllers.index(of: self) == nil && settingsType! == "volumeControl" {
            for volStr in volumeTypes {
                UserDefaults.standard.set(volume.volumeTypes[volStr], forKey: volStr)
            }
        }
        super.viewWillDisappear(animated)
    }

    func setupBackgroundPickButton() {
        changeButton = UIButton()
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        let width: CGFloat = screenWidth * 0.72
        let height: CGFloat = 70
        let yBuffer: CGFloat = 100
        changeButton.frame = CGRect(x: screenWidth * 0.5 - width / 2, y: screenHeight - height - yBuffer, width: width, height: height)
        changeButton.backgroundColor = defaultColor.MenuButtonColor
        changeButton.layer.cornerRadius = 10
        changeButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        changeButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        changeButton.layer.shadowOpacity = 1.0
        changeButton.layer.shadowRadius = 0.0
        changeButton.layer.masksToBounds = false
        changeButton.setTitle("CHANGE", for: .normal)
        changeButton.tintColor = defaultColor.MenuButtonTextColor
        changeButton.titleLabel?.font = .systemFont(ofSize: 18)
        changeButton.addTarget(self, action: #selector(onChangeButtonDown), for: .touchDown)
        view.addSubview(changeButton)
    }

    @objc func onChangeButtonDown() {
        performSegue(withIdentifier: "ImageChooserViewController", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        let vc = segue.destination as! ImageChooserViewController
        vc.selectedBackground = settingStrings[selectedCell].lowercased()
    }

    func setupSettingsCellData(isettingsType: String, isettingStrings: [String]) {
        settingsType = isettingsType
        settingStrings = isettingStrings
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return settingStrings.count
    }

    func playSound(isoundName: String) {
        sc.playSound(isoundName: isoundName, ivolume: volume.volumeTypes["masterVol"]!)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! SettingViewCell
        let labelStr = settingStrings[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = labelStr
        tableView.tableFooterView = UIView(frame: .zero)
        
        cell.tintColor = UIColor.black
        
        if indexPath.row == initialCheckmarkIdx {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    func tableView(_ cell: UITableView, willDisplay _: UITableViewCell, forRowAt _: IndexPath) {
//        cell.backgroundColor = UIColor.blue
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(settingStrings[indexPath.row], forKey: settingsType!)
        // https://www.youtube.com/watch?time_continue=397&v=5MZ-WJuSdpg&feature=emb_logo
        for row in 0 ..< tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark

        if soundStringDict[settingsType! + "_" + settingStrings[indexPath.row]] != nil {
            playSound(isoundName: soundStringDict[settingsType! + "_" + settingStrings[indexPath.row]]!)
        }
        
        if settingsType! == "volumeControl" {
            UIView.animate(withDuration: 0.8) {
                self.volumeSlider.setValue(volume.volumeTypes[self.volumeTypes[indexPath.row]]!, animated: true)
            }
        }
        selectedCell = indexPath.row
    }
}
