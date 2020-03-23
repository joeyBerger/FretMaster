
import AMPopTip
import Foundation
import AVFoundation
import UIKit

//for design purposes
@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

public extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
                switch identifier {
                case "iPod5,1": return "iPod touch (5th generation)"
                case "iPod7,1": return "iPod touch (6th generation)"
                case "iPod9,1": return "iPod touch (7th generation)"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
                case "iPhone4,1": return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2": return "iPhone 5"
                case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
                case "iPhone7,2": return "iPhone 6"
                case "iPhone7,1": return "iPhone 6 Plus"
                case "iPhone8,1": return "iPhone 6s"
                case "iPhone8,2": return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3": return "iPhone 7"
                case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
                case "iPhone8,4": return "iPhone SE"
                case "iPhone10,1", "iPhone10,4": return "iPhone 8"
                case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6": return "iPhone X"
                case "iPhone11,2": return "iPhone XS"
                case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
                case "iPhone11,8": return "iPhone XR"
                case "iPhone12,1": return "iPhone 11"
                case "iPhone12,3": return "iPhone 11 Pro"
                case "iPhone12,5": return "iPhone 11 Pro Max"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad (3rd generation)"
                case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad (4th generation)"
                case "iPad6,11", "iPad6,12": return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6": return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12": return "iPad (7th generation)"
                case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
                case "iPad5,3", "iPad5,4": return "iPad Air 2"
                case "iPad11,4", "iPad11,5": return "iPad Air (3rd generation)"
                case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad mini"
                case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad mini 3"
                case "iPad5,1", "iPad5,2": return "iPad mini 4"
                case "iPad11,1", "iPad11,2": return "iPad mini (5th generation)"
                case "iPad6,3", "iPad6,4": return "iPad Pro (9.7-inch)"
                case "iPad6,7", "iPad6,8": return "iPad Pro (12.9-inch)"
                case "iPad7,1", "iPad7,2": return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad7,3", "iPad7,4": return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro (11-inch)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro (12.9-inch) (3rd generation)"
                case "AppleTV5,3": return "Apple TV"
                case "AppleTV6,2": return "Apple TV 4K"
                case "AudioAccessory1,1": return "HomePod"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default: return identifier
                }
            #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
                }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()
}

extension UIButton {
    open override func hitTest(_ point: CGPoint, with _: UIEvent?) -> UIView? {
        return bounds.contains(point) ? self : nil
    }

    func blink(enabled: Bool = true, duration: CFTimeInterval = 1.0, stopAfter: CFTimeInterval = 0.0) {
        enabled ? UIView.animate(withDuration: duration, // Time duration you want,
                                 delay: 0.0,
                                 options: [.curveEaseInOut, .autoreverse, .repeat],
                                 animations: { [weak self] in self?.alpha = 0.0 },
                                 completion: { [weak self] _ in self?.alpha = 1.0 }) : layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }

    func pulsate(ilayer: Int) -> Int {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 0.95
        pulse.toValue = 1.3
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 10.5
        pulse.damping = 1.0

        layer.add(pulse, forKey: nil)

        self.layer.zPosition += 1.0
        return (ilayer + 1)
    }
}

class MainViewController: UIViewController {
    
    enum Vibration {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        case selection
        case oldSchool

        func vibrate() {

          switch self {
          case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)

          case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

          case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)

          case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

          case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

          case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()

          case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()

          case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
          }
        }
    }
   
    //Outlets
    @IBOutlet var BlankImageView: UIImageView!
    @IBOutlet var ResultsLabel: UILabel!
    @IBOutlet var ResultButton: UIButton!
    @IBOutlet var PeriphButton0: UIButton!
    @IBOutlet var PeriphButton1: UIButton!
    @IBOutlet var PeriphButton2: UIButton!
    @IBOutlet var PeriphButton3: UIButton!
    @IBOutlet var PeriphButton4: UIButton!
    @IBOutlet var NavBar: UINavigationBar!
    var NavBarFiller: UIImageView!
    @IBOutlet var NavBackButton: UIBarButtonItem!
    @IBOutlet var NavSettingsButton: UIBarButtonItem!
    @IBOutlet var NavBarTitle: UINavigationItem!
    @IBOutlet var TempoButton: UIButton!
    @IBOutlet var TempoDownButton: UIButton!
    @IBOutlet var TempoUpButton: UIButton!
    
    @IBOutlet var mainPopover: UIView!
    @IBOutlet var mainPopoverCloseButton: UIButton!
    @IBOutlet var mainPopoverBodyText: UILabel!
    @IBOutlet var mainPopoverTitle: UILabel!
    @IBOutlet var mainPopoverButton: UIButton!

    @IBOutlet weak var FretboardDummy: UIImageView!
    

    @IBOutlet var PeripheralStackView: UIStackView!
    @IBOutlet var Fret: UIImageView!
    
    
    var FretboardImage: UIImageView!
    var DimOverlay: UIImageView!
    var ActionOverlay: UIImageView!
    var dotDict: [String: UIImageView] = [:]
    var fretButtonDict: [String: UIButton] = [:]
    var fretButtonFrame: [String: CGRect] = [:]
    var dotText: [UILabel] = []
    var periphButtonArr: [UIButton] = []

    //Timers
    var dotFadeTime: Timer?
    var userInputTime = CFAbsoluteTimeGetCurrent()
    var recordStartTime: CFAbsoluteTime = 0
    var recordStopTime: CFAbsoluteTime = 0
    var previousNote: String?

    //Runtime Variables
    
    //Objects
    let sc = SoundController(isubInstances: 10)
    let click = SoundController(isubInstances: 10)
    var met: Metronome?
    var sCollection: ScaleCollection?
    var et: EarTraining?
    var pc: PopupController?
    var wt = waitThen()
    
    class InputData {
        var time: CFAbsoluteTime = 0
        var note = ""
        var timeDelta = 0.0
    }
    
    let timeThreshold: [String: Double] = [
        "Easy": 0.1,
        "Medium": 0.075,
        "Hard": 0.05,
    ]
    
    var recordData: [InputData] = []
    var noteCollectionTestData: [InputData] = []
    var earTrainCallArr: [String] = []
    var earTrainResponseArr: [String] = []
    var defaultPeripheralIcon: [String] = []
    var activePeripheralIcon: [String] = []
    var tutorialPopupText: [String] = []
    var currentTutorialPopup = 0
    var developmentMode = false

    var specifiedNoteCollection: [String] = []
    let tempScale: [String] = ["A1", "C2", "D2", "E2", "G2"]

    var defaultSoundFadeTime = 0.3
    
    var tutorialActive = false
    var mainPopoverVisible = false
    var mainPopoverState = ""
    
    var tempoButtonsActive = false
    var tempoActive = false
    var tempoUpdaterCycle = 0.0
    var tempoButtonArr: [UIButton]? = []
    
    var resultButtonText = ""
    var resultsLabelDefaultText = ""

    var buttonDict: [Int: String] = [ // this could probably be an array
        0: "G#1",
        1: "A1",
        2: "A#1",
        3: "B1",
        4: "C2",
        5: "C#2",
        6: "D2",
        7: "D#2",
        8: "E2",
        9: "F2",
        10: "F#2",
        11: "G2",
        12: "G#2",
        13: "A2",
        14: "A#2",
        15: "B2",
        16: "C3",
        17: "C#3",
        18: "D3",
        19: "D#3_0",
        20: "D#3_1",
        21: "E3",
        22: "F3",
        23: "F#3",
        24: "G3",
        25: "G#3",
        26: "A3",
        27: "A#3",
        28: "B3",
        29: "C4",
    ]

    var currentBackgroundPic = ""
    var backgroundPicDict: [String: String] = [  //TODO: need to add states and unify image types
        "scaleLevel": "RockCrowd.png",
        "arpeggioLevel": "RockCrowd2.jpg",
        "earTrainingNotes": "RockCrowd.png",
        "earTrainingScales": "RockCrowd.png",
        "FreePlay": "RockCrowd.png",
    ]
    
    var buttonNote: [String: UILabel] = [:]

    let layerArr = [
        "Default",
        "DimOverlay",
        "TutorialFrontLayer0",
        "TutorialFrontLayer1",
        "PopOverLayer",
        "FretButton",
        "ActionOverlay",
    ]

    enum State : String {
        case Idle
        case RecordingIdle
        case Recording
        case Playback

        case EarTrainCall
        case EarTrainResponse

        case PlayingNotesCollection
        case NotesTestIdle_NoTempo
        case NotesTestActive_NoTempo
        case NotesTestCountIn_Tempo
        case NotesTestActive_Tempo
        case NotesTestIdle_Tempo
        case NotesTestShowNotes
    }

    var currentState = State.Idle
    var allMarkersDisplayed = false
    var defaultState: State?
    var currentLevel: String?
    var currentLevelConstruct: [[String]] = [[]]
    var currentLevelKey: String?
    var tutorialComplete: Bool?
    var currentButtonLayer = 0
    let digitInput = DigitsInput()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Add overlays
        DimOverlay = setupScreenOverlay()
        DimOverlay.backgroundColor = UIColor.black
        view.addSubview(DimOverlay)
        setLayer(iobject: DimOverlay, ilayer: "DimOverlay")
        
        ActionOverlay = setupScreenOverlay()
        ActionOverlay.backgroundColor = UIColor.white
        view.addSubview(ActionOverlay)
        setLayer(iobject: ActionOverlay, ilayer: "ActionOverlay")
        
        setupFretBoardImage()
        setupFretMarkerText(ishowAlphabeticalNote: false, ishowNumericDegree: true)
        setupToSpecificState()
        currentState = State.NotesTestShowNotes
        setButtonImage(ibutton: periphButtonArr[2], iimageStr: activePeripheralIcon[2])
        
        let navBarButtonAnnotation0 = UIButton()
        navBarButtonAnnotation0.frame = CGRect(x: 0, y: NavBar.frame.minY, width: 100, height: NavBar.frame.height)
        navBarButtonAnnotation0.addTarget(self, action: #selector(onBackButtonDown), for: .touchUpInside)
        view.addSubview(navBarButtonAnnotation0)
        
        let navBarButtonAnnotation1 = UIButton()
        navBarButtonAnnotation1.frame = CGRect(x: NavBar.frame.width-100, y: NavBar.frame.minY, width: 100, height: NavBar.frame.height)
        navBarButtonAnnotation1.addTarget(self, action: #selector(onSettingsButtonDown), for: .touchUpInside)
        view.addSubview(navBarButtonAnnotation1)
        
        if !tutorialComplete! {
            hideAllFretMarkers()
            wt.waitThen(itime: 0.2, itarget: self, imethod: #selector(presentMainPopover) as Selector, irepeats: false, idict: ["arg1": "Tutorial" as AnyObject, "arg2": 0 as AnyObject])
            setupPopupTutorialText()
            
        }
    }
    
    @objc func willEnterForeground() {
        let n: Any = 0
        onBackButtonDown(n)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        setupBackgroundImage(ibackgroundPic: currentBackgroundPic)
        
        NavBarFiller = UIImageView()
        let newFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: NavBar.frame.minY)
        NavBarFiller.frame = newFrame
        NavBarFiller.backgroundColor = defaultColor.MenuButtonColor
        self.view.insertSubview(NavBarFiller, at: 1)

        //initialize objects
        met = Metronome(ivc: self)
        sCollection = ScaleCollection(ivc: self)
        et = EarTraining(ivc: self)
        pc = PopupController(ivc: self)

        if developmentMode {
            met?.bpm = 350.0
        }


        ResultsLabel.text = ""
        ResultsLabel.font = UIFont(name: "Helvetica", size: 35)
        ResultsLabel.textAlignment = NSTextAlignment.center
        ResultsLabel?.adjustsFontSizeToFitWidth = true
//           ResultsLabel1?.adjustsFontSizeToFitWidth = true
        ResultsLabel?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        ResultsLabel?.textColor = defaultColor.MenuButtonTextColor

        NavBar.barTintColor = defaultColor.MenuButtonColor
        NavBar.isTranslucent = false
        NavBackButton.tintColor = defaultColor.MenuButtonTextColor
        NavBackButton.target = self;
        NavBackButton.action = #selector(onBackButtonDown)
        NavSettingsButton.tintColor = defaultColor.MenuButtonTextColor
        NavBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: defaultColor.NavBarTitleColor]

        ResultButton.titleLabel?.adjustsFontSizeToFitWidth = true
        ResultButton.setTitleColor(.black, for: .normal)
//        ResultButton.setTitle("", for: .normal)
        setResultButton()
        ResultButton.titleLabel?.adjustsFontSizeToFitWidth = true
        ResultButton.titleLabel?.minimumScaleFactor = 0.5
        ResultButton.backgroundColor = defaultColor.ResultsButtonColor
        ResultButton.setTitleColor(.white, for: .normal)
        ResultButton.titleLabel?.font = UIFont(name: ResultsLabel.font.fontName, size: 20)
        ResultButton.layer.cornerRadius = 20
        giveButtonBackgroundShadow(ibutton: ResultButton)

        mainPopover.backgroundColor = defaultColor.MenuButtonColor
        mainPopover.layer.cornerRadius = 10
        mainPopoverCloseButton.tintColor = defaultColor.MenuButtonTextColor
        mainPopoverBodyText.textColor = defaultColor.MenuButtonTextColor
        mainPopoverBodyText.contentMode = .scaleToFill
        mainPopoverBodyText.numberOfLines = 0
        setLayer(iobject: mainPopover, ilayer: "PopOverLayer")
        mainPopoverTitle.textColor = defaultColor.MenuButtonTextColor
        mainPopoverButton.setTitleColor(.white, for: .normal)
        mainPopoverButton.backgroundColor = UIColor.red

        periphButtonArr.append(PeriphButton0)
        periphButtonArr.append(PeriphButton1)
        periphButtonArr.append(PeriphButton2)
        periphButtonArr.append(PeriphButton3)
        periphButtonArr.append(PeriphButton4)

        // setup long pressed recognizers
        let recognizer0 = UILongPressGestureRecognizer(target: self, action: #selector(tempoButtonLongPressed))
        TempoUpButton.addGestureRecognizer(recognizer0)
        recognizer0.view?.tag = 0
        let recognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(tempoButtonLongPressed))
        TempoDownButton.addGestureRecognizer(recognizer1)
        recognizer1.view?.tag = 1
        
        tempoButtonArr = [TempoUpButton, TempoDownButton]
    }
    
    @objc func tempoButtonLongPressed(sender: UILongPressGestureRecognizer) {
        print("tempoButtonLongPressed, state: \(currentState)")
        if !checkForValidTempoInput() {return}
        if sender.state == .ended {
            wt.stopWaitThenOfType(iselector: #selector(tempoButtonUpdater) as Selector)
            tempoUpdaterCycle = 0.0
        } else if sender.state == .began {
            currentButtonLayer = tempoButtonArr![sender.view!.tag].pulsate(ilayer: currentButtonLayer)
            wt.waitThen(itime: 0.02, itarget: self, imethod: #selector(tempoButtonUpdater) as Selector, irepeats: true, idict: ["arg1": sender.view!.tag as AnyObject])
        } else if sender.state == .changed {}
    }

    let tempoHoldTimeThresholds = [1.2, 3.0, 4.5]
    @objc func tempoButtonUpdater(timer: Timer) {
        tempoUpdaterCycle += 1.0
        let resultObj = timer.userInfo as! [String: AnyObject]
        let dir = resultObj["arg1"] as! Int == 0 ? 1 : -1
        let tempoUpdaterThrehold = 5
        var mult = 1.0

        if tempoUpdaterCycle > 0, Int(tempoUpdaterCycle) % tempoUpdaterThrehold == 0 {
            if tempoUpdaterCycle >= tempoHoldTimeThresholds[tempoHoldTimeThresholds.count - 1] * 50 {
                mult = 30.0
            } else if tempoUpdaterCycle >= tempoHoldTimeThresholds[tempoHoldTimeThresholds.count - 2] * 50 {
                if tempoUpdaterCycle == tempoHoldTimeThresholds[tempoHoldTimeThresholds.count - 2] * 50 {
                    met!.bpm = (met!.bpm / 10.0).rounded(.up) * 10.0
                }
                mult = 10.0
            } else if tempoUpdaterCycle >= tempoHoldTimeThresholds[0] * 50 {
                if tempoUpdaterCycle == tempoHoldTimeThresholds[0] * 50 {
                    var parsedTempo = met!.bpm / 10.0
                    if parsedTempo > parsedTempo.rounded() {
                        parsedTempo = parsedTempo.rounded() + 0.5
                    } else {
                        parsedTempo = parsedTempo.rounded()
                    }
                    met!.bpm = parsedTempo * 10.0
                }
                mult = 5.0
            }
            let proposedNewBPM = met!.bpm + Double(dir) * mult
            if (proposedNewBPM <= met!.minBPM) {
                met!.bpm = met!.minBPM
            } else if (proposedNewBPM >= met!.maxBPM) {
                met!.bpm = met!.maxBPM
            } else {
                met!.bpm = proposedNewBPM
            }
            print(met!.bpm)
            TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        }
    }

    func setStateProperties(icurrentState: State, itempoButtonsActive: Bool, icurrentLevel: String, ilevelConstruct: [[String]], ilevelKey: String, itutorialComplete: String = "1.0") {
        print("itutorialComplete \(itutorialComplete)")
        currentState = icurrentState //TODO: should not need this, as state is more accuratly being setup in setupCurrentTask
//        defaultState = currentState
        currentLevel = icurrentLevel
        currentLevelConstruct = ilevelConstruct
        currentLevelKey = ilevelKey
        tutorialComplete = itutorialComplete == "1.0"
        currentBackgroundPic = backgroundPicDict[ilevelKey]!
    }

    func setupToSpecificState() {
        print("setupToSpecificState \(currentState)")

        if currentState == State.RecordingIdle {
            setButtonState(ibutton: PeriphButton0, ibuttonState: false)
        }
        // Scale/Arpeggio test
        if (returnValidState(iinputState: currentState, istateArr: [State.NotesTestIdle_NoTempo,State.NotesTestIdle_NoTempo])) {  //TODO: instead of checking against current state, check against currentLevelKey
            setupCurrentTask()
            defaultPeripheralIcon = ["play", "speaker.3", "info"] // music.note"
            activePeripheralIcon = ["pause", "speaker.slash", "arrowshape.turn.up.left"]
            setupTempoButtons(ibuttonsActive: tempoButtonsActive)
            displayMultipleFretMarkers(iinputArr: specifiedNoteCollection, ialphaAmount: 1.0)
        }
            setupPeripheralButtons(iiconArr: defaultPeripheralIcon)
    }

    @objc func setupCurrentTask() {
        let task = returnCurrentTask()
        let trimmedTask = trimCurrentTask(iinput: task)
        let dir = parseTaskDirection(iinput: task)
        tempoActive = parseTempoStatus(iinput: task)
        tempoButtonsActive = !tempoActive
        setupTempoButtons(ibuttonsActive: tempoButtonsActive)
        sCollection!.setupSpecifiedScale(iinput: trimmedTask, idirection: dir)
        resultsLabelDefaultText = sCollection!.returnReadableScaleName(iinput: trimmedTask)
        ResultsLabel.text = resultsLabelDefaultText
        
        
        if (currentLevelKey!.contains("scale")) {
            if (tempoActive) {
                currentState = State.NotesTestIdle_Tempo
            } else {
                currentState = State.NotesTestIdle_NoTempo
            }
        } else if currentLevelKey!.contains("arpeggio") {
            if (tempoActive) {
                currentState = State.NotesTestIdle_Tempo
            } else {
                currentState = State.NotesTestIdle_NoTempo
            }
        }
        defaultState = currentState

        let resultPopoverDirText: String
        var resultPopoverTempoText = "Tempo: "
        resultButtonText = ""

        if dir == "Up" {
            resultPopoverDirText = "Play From Low To High Note"
            resultButtonText = "Up"
        } else if dir == "Down" {
            resultPopoverDirText = "Play From High To Low Note"
            resultButtonText = "Down"
        } else {
            resultPopoverDirText = "Play From Low To High To Low"
            resultButtonText = "Up And Down"
        }

        resultButtonText += " / "

        if !tempoActive {
            resultPopoverTempoText += "None, Play Freely!"
            resultButtonText += "No Tempo"
        } else {
            let tempo = String(Int(met!.bpm)) + " BPM"
            resultPopoverTempoText += tempo
            resultButtonText += tempo
        }

        pc!.setResultButtonPopupText(itextArr: [ResultsLabel.text!, resultPopoverDirText, resultPopoverTempoText])
        setResultButton(istr: resultButtonText)
    }
    
    func setupBackgroundImage(ibackgroundPic: String) {
        let bgImage = UIImageView(image: UIImage(named: ibackgroundPic))
         bgImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
         bgImage.contentMode = UIView.ContentMode.scaleAspectFill
         self.view.insertSubview(bgImage, at: 0)
    }

    func returnCurrentTask() -> String {
        let level = returnConvertedLevel(iinput: currentLevel!)
        let subLevel = returnConvertedSubLevel(iinput: currentLevel!)

        // make sure the current level/sublevel is not out of range
        if currentLevelConstruct[level].count > subLevel {
            return currentLevelConstruct[level][subLevel]
        }

        // level/sublevel is out of range, return last task in construct
        return currentLevelConstruct[level][currentLevelConstruct[level].count - 1]
    }

    func trimCurrentTask(iinput: String) -> String {
        let signifiers = ["Up", "Tempo", "Both"]
        var modifiedStr = iinput
        if modifiedStr.contains("_") {
            for (_, str) in signifiers.enumerated() {
                if modifiedStr.contains(str) {
                    modifiedStr = modifiedStr.replacingOccurrences(of: "_" + str, with: "")
                    print("mod string\(modifiedStr)")
                }
            }
        }
        return modifiedStr
    }

    func parseTaskDirection(iinput: String) -> String {
        let signifiers = ["Up", "Down", "Both"]
        var dir = ""
        for (_, str) in signifiers.enumerated() {
            if iinput.contains(str) {
                dir = str
                break
            }
        }
        return dir
    }

    func parseTempoStatus(iinput: String) -> Bool {
        return iinput.contains("Tempo")
    }

    func setupPeripheralButtons(iiconArr: [String]) {
        for (i, _) in iiconArr.enumerated() {
            periphButtonArr[i].setTitle("", for: .normal) // TODO: eventually get rid of text completely

            setButtonImage(ibutton: periphButtonArr[i], iimageStr: iiconArr[i])
            periphButtonArr[i].imageView?.tintColor = defaultColor.AlternateButtonInlayColor
            periphButtonArr[i].layer.masksToBounds = true
            periphButtonArr[i].layer.cornerRadius = 25
//            periphButtonArr[i].setTitleColor(.black, for: .normal)
            periphButtonArr[i].backgroundColor = defaultColor.MenuButtonColor
//            periphButtonArr[i].imageView?.tintColor = defaultColor.MenuButtonTextColor
            periphButtonArr[i].imageView?.alpha = 1.0
//            giveButtonBackgroundShadow(ibutton: periphButtonArr[i])  //TODO: why isnt this working?
        }

        for (i, button) in periphButtonArr.enumerated() {
            if i < iiconArr.count {
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }

    func setPeriphButtonsToDefault(idefaultIcons: [String]) {
        for (i, _) in idefaultIcons.enumerated() {
            setButtonImage(ibutton: periphButtonArr[i], iimageStr: idefaultIcons[i])
        }
    }

    func setupTempoButtons(ibuttonsActive: Bool) {
        var buttonColor: UIColor
        var inlayColor: UIColor
        if ibuttonsActive {
            buttonColor = defaultColor.MenuButtonColor
            inlayColor = defaultColor.MenuButtonTextColor
        } else {
            buttonColor = defaultColor.InactiveButton
            inlayColor = defaultColor.InactiveInlay
        }

        TempoButton.backgroundColor = buttonColor
        TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        TempoButton.setTitleColor(inlayColor, for: .normal)
        TempoButton.layer.masksToBounds = true
        TempoButton.layer.cornerRadius = 25

        let insets: CGFloat = 18
        setButtonImage(ibutton: TempoDownButton, iimageStr: "arrowtriangle.down")
        TempoDownButton.contentVerticalAlignment = .fill
        TempoDownButton.contentHorizontalAlignment = .fill
        TempoDownButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        TempoDownButton.backgroundColor = buttonColor
        TempoDownButton.imageView?.tintColor = inlayColor
        TempoDownButton.imageView?.alpha = 0.2
        TempoDownButton.layer.masksToBounds = true
        TempoDownButton.layer.cornerRadius = 25
        TempoDownButton.imageView?.alpha = 1.0

        setButtonImage(ibutton: TempoUpButton, iimageStr: "arrowtriangle.up")
        TempoUpButton.contentVerticalAlignment = .fill
        TempoUpButton.contentHorizontalAlignment = .fill
        TempoUpButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        TempoUpButton.backgroundColor = buttonColor
        TempoUpButton.imageView?.tintColor = inlayColor
        TempoUpButton.layer.masksToBounds = true
        TempoUpButton.layer.cornerRadius = 25
        TempoDownButton.imageView?.alpha = 1.0
    }

    func setupFretMarkerText(ishowAlphabeticalNote: Bool, ishowNumericDegree: Bool, inumericDefaults: [String] = ["b5", "b6"]) {
        if !ishowAlphabeticalNote, !ishowNumericDegree {
            return
        }

        for (idx, _) in buttonDict {
            var str = buttonDict[idx]
            var note = ""
            if (ishowAlphabeticalNote) {
                note = str!.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789_"))
            } else {
                str = str!.replacingOccurrences(of: "_0", with: "").replacingOccurrences(of: "_1", with: "")
                note = sCollection!.returnNoteDistance(iinput: String(str!.dropLast()), icomparedNote: "A")
                if note == "#4", inumericDefaults[0] == "b5" {
                    note = "b5"
                } else if note == "#5", inumericDefaults[1] == "b6" {
                    note = "b6"
                }
            }
            dotText[idx].text = note
        }
    }

    func setButtonState(ibutton: UIButton, ibuttonState: Bool) {
        let alpha = ibuttonState ? 1.0 : 0.0
        ibutton.isEnabled = ibuttonState
        ibutton.alpha = CGFloat(alpha)
    }

    func setButtonImage(ibutton: UIButton, iimageStr: String) {
        if #available(iOS 13.0, *) {
            ibutton.setImage(UIImage(systemName: iimageStr), for: .normal)
            ibutton.imageView?.tintColor = defaultColor.MenuButtonTextColor // TODO: need?
            ibutton.imageView?.alpha = 1.0 // TODO: need?
//            periphButtonArr[0].setTitle("", for: .normal)  //TODO: test
        } else {
            // Fallback on earlier versions
            //            PeriphButton0.setImage(UIImage(named: "pencil"), for: UIControl.State.normal)  //i am not sure if this works
        }
    }
    
    func giveButtonBackgroundShadow(ibutton: UIButton) {
        ibutton.layer.shadowColor = UIColor.black.cgColor
        ibutton.layer.shadowOffset = CGSize(width: 2, height: 2)
        ibutton.layer.shadowRadius = 2
        ibutton.layer.shadowOpacity = 0.6
    }

    func setPeripheralButtonsToDefault() {
        for (i, str) in defaultPeripheralIcon.enumerated() {
            setButtonImage(ibutton: periphButtonArr[i], iimageStr: str)
        }
    }

    func recordTimeAccuracy() {
        if met!.currentClick >= met!.countInClick || true {
            userInputTime = CFAbsoluteTimeGetCurrent()

            if userInputTime - met!.clickTime > 0.5 {
            } else {
                let timeDelta = abs(userInputTime - met!.clickTime)
                if timeDelta < 0.05 {
                    print("good")
                } else {
                    print("late")
                }
                noteCollectionTestData[noteCollectionTestData.count - 1].time = userInputTime
                noteCollectionTestData[noteCollectionTestData.count - 1].timeDelta = timeDelta
            }
        }
        // sc.playSound(isoundName: "ButtonClick")
    }

    @IBAction func NavToMainMenu(_: Any) {
        var controller: MenuViewController

        controller = storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MenuViewController

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    func checkForValidTempoInput() -> Bool {
        if !tempoButtonsActive { return false }
        return !returnValidState(iinputState: currentState, istateArr: [State.NotesTestActive_NoTempo,State.PlayingNotesCollection])
    }

    @IBAction func scrollTempo(_ sender: UIButton) {
        print("scroll tempo, state: \(currentState)")
        if !checkForValidTempoInput() {return}
        pc!.resultButtonPopup.hide()
        let dir = sender.tag == 0 ? 1.0 : -1.0
        if (met!.bpm + dir >= met!.minBPM && met!.bpm + dir <= met!.maxBPM) {
            met!.bpm = met!.bpm + dir
            currentButtonLayer = tempoButtonArr![sender.tag].pulsate(ilayer: currentButtonLayer)
        }
        TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        tapTime.removeAll()
    }

    var tapTime: [Double] = []
    var currentTapTempo = 0.0
    @IBAction func tempoTapped(_: Any) {
        print("tempoTapped, state: \(currentState)")
        if !checkForValidTempoInput() {return}
        currentButtonLayer = TempoButton!.pulsate(ilayer: currentButtonLayer)
        wt.stopWaitThenOfType(iselector: #selector(timeoutTapTempo) as Selector)
        wt.waitThen(itime: 1.2, itarget: self, imethod: #selector(timeoutTapTempo) as Selector, irepeats: false, idict: ["arg1": 0 as AnyObject])
        tapTime.append(CFAbsoluteTimeGetCurrent())
        if tapTime.count > 1 {
            let tappedCount = Double(tapTime.count - 1)
            var accTime = 0.0
            for (i, _) in tapTime.enumerated() {
                if i > 0 {
                    accTime += tapTime[i] - tapTime[i - 1]
                }
            }
            met!.bpm = ((tappedCount / accTime) * 60).rounded()
            TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        }
    }

    @objc func timeoutTapTempo() {
        print("timeoutTapTempo")
        tapTime.removeAll()
    }

    @IBAction func startMetronome(_: Any) {
        met?.startMetro()
    }

    func handleTutorialInput(iwchButton: Int) -> Bool {
        if mainPopoverVisible {
            return false
        }

        if tutorialActive, currentTutorialPopup == iwchButton + 1 {
            progressTutorial()
            return false
        }
        return true
    }

    @IBAction func PeripheralButtonDown(_ sender: UIButton) {
        pc!.resultButtonPopup.hide()
        currentButtonLayer = periphButtonArr[sender.tag].pulsate(ilayer: currentButtonLayer)
        ResultsLabel.text = resultsLabelDefaultText
        switch sender.tag {
        case 0:
            PeripheralButton0OnButtonDown()
        case 1:
            PeripheralButton1OnButtonDown()
        case 2:
            PeripheralButton2OnButtonDown()
        case 3:
            //            PeripheralButton3OnButtonDown()
            break
        default:
            break
        }
    }

    // Peripheral Buttons Down
    @IBAction func PeripheralButton0OnButtonDown() {
        let wchButton = 0

        if !handleTutorialInput(iwchButton: wchButton) {
            return
        }
        
        print("PeripheralButton0OnButtonDown \(currentState)")
//        print("Audience.public.rawValue \(currentState.rawValue)")

        let s = #selector(pc!.enactTestReminder) as Selector
        wt.stopWaitThenOfType(iselector: s)
        pc!.reminderPopup.hide()
       
        // Scale Test States
        if (returnValidState(iinputState: currentState,
                             istateArr: [
                                State.NotesTestIdle_NoTempo,
                                State.NotesTestShowNotes,
                                State.NotesTestIdle_Tempo,
                                State.NotesTestShowNotes
                            ])) {
            currentState = toggleTestState(icurrentState: defaultState!)
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
            hideAllFretMarkers()
            setNavBarColor(istate: "Testing")
            noteCollectionTestData.removeAll()
            scaleButtonForClickableEase(ibutton: fretButtonDict[specifiedNoteCollection[0]]!)
            setResultButton(istr: resultButtonText)
            wt.stopWaitThenOfType(iselector: #selector(setResultButtonHelper) as Selector)
            if (currentState == State.NotesTestActive_Tempo) {
                currentState = State.NotesTestCountIn_Tempo
                met?.startMetro()
            }
            return
        } else if (returnValidState(iinputState: currentState,
                             istateArr: [
                                State.NotesTestActive_NoTempo,
                                State.NotesTestActive_Tempo,
                                State.NotesTestCountIn_Tempo
                            ])) {
            //if currentState == State.NotesTestActive_NoTempo {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
//            currentState = State.NotesTestIdle_NoTempo
            currentState = toggleTestState(icurrentState: currentState)
            met!.endMetronome()
            setResultButton(istr: resultButtonText)
            ResultsLabel.text = resultsLabelDefaultText
            wt.stopWaitThenOfType(iselector: #selector(setResultButtonHelper) as Selector)
            setNavBarColor()
            resetButtonFrames()
            return
        }
    }

    @IBAction func PeripheralButton1OnButtonDown() {
        let wchButton = 1

        if !handleTutorialInput(iwchButton: wchButton) {
            return
        }

        print("PeripheralButton1OnButtonDown \(currentState)")

        // Notes Test States
        if (returnValidState(iinputState: currentState,
                             istateArr: [
                                State.NotesTestIdle_NoTempo,
                                State.NotesTestIdle_Tempo,
                                State.NotesTestShowNotes
        ]))
        {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
            currentState = State.PlayingNotesCollection
            met?.startMetro()
            hideAllFretMarkers()
            return
        } else if currentState == State.PlayingNotesCollection {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
            currentState = State.NotesTestIdle_NoTempo
            met?.endMetronome()
            return
        }
    }

    @IBAction func PeripheralButton2OnButtonDown() {
        let wchButton = 2

        if !handleTutorialInput(iwchButton: wchButton) {
            return
        }

        print("PeripheralButton2OnButtonDown \(currentState)")

        // Scale Test States
        if (returnValidState(iinputState: currentState, istateArr: [
                State.NotesTestIdle_NoTempo,
                State.NotesTestIdle_Tempo,
        ])) {
                setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
                displayMultipleFretMarkers(iinputArr: specifiedNoteCollection, ialphaAmount: 1.0)
                currentState = State.NotesTestShowNotes
                return
            } else if currentState == State.NotesTestShowNotes {
                hideAllFretMarkers()
                currentState = defaultState!
                return
            }
    }

    @IBAction func ResultButtonDown(_: Any) {
        print("currentState \(currentState)")

        pc!.showResultButtonPopup()
    }

    @objc func onBackButtonDown(_: Any) {

        met!.endMetronome()
        var controller: MenuViewController

        controller = storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MenuViewController

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    @IBAction func onSettingsButtonDown(_ sender: Any) {
        print("OnSettingsButtonDown")
    }
    
    
    func setNavBarColor (istate: String = "Idle") {
        let color = istate == "Idle" ? defaultColor.MenuButtonColor : UIColor.red
        NavBar.barTintColor = color
        NavBarFiller.backgroundColor = color
    }

    @IBAction func FretPressed(_ sender: UIButton) {
        pc!.resultButtonPopup.hide()
        var tutorialDisplayed = false
        var inputNumb = sender.tag
        if inputNumb >= 100 {
            inputNumb -= 100
            tutorialDisplayed = true
        }

        if tutorialActive || mainPopoverVisible {
            if currentTutorialPopup < 4, !tutorialDisplayed {
                return
            } else if !tutorialDisplayed {
                if buttonDict[inputNumb] != specifiedNoteCollection[currentTutorialPopup - (defaultPeripheralIcon.count + 1)] {
                    return
                }
                progressTutorial()
            }
        }
        print("in fret pressed state \(currentState)")

        let validState = returnValidState(iinputState: currentState, istateArr: [
            State.Recording,
            State.Idle,
            State.EarTrainResponse,
            State.NotesTestActive_NoTempo,
            State.NotesTestIdle_NoTempo,
            State.NotesTestIdle_Tempo,
            State.NotesTestCountIn_Tempo,
            State.NotesTestActive_Tempo,
            State.NotesTestShowNotes,
            State.NotesTestActive_Tempo
        ])
        if validState {
            hideAllFretMarkers()
            
            if currentState == State.NotesTestShowNotes {
                currentState = State.NotesTestIdle_NoTempo
            }

            var str = buttonDict[inputNumb]!
            str = str.replacingOccurrences(of: "_0", with: "").replacingOccurrences(of: "_1", with: "")
            sc.playSound(isoundName: str, ioneShot: !tutorialActive, ifadeAllOtherSoundsDuration: defaultSoundFadeTime)
            print("fret pressed \(str)")
            displaySingleFretMarker(iinputStr: buttonDict[inputNumb]!, cascadeFretMarkers: tutorialActive)
            if currentState == State.Recording {
                if recordStartTime == 0 {
                    recordStartTime = CFAbsoluteTimeGetCurrent()
                }
                let r = InputData()
                r.time = CFAbsoluteTimeGetCurrent()
                r.note = buttonDict[inputNumb]!
                recordData.append(r)
            } else if currentState == State.EarTrainResponse {
                earTrainResponseArr.append(buttonDict[inputNumb]!)
                if earTrainResponseArr.count == earTrainCallArr.count {
                    presentEarTrainResults()
                }
            }

            
            //TODO: overlapping function invocations taking place below
            if (currentState == State.NotesTestActive_Tempo && noteCollectionTestData.count < specifiedNoteCollection.count) {
                let st = InputData()
                st.note = buttonDict[inputNumb]!
                st.time = 0
                noteCollectionTestData.append(st)
                recordTimeAccuracy()
            }

            if (currentState == State.NotesTestActive_NoTempo && noteCollectionTestData.count < specifiedNoteCollection.count) { //TODO: don't need to seperate string from raw value, now arp is
                let st = InputData()
                st.note = buttonDict[inputNumb]!
                st.time = 0
                noteCollectionTestData.append(st)
                
                var noteMismatch = false
                if (st.note != specifiedNoteCollection[noteCollectionTestData.count-1]) {
                    noteMismatch = true
                    flashActionOverlay(isuccess: false)
                    resetButtonFrames()
                }
                if (noteCollectionTestData.count == specifiedNoteCollection.count || developmentMode || noteMismatch) {
                    
                    //TODO: need to also set the arpeggio state to noTempo FUCK
//                    currentState = State.NotesTestIdle_NoTempo
//                    setPeriphButtonsToDefault(idefaultIcons: defaultPeripheralIcon)
//                    setNavBarColor()
//                    resetButtonFrames()
                                        
                    let notesCorrect = sCollection!.analyzeScale(iscaleTestData: noteCollectionTestData)
                    onTestComplete(inotesCorrect : notesCorrect)
                    wt.waitThen(itime: 0.5, itarget: self, imethod: #selector(presentTestResult) as Selector, irepeats: false, idict: ["notesCorrect": notesCorrect as AnyObject])
                } else {
                    scaleButtonForClickableEase(ibutton: fretButtonDict[specifiedNoteCollection[noteCollectionTestData.count]]!)
                }
            }
        }
    }
    
    func onTestComplete(inotesCorrect : Bool) {
        
        setPeriphButtonsToDefault(idefaultIcons: defaultPeripheralIcon)
        setNavBarColor()
        resetButtonFrames()
//        currentState = toggleTestState()
        if (inotesCorrect) {
            flashActionOverlay(isuccess: true)
            //Vibration.success.vibrate()
        }
    }
    
    func toggleTestState(icurrentState: State) -> State {
        let currentStateStr = icurrentState.rawValue
        print("toggle state in \(currentStateStr)")
        var newState: State
        if (currentStateStr.contains("Active") || currentStateStr.contains("CountIn")) {
            newState = currentStateStr.contains("_NoTempo") ? State.NotesTestIdle_NoTempo : State.NotesTestIdle_Tempo
        } else {
            newState = currentStateStr.contains("_NoTempo") ? State.NotesTestActive_NoTempo : State.NotesTestActive_Tempo
        }
        print("toggle state out \(newState)")
        return newState
    }
    
    func scaleButtonForClickableEase(ibutton: UIButton) {
        resetButtonFrames()
        let enlargementFactor: CGFloat = 1.5
        let buttonFrame = ibutton.frame
        ibutton.layer.zPosition = 1000 //for dev purposes
        view.bringSubviewToFront(ibutton)  //this will cause issues with the complete button
        ibutton.frame =
               CGRect(
                  x: buttonFrame.minX-(buttonFrame.width*enlargementFactor)/2+buttonFrame.width/2,
                  y: buttonFrame.minY-(buttonFrame.height*enlargementFactor)/2+buttonFrame.height/2,
                  width: buttonFrame.width*enlargementFactor,
                  height: buttonFrame.height*enlargementFactor)
    }

    func resetButtonFrames() {
        for (str,fretButton) in fretButtonDict {
            fretButton.frame = fretButtonFrame[str]!
        }
    }

    @objc func presentTestResult(timer: Timer) {
        var testPassed = false
        let resultObj = timer.userInfo as! [String: AnyObject]
        if let test = resultObj["notesCorrect"] {
            testPassed = test as! Bool
        } else {}

        var resultsText = ""
        resultsText = testPassed ? "Great!" : "Try Again!"
        setResultButton(istr: resultsText)
        analyzeNewLevel(itestPassed: testPassed)
        currentState = toggleTestState(icurrentState: currentState)
    }

    func analyzeNewLevel(itestPassed: Bool) {
        if !itestPassed && !developmentMode {
            wt.waitThen(itime: 3.0, itarget: self, imethod: #selector(setResultButtonHelper) as Selector, irepeats: false, idict: ["arg1": resultButtonText as AnyObject])
            return
        }

        print("sub level passed \(userLevelData.scaleLevel)")
        
        var level = returnConvertedLevel(iinput: currentLevel!)
        var subLevel = returnConvertedSubLevel(iinput: currentLevel!) + 1

        if subLevel == currentLevelConstruct[level].count {
            // upgrade level
            let levelConstruct = LevelConstruct()
            if level < levelConstruct.scale.count - 1 {
                level = level + 1
                subLevel = 0
                wt.waitThen(itime: 0.1, itarget: self, imethod: #selector(presentMainPopover) as Selector, irepeats: false, idict: ["arg1": "LevelComplete" as AnyObject, "arg2": level as AnyObject])
            } else {
                //subLevel = subLevel - 1
            }
        }

        currentLevel = "\(level).\(subLevel)"
        UserDefaults.standard.set(currentLevel, forKey: currentLevelKey!)
        print("updated current level \(currentLevel ?? "")")
        
//        Vibration.success.vibrate()
        
        //TODO: this will need to be cancelled if premature input
        wt.waitThen(itime: 2, itarget: self, imethod: #selector(setupCurrentTask) as Selector, irepeats: false, idict: ["arg1": 0 as AnyObject])
    }

    // these functions should exist inone place
    func returnConvertedLevel(iinput: String) -> Int {
        let numb = Int(iinput.split(separator: ".")[0])
        return numb!
    }

    func returnConvertedSubLevel(iinput: String) -> Int {
        let numb = Int(iinput.split(separator: ".")[1])
        return numb!
    }

    @IBAction func record(_: Any) {
        recordStartTime = 0
        currentState = State.Recording
        recordData.removeAll()
    }

    @IBAction func stopRecording(_: Any) {
        print("stopRecording\(recordStartTime)")
        currentState = State.Playback

        for (i, data) in recordData.enumerated() {
//            _ = Timer.scheduledTimer(timeInterval: data.time - recordStartTime, target: self, selector: #selector(playSoundHelper), userInfo: ["Note": data.note], repeats: false)
            wt.waitThen(itime: data.time - recordStartTime, itarget: self, imethod: #selector(playSoundHelper) as Selector, irepeats: false, idict: ["Note": data.note as AnyObject])
            if i == recordData.count - 1 {
                setState(newState: State.Idle)
            }
        }
    }

    @IBAction func earTrainingPressed(_: Any) {
        let numbNotes = 5
        for _ in 0 ..< numbNotes {
            earTrainCallArr.append(tempScale[rand(max: tempScale.count)])
        }
        currentState = State.EarTrainCall
        met?.currentClick = 0
        let displayT = 1.0
        
        wt.waitThen(itime: displayT, itarget: self, imethod: #selector(beginEarTrainingHelper) as Selector, irepeats: false, idict: ["NoteSelection": tempScale as AnyObject, "AlphaVal": 0.0 as AnyObject])

        displaySelectionDots(inoteSelection: tempScale, ialphaAmount: 0.5)
        dotDict[earTrainCallArr[0]]?.alpha = 1
    }

    //State Handlers
    func setState(newState: State) {
        print("setting \(newState)")
        currentState = newState
    }

    @objc func setStateHelper(timer: Timer) {
        let stateDict = timer.userInfo as! [String: AnyObject]
        setState(newState: stateDict["state"] as! State)
    }
    
    func returnValidState(iinputState: State, istateArr: [State]) -> Bool {
        for (_, item) in istateArr.enumerated() {
            if iinputState == item {
                return true
            }
        }
        return false
    }

    @objc func playSoundHelper(timer: Timer) {
        let noteDict = timer.userInfo as! [String: AnyObject]
        sc.playSound(isoundName: noteDict["Note"] as! String)

        displaySingleFretMarker(iinputStr: noteDict["Note"] as! String)
    }

    func killCurrentDotFade() {
        if dotFadeTime != nil {
            dotFadeTime?.invalidate()
            dotFadeTime = nil
        }
    }

    func displayMultipleFretMarkers(iinputArr: [String], ialphaAmount: Float) {
        killCurrentDotFade()
        for (str, _) in dotDict {
            dotDict[str]!.alpha = 0.0

            if iinputArr.contains(str) {
                swoopAlpha(iobject: dotDict[str]!, ialpha: Float(ialphaAmount), iduration: 0.1)
                swoopScale(iobject: dotDict[str]!, iscaleX: 0, iscaleY: 0, iduration: 0)
                swoopScale(iobject: dotDict[str]!, iscaleX: 1, iscaleY: 1, iduration: 0.1)
            }
        }

        allMarkersDisplayed = true
    }

    func hideAllFretMarkers() {
        if allMarkersDisplayed {
            killCurrentDotFade()
            setButtonImage(ibutton: periphButtonArr[2], iimageStr: defaultPeripheralIcon[2])
            for (str, _) in dotDict {
                dotDict[str]!.alpha = 0.0
            }
            allMarkersDisplayed = false
        }
    }

    func displaySingleFretMarker(iinputStr: String, cascadeFretMarkers: Bool = false) {
        if previousNote != nil, !cascadeFretMarkers {
            dotDict[previousNote!]?.alpha = 0.0
            swoopAlpha(iobject: dotDict[previousNote!]!, ialpha: Float(0.0), iduration: 0.3)
        }
        previousNote = iinputStr

        dotDict[iinputStr]!.alpha = 0.0

        swoopAlpha(iobject: dotDict[iinputStr]!, ialpha: Float(1.0), iduration: 0.1)
        killCurrentDotFade()
        swoopScale(iobject: dotDict[iinputStr]!, iscaleX: 0, iscaleY: 0, iduration: 0)
        swoopScale(iobject: dotDict[iinputStr]!, iscaleX: 1, iscaleY: 1, iduration: 0.1)

        if !cascadeFretMarkers {
            dotFadeTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alphaSwoopImage), userInfo: ["ImageId": iinputStr], repeats: false)
        }
    }

    @objc func alphaSwoopImage(timer: Timer) {
        let image = timer.userInfo as! [String: AnyObject]
        swoopAlpha(iobject: dotDict[image["ImageId"] as! String]!, ialpha: Float(0.0), iduration: 0.2)
    }

    func swoopScale(iobject: UIView, iscaleX: Double, iscaleY: Double, iduration: Double) {
        UIView.animate(withDuration: iduration, animations: { () -> Void in
            iobject.transform = CGAffineTransform(scaleX: CGFloat(iscaleX), y: CGFloat(iscaleY))
        }, completion: nil)
    }

    func swoopAlpha(iobject: UIImageView, ialpha: Float, iduration: Float) {
        UIView.animate(withDuration: TimeInterval(iduration), animations: {
            iobject.alpha = CGFloat(ialpha)
        }, completion: nil)
    }

    func rand(max: Int) -> Int {
        return Int.random(in: 0 ..< max)
    }

    func presentEarTrainResults() {
        let resultText = earTrainCallArr == earTrainResponseArr ? "Good" : "Bad"
        ResultsLabel.text = resultText
//        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(setResultsLabel), userInfo: nil, repeats: false)
        wt.waitThen(itime: 2, itarget: self, imethod: #selector(setResultsLabel) as Selector, irepeats: false, idict: ["arg1": "" as AnyObject])
        earTrainCallArr.removeAll()
        earTrainResponseArr.removeAll()
        currentState = State.Idle
    }

    @objc func beginEarTrainingHelper(timer: Timer) {
        let argDict = timer.userInfo as! [String: AnyObject]
        displaySelectionDots(inoteSelection: argDict["NoteSelection"] as! [String], ialphaAmount: argDict["AlphaVal"] as! Double)
        met?.startMetro()
    }

    func displaySelectionDots(inoteSelection: [String], ialphaAmount: Double) {
        for (_, item) in inoteSelection.enumerated() {
            dotDict[item]?.alpha = CGFloat(ialphaAmount)
        }
    }

    @objc func setResultsLabel(timer: Timer? = nil) {
        return //TODO: this function should not exist
        var str = ""
        if timer != nil {
            let argDict = timer?.userInfo as! [String: AnyObject]
            str = argDict["arg1"] as! String
        }
        ResultsLabel.text = str
    }
    
    func setResultButton(istr: String? = "") {
        var str = istr == nil ? "" : istr
        ResultButton.setTitle(str, for: .normal)
    }
    
    @objc func setResultButtonHelper(timer: Timer) {
        let argDict = timer.userInfo as! [String: AnyObject]
        setResultButton(istr: argDict["arg1"] as! String)
    }

    @IBAction func closeMainPopover(_: Any) {
        mainPopover.removeFromSuperview()
        if tutorialActive {
            progressTutorial()
        } else if (mainPopoverState == "Tutorial") {
            allMarkersDisplayed = true
            swoopAlpha(iobject: DimOverlay, ialpha: 0, iduration: 0.3)
            pc!.startTestReminder(itime: 20)

            var tutorialComplete = UserDefaults.standard.object(forKey: "tutorialComplete")
            tutorialComplete = tutorialComplete as! String == "0.0" ? "1.0" : "2.0"
            UserDefaults.standard.set(tutorialComplete, forKey: "tutorialComplete")
        } else if (mainPopoverState == "LevelComplete") {
            swoopAlpha(iobject: DimOverlay, ialpha: 0, iduration: 0.3)
        }
        
        

        mainPopoverVisible = false
    }

    var testVar = 0
    @IBAction func testButton(_: Any) {
        
        randomButtonTest()
        
    }
    
    @objc func randomButtonTest() {

        let randNumb = rand(max: 4)
        switch randNumb {
        case 0:
            let button = UIButton()
            button.tag = rand(max: 2)
            scrollTempo(button)
            break
        case 1:
            let button = UIButton()
            button.tag = rand(max: defaultPeripheralIcon.count)
            PeripheralButtonDown(button)
        case 2:
            let button = UIButton()
            button.tag = rand(max: defaultPeripheralIcon.count)
            tempoTapped(button)
        case 3:
            let randomName = fretButtonDict.randomElement()!
            FretPressed(fretButtonDict[randomName.key]!)
        default: break
        }
        let t = Double(rand(max: 50))/100.0
        wt.waitThen(itime: t, itarget: self, imethod: #selector(randomButtonTest) as Selector, irepeats: false, idict: ["arg1": "0" as AnyObject])
    }
    
    func flashActionOverlay (isuccess: Bool) {
        if (isuccess) {
            ActionOverlay.backgroundColor! = UIColor.white
        } else {
            ActionOverlay.backgroundColor! = UIColor.red
        }
        swoopAlpha(iobject: ActionOverlay, ialpha: 0.6, iduration: 0.0)
        swoopAlpha(iobject: ActionOverlay, ialpha: 0.0, iduration: 0.5)
    }

    @objc func presentMainPopover(timer: Timer) {
        let resultObj = timer.userInfo as! [String: AnyObject]
        let type = resultObj["arg1"] as! String
        let levelPassed = resultObj["arg2"] as! Int
        mainPopoverState = type
        // https://www.youtube.com/watch?v=qS21yjo822Y
        if (type == "Tutorial") {
            pc!.tutorialPopup.hide()
            tutorialActive = !tutorialActive
            mainPopoverTitle.text = "FRET MASTER™"
            mainPopoverBodyText.text = "Welcome To Fret Master™! You will learn and sharpen valuable skiills needed to become a great guitarist! Let get started with a simple tutorial!"
        } else if (type == "LevelComplete") {
            mainPopoverTitle.text = "LEVEL \(levelPassed) PASSED"
            mainPopoverBodyText.text = "Congratulations- keep working hard!"
        }
        
        swoopAlpha(iobject: DimOverlay, ialpha: 0.8, iduration: 0.3)
        view.addSubview(mainPopover)
        mainPopover.center = view.center
        mainPopover.center.y -= 50
        mainPopoverVisible = true
        view.bringSubviewToFront(mainPopoverButton)
        
        //reset tempo/peripheral button layer orders
        for button in tempoButtonArr! {
            setLayer(iobject: button, ilayer: "Default")
        }
        for button in periphButtonArr {
            setLayer(iobject: button, ilayer: "Default")
        }
    }

    func progressTutorial() {
        print("progressing tutorial")
        pc!.tutorialPopup.hide()

        let peripheralButtonTutorialNumb = defaultPeripheralIcon.count
        if currentTutorialPopup == tutorialPopupText.count {
            swoopAlpha(iobject: DimOverlay, ialpha: 0.0, iduration: 0.15)
            tutorialActive = false
            periphButtonArr[defaultPeripheralIcon.count - 1].layer.zPosition = getLayer(ilayer: "Default")
            pc!.startTestReminder(itime: 20)
            return
        }
        for i in 0 ..< peripheralButtonTutorialNumb {
            setLayer(iobject: periphButtonArr[i], ilayer: "Default")
        }

        // peripheral button popups
        var parentType = ""
        if currentTutorialPopup < peripheralButtonTutorialNumb {
            setLayer(iobject: periphButtonArr[currentTutorialPopup], ilayer: "TutorialFrontLayer0")
            parentType = "PeripheralButton"

        } else if currentTutorialPopup < tutorialPopupText.count - 1 {
            // show starting note
            let buttonStr = specifiedNoteCollection[currentTutorialPopup - peripheralButtonTutorialNumb]

            for (_, dot) in specifiedNoteCollection.enumerated() {
                setLayer(iobject: dotDict[dot]!, ilayer: "TutorialFrontLayer1")  //TODO: what to do here?
            }
            setLayer(iobject: FretboardImage, ilayer: "TutorialFrontLayer0")
            setLayer(iobject: dotDict[buttonStr]!, ilayer: "TutorialFrontLayer1")
            parentType = buttonStr + "Fret"

            let button = UIButton()
            button.tag = buttonDict.filter { $1 == buttonStr }.map { $0.0 }[0] + 100

            FretPressed(button)
        } else {
            if developmentMode {
                pc!.tutorialPopup.hide()
            }
            for (_, dot) in specifiedNoteCollection.enumerated() {
                setLayer(iobject: dotDict[dot]!, ilayer: "Default")
            }
            setLayer(iobject: FretboardImage, ilayer: "Default")
            pc!.tutorialPopup.hide()
            mainPopoverBodyText.font = mainPopoverBodyText.font.withSize(35)
            mainPopoverBodyText.text = tutorialPopupText[tutorialPopupText.count - 1]
            wt.waitThen(itime: 0.4, itarget: self, imethod: #selector(presentMainPopover) as Selector, irepeats: false, idict: ["arg1": "Tutorial" as AnyObject, "arg2": 0 as AnyObject])
            return
        }
        wt.waitThen(itime: 0.3, itarget: self, imethod: #selector(presentTutorialPopup) as Selector, irepeats: false, idict: ["arg1": currentTutorialPopup as AnyObject, "arg2": parentType as AnyObject])

        currentTutorialPopup += 1
        print("currentTutorialPopup \(currentTutorialPopup)")
    }

    @IBAction func OverlayButtonFunc(_: Any) {

    }

    func returnStackViewButtonCoordinates(istackViewButton: UIButton, istack: UIStackView, ixoffset: CGFloat = 0.0, iyoffset: CGFloat = 0.0) -> CGRect {
        let spacing = istack.arrangedSubviews[1].frame.minY - istack.arrangedSubviews[0].frame.minY
        let minX = istack.frame.minX + ixoffset
        let minY = istack.frame.minY - CGFloat(spacing) + istackViewButton.frame.height / 2 + istackViewButton.frame.minY + iyoffset
        let width = istack.frame.width
        let height = istack.frame.height
        let view1 = UIView(frame: CGRect(x: minX, y: minY, width: width, height: height))
        return view1.frame
    }

    func setupPopupTutorialText() {
        tutorialPopupText = ["The TEST button will begin the test!",
                             "The PLAY button will play the scale!",
                             "The INFO button will display the scale!",
                             "Start With This Note!",
                             "This Is The Next Note",
                             "This Is The Next Note",
                             "This Is The Next Note",
                             "This Is The Next Note",
                             "This Is The Next Note",
                             "This Is The Next Note",
                             "This Is The Next Note",
                             "This Is The Next Note",
                             "This Is The Next Note",
                             "This Is The Last Note",
                             "Tutorial Complete!"]
    }

    func setLayer(iobject: AnyObject, ilayer: String) {
        if #available(iOS 13.0, *) {
            iobject.layer.zPosition = getLayer(ilayer: ilayer)
        } else {
            // Fallback on earlier versions
            print("Fallback within set Layer")
        }
    }

    func getLayer(ilayer: String) -> CGFloat {
        let layer = layerArr.firstIndex(of: ilayer)
        if layer != nil {
            return CGFloat(layer!)
        }
        print("layer does not exist")
        return 0
    }

    @objc func presentTutorialPopup(timer: Timer) {
        let argDict = timer.userInfo as! [String: AnyObject]
        let wchPopup = argDict["arg1"] as! Int
        let popupObjectParentType = argDict["arg2"] as! String
        if popupObjectParentType == "PeripheralButton" {
            let c = returnStackViewButtonCoordinates(istackViewButton: periphButtonArr[wchPopup], istack: PeripheralStackView, iyoffset: -25)
            pc!.tutorialPopup.show(text: tutorialPopupText[wchPopup], direction: .left, maxWidth: 200, in: view, from: c)
        } else if popupObjectParentType.contains("Fret") {
            let buttonStr = popupObjectParentType.replacingOccurrences(of: "Fret", with: "")
            
           
//            let frame = view.convert(dotDict[buttonStr]!.frame, from:fretButtonDict[buttonStr]!)
            let frame = dotDict[buttonStr]!.frame
            pc!.tutorialPopup.show(text: tutorialPopupText[wchPopup], direction: .left, maxWidth: 200, in: view, from: frame)
        } else {
            print("got here")
            pc!.tutorialPopup.shouldDismissOnTap = true
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            let center = UIView(frame: CGRect(x: screenWidth / 2, y: screenHeight / 2, width: 0, height: 0))
            pc!.tutorialPopup.show(text: tutorialPopupText[wchPopup], direction: .none, maxWidth: 700, in: view, from: center.frame)
        }
    }

    // TODO: blurred functionality that you can simply parent to the dimOverlay, or like-minded object
    /*
     func addBlurArea(area: CGRect, style: UIBlurEffect.Style) {
         let effect = UIBlurEffect(style: style)
         let blurView = UIVisualEffectView(effect: effect)

         let container = UIView(frame: area)
         blurView.frame = CGRect(x: 0, y: 0, width: area.width, height: area.height)
         container.addSubview(blurView)
         container.alpha = 0.9
         self.view.addSubview(container)
     }

     private func addBlurEffect() {
         let blurEffect = UIBlurEffect(style: .dark)
         let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.alpha = 0.8

         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

         blurEffectView.translatesAutoresizingMaskIntoConstraints = false
         self.view.addSubview(blurEffectView)

         NSLayoutConstraint(item: blurEffectView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
         NSLayoutConstraint(item: blurEffectView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
         NSLayoutConstraint(item: blurEffectView, attribute: .height,  relatedBy: .equal, toItem: self.view, attribute: .height,  multiplier: 1.0, constant: -500).isActive = true
         NSLayoutConstraint(item: blurEffectView, attribute: .width,   relatedBy: .equal, toItem: self.view, attribute: .width,   multiplier: 1.0, constant: 0).isActive = true
       }
     */

    func toggleDevMode() {
        developmentMode = !developmentMode
    }
    
    func setupScreenOverlay() -> UIImageView {
        let overlay = UIImageView()
        overlay.frame = CGRect(x: NavBar.frame.minX, y: NavBar.frame.minY+NavBar.frame.height, width: view.frame.width, height: view.frame.height)
        overlay.alpha = 0.0
        return overlay
    }

    func setupFretBoardImage() {
        let noteInputStrs = ["G#1", "A1", "A#1", "B1", "C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2", "C3", "C#3", "D3", "D#3_0", "D#3_1", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3", "C4"]
        
        let fretMarkerImageOffset : [String:CGFloat] = [
           "G#1": 1.2,
           "A1" : 1.2,
           "A#1":1.2,
           "B1" :1.2,
           "C2" :1.2,
           "C#2":1.0,
           "D2" :1.0,
           "D#2":1.0,
           "E2" :1.0,
           "F2" :1.0,
           "F#2":1.0,
           "G2" :0.9,
           "G#2":1.0,
           "A2" :1.0,
           "A#2":1.0,
           "B2" :1.0,
           "C3" :1.0,
           "C#3":1.0,
           "D3" :1.0,
           "D#3_0" :1.0,
           "D#3_1" :1.0,
           "E3" :1.0,
           "F3" :1.0,
           "F#3" :1.0,
           "G3" :1.0,
           "G#3":0.8,
           "A3" :0.8,
           "A#3":0.8,
           "B3" :0.8,
           "C4" :0.8,
        ]

        let image: UIImage = UIImage(named: "Fretboard4")!
        FretboardImage = UIImageView()
        FretboardImage.image = image
        setLayer(iobject: FretboardImage, ilayer: "Default")
        
        let fretboardAspectFit = AVMakeRect(aspectRatio: FretboardDummy.image!.size, insideRect: FretboardDummy.bounds)
        
        print(FretboardDummy.frame)
        print("fretboardAspectFit \(fretboardAspectFit)")
        
        FretboardDummy.alpha = 0

        var fretboardXLoc = CGFloat(FretboardDummy.frame.minX+fretboardAspectFit.minX)
        let fretboardYLoc = FretboardDummy.frame.minY
        let fretboardWidth = fretboardAspectFit.width
        let fretboardHeight = fretboardAspectFit.height //FretboardDummy.frame.height
        
        let iphone11AspectFitWidth = 227.35955056179776

//        print("UIDevice.modelName \(UIDevice.modelName)")
//        if UIDevice.modelName.contains("iPhone 8") && !UIDevice.modelName.contains("iPhone 8 Plus") || UIDevice.modelName.contains("iPhone 11 Pro") && !UIDevice.modelName.contains("iPhone 11 Pro Max") {
//            fretboardXLoc -= 20
//        }


        FretboardImage.frame = CGRect(x: fretboardXLoc,
                                y: fretboardYLoc,
                                width: fretboardWidth,
                                height: fretboardHeight)
        FretboardImage.alpha = 1.0

        fretboardXLoc *= FretboardDummy.frame.width/fretboardAspectFit.width// * fretboardAspectFit.width/iphone11AspectFitWidth
        
        view.addSubview(FretboardImage)

        let buttonSize: [CGFloat] = [0.03, 0.2, 0.195, 0.18, 0.17, 0.163]
       
//        let buttonWidth: [CGFloat] = [0.3, 0.1667, 0.1667, 0.165, 0.158, 0.15]
        let buttonWidth: [CGFloat] = [0.18, 0.164, 0.164, 0.164, 0.164, 0.18]

        let color = [UIColor.blue, UIColor.yellow, UIColor.red, UIColor.green, UIColor.black, UIColor.cyan]
        var buttonTag = 0

        for string in 0 ... 5 {
            var xOffset: CGFloat = -15*fretboardAspectFit.width/CGFloat(iphone11AspectFitWidth)
            for k in 0 ..< string {
                xOffset += FretboardImage.frame.width * buttonWidth[k]
            }

            for i in 0 ... 5 {
                let button = UIButton()
                let height = FretboardImage.frame.height * buttonSize[i]
                var yOffset: CGFloat = 0
                if i > 0 {
                    for j in 1 ... i {
                        yOffset += FretboardImage.frame.height * buttonSize[j - 1]
                    }
                }

                let width = FretboardImage.frame.width * buttonWidth[string]
                button.frame = CGRect(x: fretboardXLoc + xOffset, y: FretboardImage.frame.minY + yOffset, width: width, height: height)
                
//                button.backgroundColor = color[(i+string)%color.count]
//                button.alpha = 0.5

                view.addSubview(button)

                if i > 0 {
                    button.addTarget(self, action: #selector(FretPressed), for: .touchDown)
                    button.tag = buttonTag

                    let image = UIImageView()
                    let imageXOffset: CGFloat = 0

                    let imageSize = 34 * (fretboardAspectFit.width/CGFloat(iphone11AspectFitWidth))
                    //image.frame = CGRect(x: button.frame.width / 2 - imageSize / 2 - imageXOffset, y: button.frame.height / 2 - 20, width: imageSize, height: imageSize)
                    //adding image to view to avoid z position problems
//                    let offset = button.frame.minX * fretMarkerImageOffset["G#1"]!
                    image.frame = CGRect(
                            x: (button.frame.width / 2 * fretMarkerImageOffset[noteInputStrs[buttonTag]]!)  - imageSize / 2 - imageXOffset + button.frame.minX,
                            y: button.frame.height / 2 - 20 + button.frame.minY,
                            width: imageSize,
                            height: imageSize)
                    
                    image.backgroundColor = UIColor.red
                    image.layer.masksToBounds = true
                    image.layer.cornerRadius = image.frame.width / 2
                    
                    //adding image to view to avoid z position problems
                    //button.addSubview(image)
                    view.addSubview(image)

                    let noteLabel = UILabel()
                    noteLabel.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
                    noteLabel.textAlignment = NSTextAlignment.center
                    noteLabel.text = "C#"
                    noteLabel.layer.zPosition = 1
                    image.addSubview(noteLabel)
                    dotText.append(noteLabel)

                    fretButtonDict[noteInputStrs[buttonTag]] = button
                    dotDict[noteInputStrs[buttonTag]] = image
                    fretButtonFrame[noteInputStrs[buttonTag]] = button.frame
                    buttonTag += 1
                }
            }
        }
        fretButtonDict["A1"]?.layer.zPosition = 1000
        fretButtonDict["A2"]?.layer.zPosition = 1000
    }

    @objc func buttonActionTemp(sender: UIButton!) {
        print("here \(sender.tag)")
    }
}

class PopupController {
    let vc: MainViewController?
    let tutorialPopup = PopTip()
    let reminderPopup = PopTip()
    let resultButtonPopup = PopTip()
    var resultButtonView: UIView?
    var resultButtonPopupVisible = false

    init(ivc: MainViewController) {
        vc = ivc

        tutorialPopup.textColor = UIColor.white
        tutorialPopup.bubbleColor = UIColor(red: 80/255, green: 184/255, blue: 231/255, alpha: 1.0) //TODO: put in color class
        tutorialPopup.shouldDismissOnTap = false
        tutorialPopup.shouldDismissOnTapOutside = false
        tutorialPopup.animationOut = 0.15

        vc!.setLayer(iobject: tutorialPopup, ilayer: "PopOverLayer")

        reminderPopup.textColor = UIColor.blue
        reminderPopup.bubbleColor = UIColor.red
        //        reminderPopup.shouldDismissOnTap = false
        //        reminderPopup.shouldDismissOnTapOutside = false

        resultButtonPopup.textColor = UIColor.white
        resultButtonPopup.bubbleColor = UIColor.red
//        resultButtonPopup.layer.zPosition = 2.0
        vc!.setLayer(iobject: resultButtonPopup, ilayer: "PopOverLayer")
        resultButtonPopup.dismissHandler = { _ in
            self.resultButtonPopupVisible = false
        }
        resultButtonPopup.appearHandler = { _ in
            self.resultButtonPopupVisible = true
        }
    }

    @objc func startTestReminder(itime: Double) {
        vc!.wt.waitThen(itime: itime, itarget: self, imethod: #selector(enactTestReminder) as Selector, irepeats: false, idict: ["arg1": 0 as AnyObject])
    }

    @objc func enactTestReminder(timer _: Timer) {
        let c = vc!.returnStackViewButtonCoordinates(istackViewButton: vc!.periphButtonArr[0], istack: vc!.PeripheralStackView, iyoffset: -25)
        reminderPopup.show(text: "Start Test When Ready!", direction: .left, maxWidth: 200, in: vc!.view, from: c)
    }

    func setResultButtonPopupText(itextArr: [String]) {
        let textSpacing = 30
        let popoverSize = (vc!.returnStackViewButtonCoordinates(istackViewButton: vc!.PeriphButton0, istack: vc!.PeripheralStackView).maxX - vc!.TempoDownButton.frame.maxX) * 0.72
        resultButtonView?.removeFromSuperview()
        resultButtonView = UIView(frame: CGRect(x: 0, y: 0, width: Int(popoverSize), height: itextArr.count * textSpacing))

        for (i, _) in itextArr.enumerated() {
            let popoverText = UILabel()
            popoverText.frame = CGRect(x: 0, y: i * textSpacing, width: Int(popoverSize), height: textSpacing)
            popoverText.textAlignment = NSTextAlignment.center
            popoverText.text = itextArr[i]
            popoverText.layer.zPosition = 2.0
            popoverText.textColor = UIColor.white
            resultButtonView!.addSubview(popoverText)
        }
    }

    func showResultButtonPopup() {
        if !resultButtonPopupVisible {
            var mid = vc!.ResultButton.frame
            mid = mid.offsetBy(dx: 0.0, dy: 10.0)
            resultButtonPopup.show(customView: resultButtonView!, direction: .down, in: vc!.view, from: mid)
        } else {
            resultButtonPopup.hide()
//                resultButtonPopupVisible = false
        }
    }
}
