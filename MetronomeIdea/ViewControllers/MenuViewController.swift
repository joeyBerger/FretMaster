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

        globalDataController.load()

        let fetchRequest: NSFetchRequest<ImageData> = ImageData.fetchRequest()
        if let results = try? globalDataController.viewContext.fetch(fetchRequest) {
            for image in results {
                backgroundImage.images[image.id!] = UIImage(data: image.backgroundImage!)
            }
        }

        for (volumeType, _) in volume.volumeTypes {
            let vol = UserDefaults.standard.object(forKey: volumeType)
            if vol != nil {
                volume.volumeTypes[volumeType] = vol as? Float
            }
        }

        buttonArr = [Button0, Button1, Button2, Button3, Button4]
        setupHiddenButtons()

        bgImage.image = backgroundImage.returnImage("menu")
        bgImage.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        bgImage.contentMode = UIView.ContentMode.scaleAspectFill
        view.insertSubview(bgImage, at: 0)

        let styler = ViewStyler(ivc: self)
        for (i, Button) in buttonArr.enumerated() {
            menuButtonSubtext.append(UILabel())
            menuButtonProgress.append(UIProgressView())
            styler.setupMenuButton(ibutton: Button, isubText: menuButtonSubtext[i], iprogressBar: menuButtonProgress[i])
        }

        let textAttributes = [NSAttributedString.Key.foregroundColor: defaultColor.NavBarTitleColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .white

//        let button4frame = view.convert(Button4.frame, from: Stack)
//        // look to see if menu buttons are off the screen
//        if button4frame.maxY + button4frame.height > view.frame.height {
//            Stack.frame = CGRect(x: Stack.frame.minX, y: Stack.frame.minY + 50, width: Stack.frame.width, height: Stack.frame.height)
//            let bottomBuffer: CGFloat = -50.0
//            let numbButtons: CGFloat = 5.0
//            let button0frame = view.convert(Button0.frame, from: Stack)
//            let sP = (view.frame.height - (bottomBuffer + button0frame.height) - button0frame.minY - (numbButtons - 1) * button0frame.height) / numbButtons
//            print("adapting stack to fit all buttons with new spacing of \(sP)")
//            Stack.spacing = CGFloat(sP)
//        }
        
//        let screenRect = UIScreen.main.bounds
//        let screenWidth = screenRect.size.width
//        let screenHeight = screenRect.size.height
//
//        let buffer:CGFloat = returnButtonBuffer(screenHeight - (navigationController?.navigationBar.frame.maxY)!)
//        let availableScreenHeight = screenHeight - (navigationController?.navigationBar.frame.maxY)! - (buffer*2)
//
//        let spacing:CGFloat = availableScreenHeight/5
//
//        for (i,button) in buttonArr.enumerated() {
//            let y = ((navigationController?.navigationBar.frame.maxY)! + buffer + button.frame.height/2 - 12) + (spacing) * CGFloat(i)
//            button.frame = CGRect(x: screenWidth/2-button.frame.width/2, y: y, width: button.frame.width, height: button.frame.height)
//        }
//
//        print(Button0.frame)
        
        styler.spaceButtons(buttonArr,navigationController!)
    }

    override func viewDidAppear(_: Bool) {
        navigationController?.navigationBar.barTintColor = defaultColor.MenuButtonColor
        bgImage.image = backgroundImage.returnImage("menu")

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

    @IBAction func MainMenuButton(_ sender: UIButton) {
        if !tutorialCompleteStatus && sender.tag > 0 || sender.tag > 2 {
            return
        }
        buttonId = sender.tag
        UIView.setAnimationsEnabled(false)
        performSegue(withIdentifier: "FretPlayground", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        let vc = segue.destination as! MainViewController
        let lc = LevelConstruct()

        vc.developmentMode = developmentMode

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
    
//    func returnButtonBuffer(_ iscreenSpace: CGFloat) -> CGFloat {
//        print("iscreenSpace",iscreenSpace)
//        if iscreenSpace > 650 {
//            return 110.0
//        } else if iscreenSpace > 600 {
//            return 60.0
//        }
//        return 15.0
//    }

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
