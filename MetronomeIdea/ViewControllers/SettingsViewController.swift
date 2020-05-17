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

    @IBOutlet var Stack: UIStackView!
    @IBOutlet var Button0: UIButton!
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    @IBOutlet var Button4: UIButton!

    var styler: ViewStyler?
    var buttonId = 0

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
        buttonText(
            iheader: "Background Picture".uppercased(),
            isubtext: "Manage Your Backgrounds",
            iid: "backgroundPick",
            iavailableSettings: ["Menu", "Scales", "Arpeggios"],
            isettingsType: "backgroundPicker"
        ),
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

        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "RecordingBoard.jpg")
        let buttonArr = [Button0, Button1, Button2, Button3, Button4]
        for (i, button) in buttonArr.enumerated() {
            let subText = UILabel()
            styler!.setupMenuButton(
                ibutton: button!,
                isubText: subText
            )
            styler!.setupMenuButtonAttributes(
                ibutton: button!,
                isubText: subText,
                iprogressBar: nil,
                ibuttonActive: true,
                ibuttonStr: buttonInfo[i].header,
                isubTextStr: buttonInfo[i].subtext,
                iprogressAmount: -1.0
            )
        }
        
        let button4frame = view.convert(Button4.frame, from: Stack)
        // look to see if menu buttons are off the screen
        if button4frame.maxY + button4frame.height > view.frame.height {
            Stack.frame = CGRect(x: Stack.frame.minX, y: Stack.frame.minY + 50, width: Stack.frame.width, height: Stack.frame.height)
            let bottomBuffer: CGFloat = -50.0
            let numbButtons: CGFloat = 5.0
            let button0frame = view.convert(Button0.frame, from: Stack)
            let sP = (view.frame.height - (bottomBuffer + button0frame.height) - button0frame.minY - (numbButtons - 1) * button0frame.height) / numbButtons
            print("adapting stack to fit all buttons with new spacing of \(sP)")
            Stack.spacing = CGFloat(sP)
        }
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
        }
    }
}
