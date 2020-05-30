import Foundation
import UIKit

class SettingsViewController: UIViewController {
    var vc: MainViewController?

    convenience init() {
        self.init(ivc: nil)
    }

    init(ivc: MainViewController?) {
        vc = ivc
        super.init(nibName: nil, bundle: nil) // https://stackoverflow.com/questions/26923003/how-do-i-make-a-custom-initializer-for-a-uiviewcontroller-subclass-in-swift
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//    @IBOutlet var Stack: UIStackView!
    @IBOutlet var Button0: UIButton!
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    @IBOutlet var Button4: UIButton!

    var styler: ViewStyler?
    var buttonId = 0

    var buttonArr: [UIButton] = []
    
    var backgroundImageID = 0
    
    struct buttonText {
        var header: String
        var subtext: String
        var id: String
        var availableSettings: [String]
        var settingsType: String

        init(iheader: String, isubtext: String, iid: String, iavailableSettings: [String], isettingsType: String) {
            header = iheader
            subtext = isubtext
            id = iid
            availableSettings = iavailableSettings
            settingsType = isettingsType
        }
    }

    var buttonInfo: [buttonText] = [
        buttonText(
            iheader: "Guitar Sound".uppercased(),
            isubtext: "Explore Sonic Options",
            iid: "guitarTone",
            iavailableSettings: ["Acoustic", "Jazz", "Rock"],
            isettingsType: "guitarTone"
        ),
        buttonText(
            iheader: "Fretboard Dot".uppercased(),
            isubtext: "Manage Your Dot Display",
            iid: "fretDot",
            iavailableSettings: ["Scale Degree", "Note Name", "None"],
            isettingsType: "dotValue"
        ),
        buttonText(
            iheader: "Click Sound".uppercased(),
            isubtext: "Pick Your Click Sound",
            iid: "clickTone",
            iavailableSettings: ["Digital", "Woodblock1", "Woodblock2"],
            isettingsType: "clickTone"
        ),
//        buttonText(
//            iheader: "Background Picture".uppercased(),
//            isubtext: "Manage Your Backgrounds",
//            iid: "backgroundPick",
//            iavailableSettings: ["Menu", "Scales", "Arpeggios"],
//            isettingsType: "backgroundPicker"
//        ),
        buttonText(
            iheader: "Volume".uppercased(),
            isubtext: "Change Volume",
            iid: "volume",
            iavailableSettings: [],
            isettingsType: ""
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        
        styler = ViewStyler(ivc: self)
        backgroundImageID = Int.random(in: 0 ..< 3)
        styler!.setupBackgroundImage(ibackgroundPic: "SettingsImage\(backgroundImageID).jpg")
        
//        buttonArr = [Button0, Button1, Button2, Button3, Button4]
        buttonArr = [Button0, Button1, Button2, Button4]
        styler!.spaceButtons(buttonArr,navigationController!)
        for (i, button) in buttonArr.enumerated() {
            let subText = UILabel()
            styler!.setupMenuButton(
                ibutton: button,
                isubText: subText
            )
            styler!.setupMenuButtonAttributes(
                ibutton: button,
                isubText: subText,
                iprogressBar: nil,
                ibuttonActive: true,
                ibuttonStr: buttonInfo[i].header,
                isubTextStr: buttonInfo[i].subtext,
                iprogressAmount: -1.0
            )
        }
        
        Button3.isHidden = true
    }

    @IBAction func settingsCategoryButtonDown(_ sender: UIButton) {
        buttonId = sender.tag
        UIView.setAnimationsEnabled(false)
        let view = buttonId < 4 ? "SettingsItem" : "VolumeSettingsViewController"
        performSegue(withIdentifier: view, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if buttonId < 4 {
            let sItem = segue.destination as! SettingsItemViewController
            sItem.setupSettingsCellData(isettingsType: buttonInfo[buttonId].id, isettingStrings: buttonInfo[buttonId].availableSettings)
            sItem.backgroundImageID = backgroundImageID
        } else {
            let sItem = segue.destination as! VolumeSettingsViewController
            sItem.backgroundImageID = backgroundImageID
        }
    }
}
