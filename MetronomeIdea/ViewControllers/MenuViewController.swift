import CoreData
import UIKit

extension UIButton {
    open override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = false
        }
    }
}

// global vars/constants
var userLevelData = UserLevelData(scaleLevel: "0.0", arpeggioLevel: "0.0", intervalLevel: "0.0", et_scales: "0.0", et_chords: "0.0", tutorialComplete: "0.0")
let defaultColor = DefaultColor()
let backgroundImage = BackgroundImage()
var globalDataController = DataController(modelName: "ImageModel")
var volume = Volume()
var audioKitStarted = false

//var currentRecordingId = ""

class MenuViewController: UIViewController {
    @IBOutlet var Button0: UIButton!
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    @IBOutlet var Button4: UIButton!
    var buttonArr: [UIButton] = []

    var menuButtonSubtext: [UILabel] = []
    var menuButtonProgress: [UIProgressView] = []

    var developmentMode = 1

    var tutorialCompleteStatus = true
    var levelArr: [Int] = []
    var buttonId = 0

    var devToggleButton = UIButton()
    var resetDataButton = UIButton()

    var bgImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        
        for (volumeType, _) in volume.volumeTypes {
            let vol = UserDefaults.standard.object(forKey: volumeType)
            if vol != nil {
                volume.volumeTypes[volumeType] = vol as? Float
            }
        }
        
        globalDataController.load()
        
        setupHiddenButtons()
//        resetData()

        let styler = ViewStyler(ivc: self)
        buttonArr = [Button0, Button1, Button2, Button3, Button4]
        for (i, Button) in buttonArr.enumerated() {
            menuButtonSubtext.append(UILabel())
            menuButtonProgress.append(UIProgressView())
            styler.setupMenuButton(ibutton: Button, isubText: menuButtonSubtext[i], iprogressBar: menuButtonProgress[i])
        }
        
        styler.setupBackgroundImage(ibackgroundPic: "MenuImage\(Int.random(in: 0 ..< 7)).jpg")

        let textAttributes = [NSAttributedString.Key.foregroundColor: defaultColor.NavBarTitleColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .white
        
        styler.spaceButtons(buttonArr,navigationController!)
    }
    

    override func viewDidAppear(_: Bool) {
        navigationController?.navigationBar.barTintColor = defaultColor.MenuButtonColor
        navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
        navigationController?.navigationBar.isTranslucent = false
        
        //        bgImage.image = backgroundImage.returnImage("menu")

        let scaleLevel = UserDefaults.standard.object(forKey: "scaleLevel")
        if scaleLevel != nil {
            print("restoring data")
            let scaleLevel = UserDefaults.standard.object(forKey: "scaleLevel")
            if let scaleLevel = scaleLevel {
                let arpeggioLevel = UserDefaults.standard.object(forKey: "arpeggioLevel")
                let intervalLevel = UserDefaults.standard.object(forKey: "intervalLevel")
                let et_scales = UserDefaults.standard.object(forKey: "et_scales")
                let et_chords = UserDefaults.standard.object(forKey: "et_chords")
                let tutorialComplete = UserDefaults.standard.object(forKey: "tutorialComplete")
                
                userLevelData.scaleLevel = scaleLevel as! String
                userLevelData.arpeggioLevel = arpeggioLevel as! String
                userLevelData.intervalLevel = intervalLevel as! String
                userLevelData.et_scales = et_scales as! String
                userLevelData.et_chords = et_chords as! String

                if tutorialComplete != nil {
                    userLevelData.tutorialComplete = tutorialComplete as! String
                } else {
                    print("bad data, ressetting")
                    resetData()
                }
            }
        } else {
            print("brand new data")
            userLevelData.setDefaultValues()
            for (_, str) in userLevelData.stringEquivs.enumerated() {
                UserDefaults.standard.removeObject(forKey: str)
                UserDefaults.standard.set("0.0", forKey: str)
            }
        }

        // update button info
        let lc = LevelConstruct()
        let styler = ViewStyler(ivc: self)

        struct buttonText {
            var header: String
            var subtext: String
            var progress: Float
            var active: Bool
            init(iheader: String, isubtext: String, iprogress: Float, iactive: Bool) {
                header = iheader
                subtext = isubtext
                progress = iprogress
                active = iactive
            }
        }

        tutorialCompleteStatus = userLevelData.tutorialComplete == "1.0" || developmentMode > 0

        var buttonTextInfo: [buttonText] = []

        var level = lc.returnConvertedLevel(iinput: userLevelData.scaleLevel)
        var subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.scaleLevel)
        var progress = lc.returnTotalProgress(
            ilevel: lc.returnConvertedLevel(iinput: userLevelData.scaleLevel),
            isubLevel: lc.returnConvertedSubLevel(iinput: userLevelData.scaleLevel),
            ilevelConstruct: lc.scale
        )
        var key = "scales"
        buttonTextInfo.append(buttonText(iheader: key.uppercased(), isubtext: returnLevelStr(ilc: lc, ikey: key, ilevel: level), iprogress: progress, iactive: true))

        key = "arpeggios"
        level = lc.returnConvertedLevel(iinput: userLevelData.arpeggioLevel)
        subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.arpeggioLevel)
        progress = lc.returnTotalProgress(ilevel: level, isubLevel: subLevel, ilevelConstruct: lc.arpeggio)
        buttonTextInfo.append(buttonText(iheader: key.uppercased(), isubtext: returnLevelStr(ilc: lc, ikey: key, ilevel: level), iprogress: progress, iactive: tutorialCompleteStatus))

        key = "intervals"
        level = lc.returnConvertedLevel(iinput: userLevelData.intervalLevel)
        subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.intervalLevel)
        progress = lc.returnTotalProgress(ilevel: level, isubLevel: subLevel, ilevelConstruct: lc.interval)
        
        buttonTextInfo.append(buttonText(iheader: "EAR TRAINING: INTERVALS", isubtext:returnLevelStr(ilc: lc, ikey: key, ilevel: level), iprogress: progress, iactive: tutorialCompleteStatus))

        level = lc.returnConvertedLevel(iinput: userLevelData.et_scales)
        subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.et_scales)
        buttonTextInfo.append(buttonText(iheader: "EAR TRAINING: SCALES", isubtext: "Coming Soon", iprogress: 0.0, iactive: false))

        level = lc.returnConvertedLevel(iinput: userLevelData.et_chords)
        subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.et_chords)
        buttonTextInfo.append(buttonText(iheader: "EAR TRAINING: CHORDS", isubtext: "Coming Soon", iprogress: 0.0, iactive: false))

        for (i, textAtt) in buttonTextInfo.enumerated() {
            styler.setupMenuButtonAttributes(
                ibutton: buttonArr[i],
                isubText: menuButtonSubtext[i],
                iprogressBar: menuButtonProgress[i],
                ibuttonActive: textAtt.active,
                ibuttonStr: textAtt.header,
                isubTextStr: textAtt.subtext,
                iprogressAmount: textAtt.progress
            )
        }
    }
    @IBAction func PlaygroundButton(_ sender: Any) {
        print("got playground")
        if !tutorialCompleteStatus {
            //maybe add popup
            return
        }
        buttonId = -1
        UIView.setAnimationsEnabled(false)
        performSegue(withIdentifier: "FretPlayground", sender: nil)
    }
    
    @IBAction func HandleSettingsButtonDwon(_ sender: Any) {
        buttonId = 10
        performSegue(withIdentifier: "SettingsViewFromMenu", sender: nil)
    }
    
    @IBAction func MainMenuButton(_ sender: UIButton) {
        if !tutorialCompleteStatus && sender.tag > 0 || sender.tag > 2 {
            return
        }
        buttonId = sender.tag
        performSegue(withIdentifier: "FretPlayground", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        UIView.setAnimationsEnabled(false)
        
        if buttonId == 10 {return}
        
        let vc = segue.destination as! MainViewController
        let lc = LevelConstruct()

        vc.developmentMode = developmentMode
        
        // Free Play
        if buttonId == -1 {
            vc.setStateProperties(icurrentLevel: "0.0", ilevelConstruct: lc.scale, ilevelKey: "freePlay", itutorialComplete: userLevelData.tutorialComplete)
        }

        // Scales
        if buttonId == 0 {
            vc.setStateProperties(icurrentLevel: userLevelData.scaleLevel, ilevelConstruct: lc.scale, ilevelKey: "scaleLevel", itutorialComplete: userLevelData.tutorialComplete)
        }

        // Arpeggios
        if buttonId == 1 {
            vc.setStateProperties(icurrentLevel: userLevelData.arpeggioLevel, ilevelConstruct: lc.arpeggio, ilevelKey: "arpeggioLevel")
        }
        
        // Intervals
        if buttonId == 2 {
            vc.setStateProperties(icurrentLevel: userLevelData.intervalLevel, ilevelConstruct: lc.interval, ilevelKey: "intervalLevel")
        }
    }

    func returnLevelStr(ilc: LevelConstruct, ikey: String, ilevel: Int) -> String {
        return "L\(ilevel + 1) - \(ilc.currentLevelName[ikey]![ilevel].uppercased())"
    }

    func setupHiddenButtons() {
        setupDevButton()
        setupResetButton()
    }

    @objc func toggleDevMode() {
        developmentMode = (developmentMode + 1) % 3
        let devStr = "Dev Mode: \(developmentMode)"
        setHiddenButtonText(itext: devStr, ibutton: devToggleButton)
    }

    @objc func resetData() {
        setHiddenButtonText(itext: "Resetting Data", ibutton: resetDataButton)
        for (_, str) in userLevelData.stringEquivs.enumerated() {
            UserDefaults.standard.removeObject(forKey: str)
        }
    }

    func setHiddenButtonText(itext: String, ibutton: UIButton) {
        ibutton.setTitle(itext, for: .normal)
        print(itext)
        UIView.setAnimationsEnabled(true)
        ibutton.titleLabel?.alpha = 1.0
        UIView.animate(withDuration: 3.5, animations: {
            ibutton.titleLabel?.alpha = 0.0
        })
    }

    func setupDevButton() {
        devToggleButton = UIButton()
        devToggleButton.frame = returnDevButtonFrame("Dev")
//        devToggleButton.backgroundColor = UIColor.red
        devToggleButton.addTarget(self, action: #selector(toggleDevMode), for: .touchDown)
        view.addSubview(devToggleButton)
    }

    func setupResetButton() {
        resetDataButton = UIButton()
        resetDataButton.frame = returnDevButtonFrame()
        resetDataButton.addTarget(self, action: #selector(resetData), for: .touchDown)
        view.addSubview(resetDataButton)
    }

    func returnDevButtonFrame(_ itype: String = "ResetData") -> CGRect {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        let height: CGFloat = screenHeight * 0.1
        if itype == "ResetData" {
            return CGRect(x: screenWidth * 0.5, y: screenHeight - height, width: screenWidth * 0.5, height: height)
        } else {
            return CGRect(x: 0, y: screenHeight - height, width: screenWidth * 0.5, height: height)
        }
    }
}
