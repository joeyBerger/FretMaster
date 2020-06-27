
import AVFoundation
import Foundation
import UIKit
import SCLAlertView
import CoreData

class MainViewController: UIViewController {
    // Outlets
    @IBOutlet var ResultsLabel: UILabel!
    @IBOutlet var ResultButton: UIButton!
    @IBOutlet var PeriphButton0: UIButton!
    @IBOutlet var PeriphButton1: UIButton!
    @IBOutlet var PeriphButton2: UIButton!
    @IBOutlet var PeriphButton3: UIButton!
    @IBOutlet var PeriphButton4: UIButton!

    @IBOutlet var TempoButton: UIButton!
    @IBOutlet var TempoDownButton: UIButton!
    @IBOutlet var TempoUpButton: UIButton!
    @IBOutlet weak var FretOffsetButton: UIButton!
    
    @IBOutlet var mainPopover: UIView!
    @IBOutlet var mainPopoverCloseButton: UIButton!
    @IBOutlet var mainPopoverBodyText: UILabel!
    @IBOutlet var mainPopoverTitle: UILabel!
    @IBOutlet var mainPopoverButton: UIButton!

    @IBOutlet var FretboardDummy: UIImageView!
    @IBOutlet var PeripheralStackView: UIStackView!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    
    var FretboardImage: UIImageView!
    var FretRefText = UILabel()
    var DimOverlay: UIImageView!
    var ActionOverlay: UIImageView!
    var dotDict: [String: SpringImageView] = [:]
    var fretButtonDict: [String: UIButton] = [:]
    var fretButtonFrame: [String: CGRect] = [:]
    var dotText: [UILabel] = []
    var periphButtonArr: [UIButton] = []

    // Timers
    var dotFadeTime: Timer?
    var userInputTime = CFAbsoluteTimeGetCurrent()
    var recordStartTime: CFAbsoluteTime = 0
    var recordStopTime: CFAbsoluteTime = 0
    var previousNote: String?

    // Runtime Variables

    // Objects
    let sc = SoundController(isubInstances: 10)
    let click = SoundController(isubInstances: 10)
    var met: Metronome?
    var sCollection: ScaleCollection?
    var et: EarTraining?
    var pc: PopupController?
    var styler: ViewStyler?
    let lc = LevelConstruct() // TODO: change name
    var settingsMenu = SettingsViewController()
    var wt = waitThen()
    var popover: Popover?
    var fretOffsetPickerPopover: FretOffsetPickerPopover?

    class InputData {
        var time: CFAbsoluteTime = 0
        var note = ""
        var timeDelta = 0.0
        var fretOffset = 5
    }

    var recordData: [InputData] = []
    var noteCollectionTestData: [InputData] = []
    var earTrainCallArr: [String] = []
    var earTrainResponseArr: [String] = []
    var defaultPeripheralIcon: [String] = []
    var activePeripheralIcon: [String] = []
    var tutorialPopupText: [String] = []
    var currentTutorialPopup = 0
    var developmentMode = 0

    var specifiedNoteCollection: [String] = []
    let tempScale: [String] = ["A1", "C2", "D2", "E2", "G2"]

    var defaultSoundFadeTime = 0.3

    var tutorialActive = false

    var tempoButtonsActive = false
    var tempoActive = false
    var tempoUpdaterCycle = 0.0
    var tapTime: [Double] = []
    var currentTapTempo = 0.0
    var tempoButtonArr: [UIButton]? = []

    var resultButtonText = ""
    var resultsLabelDefaultText = ""

    let testResultStrDict: [String: String] = [
        "incorrect_notes": "Notes Played Were Incorrect",
        "incorrect_time": "Time Was Inaccurate",
    ]
    
    var freePlayNoteCollection = ""
    var backgroundImage = 0
    var currentRecordingId = ""
    var prepareScene = ""
    var lastPickedFreePlayMenuIndex = 0

    var buttonDict: [Int: String] = [ // this could probably just be an array
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

    enum State: String {
        case Idle
//        case RecordingIdle
        case Recording
        case RecordingPlayback
        
        case EarTrainingIdle
        case EarTrainingCall
        case EarTrainingResponse
        
        case PlayingNotesCollection
        case NotesTestIdle_NoTempo
        case NotesTestActive_NoTempo
        case NotesTestCountIn_Tempo
        case NotesTestActive_Tempo
        case NotesTestIdle_Tempo
        case NotesTestShowNotes
        
        case PlaygroundIdle
        case PlaygroundShowNotes
        case PlaygroundPlayingNotesCollection
    }

    var currentState = State.Idle
    var allMarkersDisplayed = false
    var defaultState: State?
    
    //ear training vars
    var earTrainingIdx = 0
    var earTrainingLevelData : [String] = []
    var startingEarTrainingNote = ""
    
    var tutorialComplete: Bool?
    var currentButtonLayer = 0

    var sceneHasBeenSetup = false

    var guitarTone = ""
    var dotType = ""
    var clickTone = ""
    var fretOffset = 0
    var defaultFretOffset = 5
    var fretOffsetList: [String] = []
    
    
    

    var bgImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        
        
//        var alertViewResponder: SCLAlertViewResponder = SCLAlertView().showSuccess("Hello World", subTitle: "This is a more descriptive text.")
//
//            // Upon displaying, change/close view
//        alertViewResponder.setTitle("New Title") // Rename title
//        alertViewResponder.setSubTitle("New description") // Rename subtitle
        

        // initialize objects
        met = Metronome(ivc: self)
        sCollection = ScaleCollection(ivc: self)
        et = EarTraining(ivc: self)
        pc = PopupController(ivc: self)
        styler = ViewStyler(ivc: self)
        popover = Popover(ivc: self)
        popover?.setupPopover(navigationController!)
        
        fretOffsetPickerPopover = FretOffsetPickerPopover(ivc: self)
        fretOffsetPickerPopover?.setupPopover(navigationController!)
        
//        met!.deployInitialMet()
        
        if developmentMode > 1 {
            met?.bpm = 350.0
        }

        setupBackgroundImage()

        ResultsLabel.text = ""
        ResultsLabel.font = UIFont(name: "Helvetica", size: 35)
        ResultsLabel.textAlignment = NSTextAlignment.center
        ResultsLabel?.adjustsFontSizeToFitWidth = true
        ResultsLabel?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        ResultsLabel?.textColor = defaultColor.MenuButtonTextColor

        ResultButton.titleLabel?.adjustsFontSizeToFitWidth = true
        ResultButton.setTitleColor(.black, for: .normal)
        setResultButton()
        ResultButton.titleLabel?.adjustsFontSizeToFitWidth = true
        ResultButton.titleLabel?.minimumScaleFactor = 0.5
        ResultButton.backgroundColor = defaultColor.MenuButtonColor
        ResultButton.setTitleColor(.white, for: .normal)
        ResultButton.titleLabel?.font = UIFont(name: ResultsLabel.font.fontName, size: 20)
        ResultButton.layer.cornerRadius = 20
        giveButtonBackgroundShadow(ibutton: ResultButton)
       
        leftBarButtonItem?.isEnabled = false
        leftBarButtonItem?.tintColor = UIColor.clear

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

    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAlphaOnDefualtImages(0.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        met!.deployInitialMet()
        if !sceneHasBeenSetup {
            // Add overlays
            DimOverlay = setupScreenOverlay()
            DimOverlay.backgroundColor = UIColor.black
            view.addSubview(DimOverlay)
//            setLayer(iobject: DimOverlay, ilayer: "DimOverlay")
            DimOverlay.layer.zPosition = getLayer(ilayer: "DimOverlay")

            ActionOverlay = setupScreenOverlay()
            ActionOverlay.backgroundColor = UIColor.white
            view.addSubview(ActionOverlay)
//            setLayer(iobject: ActionOverlay, ilayer: "ActionOverlay")
            ActionOverlay.layer.zPosition = getLayer(ilayer: "ActionOverlay")

            setupFretBoardImage()
            setupFretMarkerText(ishowAlphabeticalNote: false, ishowNumericDegree: true)

            if !tutorialComplete! {
                hideAllFretMarkers()
                wt.waitThen(itime: 0.2, itarget: self, imethod: #selector(presentMainPopover) as Selector, irepeats: false, idict: ["arg1": "Tutorial" as AnyObject, "arg2": 0 as AnyObject])
                setupPopupTutorialText()
            }

            if developmentMode > 0 {
                let testButton = UIButton()
                let screenRect = UIScreen.main.bounds
                let screenWidth = screenRect.size.width
                let screenHeight = screenRect.size.height
                let height: CGFloat = screenHeight * 0.1
                testButton.frame = CGRect(x: FretboardImage.frame.maxX, y: screenHeight - height, width: screenWidth * 0.5, height: height)
//                testButton.backgroundColor = UIColor.red
                testButton.addTarget(self, action: #selector(onTestButtonDown), for: .touchDown)
                view.addSubview(testButton)
            }
        }
        
        setAlphaOnDefualtImages(1.0)
        setupToSpecificState()
        
        if (!lc.currentLevelKey!.contains("interval")) {
            let idx = lc.currentLevelKey!.contains("freePlay") ? 1 : 2
            currentState = State.NotesTestShowNotes
            setButtonImage(ibutton: periphButtonArr[idx], iimageStr: activePeripheralIcon[idx])
        }
        prepareScene = ""
        getDynamicAudioVisualData()
        pc!.resultButtonPopup.hide()
    }

    override func didMove(toParent _: UIViewController?) {
        if developmentMode > 0 { print("Back button pressed") }
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        UIView.setAnimationsEnabled(false)
        if let met = met {
            met.endMetronome()
        }
    }

    @objc func willEnterForeground() {
        navigationController?.popViewController(animated: false)
    }

    @objc func tempoButtonLongPressed(sender: UILongPressGestureRecognizer) {
        if developmentMode > 0 { print("tempoButtonLongPressed, state: \(currentState)") }
        if !checkForValidTempoInput() { return }
        if popover!.popoverVisible {return}
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
            if proposedNewBPM <= met!.minBPM {
                met!.bpm = met!.minBPM
            } else if proposedNewBPM >= met!.maxBPM {
                met!.bpm = met!.maxBPM
            } else {
                met!.bpm = proposedNewBPM
            }
            TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        }
    }

    func setStateProperties(icurrentLevel: String, ilevelConstruct: [[String]], ilevelKey: String, itutorialComplete: String = "1.0") {
        lc.setLevelVars(icurrentLevel: icurrentLevel, icurrentLevelConstruct: ilevelConstruct, icurrentLevelKey: ilevelKey)
        
        tutorialComplete = itutorialComplete == "1.0"
        if developmentMode > 0 {
            tutorialComplete = true
        }

        if developmentMode > 0 {
            print("icurrentLevel \(icurrentLevel)")
            print("ilevelConstruct \(ilevelConstruct)")
            print("ilevelKey \(ilevelKey)")
        }
    }

    func setupToSpecificState() {
//        if currentState == State.RecordingIdle {
//            setButtonState(ibutton: PeriphButton0, ibuttonState: false)
//        }

        // Scale/Arpeggio test
        if lc.currentLevelKey!.contains("scale") || lc.currentLevelKey!.contains("arpeggio") {
            setupCurrentTask()
            defaultPeripheralIcon = ["outline_play_arrow_black_18dp", "outline_volume_up_black_18dp", "outline_info_black_18dp"]
            activePeripheralIcon = ["outline_stop_black_18dp", "outline_volume_off_black_18dp", "outline_undo_black_18dp"]
            setupTempoButtons(ibuttonsActive: tempoButtonsActive)
            displayMultipleFretMarkers(iinputArr: specifiedNoteCollection, ialphaAmount: 1.0)
        } else if lc.currentLevelKey == "intervalLevel" {
            setupEarTrainingData()
            defaultPeripheralIcon = ["outline_play_arrow_black_18dp"]
            activePeripheralIcon = ["outline_stop_black_18dp"]
            setupCurrentTask()
            setupTempoButtons(ibuttonsActive: tempoButtonsActive)
        } else {
            defaultPeripheralIcon = ["outline_volume_up_black_18dp", "outline_info_black_18dp","icons8-microphone-50","outline_play_arrow_black_18dp"]
            activePeripheralIcon = ["outline_volume_off_black_18dp", "outline_undo_black_18dp","outline_stop_black_18dp","outline_stop_black_18dp"]
            setupCurrentTask()
            displayMultipleFretMarkers(iinputArr: specifiedNoteCollection, ialphaAmount: 1.0)
            leftBarButtonItem?.isEnabled = true
            leftBarButtonItem?.tintColor = defaultColor.MenuButtonTextColor
        }
        setupPeripheralButtons(iiconArr: defaultPeripheralIcon)
    }

    func setupCurrentTaskHelper() {
        setupCurrentTask(nil)
        wt.stopWaitThenOfType(iselector: #selector(setupCurrentTask) as Selector)
    }

    @objc func setupCurrentTask(_ timer: Timer? = nil) {
        var automaticallyStartTest = false
        if timer != nil {
            let resultObj = timer?.userInfo as! [String: AnyObject]
            if let start = resultObj["automaticallyStartTest"] {
               automaticallyStartTest = start as! Bool
            }
        }

        let task = lc.returnCurrentTask()
        let trimmedTask = trimCurrentTask(iinput: task)
        let dir = parseTaskDirection(iinput: task)
        var startingNote = "A"
        var type = "standard"
        var additionalData : [String:Any] = [:]  //this is a little hacky
        
        if (lc.currentLevelKey?.contains("interval"))! {
            
            let data = lc.parseEarTrainingData(task)
            startingNote = data["StartingNote"] as! String
            startingEarTrainingNote = startingNote
            let intervalsToTest = lc.parseIntervalDirection(data["Direction"] as! String)
            
            if earTrainingLevelData.count == 0 {
                print("updating earTrainingLevelData")
                earTrainingLevelData = lc.returnRandomizedArray(Int(data["Total"] as! String)!, intervalsToTest)
                automaticallyStartTest = false
            }
            
            additionalData["intervalsToTest"] = intervalsToTest
            type = "interval"
            
            currentState = State.EarTrainingIdle
            
            earTrainingIdx = lc.returnCurrentEarTrainingIndex()
            
            resultsLabelDefaultText = "Intervals \(earTrainingIdx+1)/\(earTrainingLevelData.count)"
            
            specifiedNoteCollection = sCollection!.setupSpecifiedNoteCollection(iinput: trimmedTask, idirection: dir, istartingNote: startingNote, itype: type, idata: additionalData)
            
            displayMultipleFretMarkers(iinputArr: specifiedNoteCollection, ialphaAmount: 0.5)
            setColorOnFretMarkers(specifiedNoteCollection, defaultColor.FretMarkerStandard)
            swoopAlpha(iobject: dotDict[specifiedNoteCollection[0]]!, ialpha: Float(1.0), iduration: 0.1)
            
            var testedIntervals: [String] = []
            for i in 0..<specifiedNoteCollection.count-1 {
                testedIntervals.append(
                    sCollection!.returnInterval(specifiedNoteCollection[0],specifiedNoteCollection[i+1])
                )
            }
            
            pc!.setResultButtonPopupText(itextArr: ["Intervals Tested:"] + testedIntervals)
            resultButtonText = "Click For Info  ⓘ"
            setResultButton(istr: resultButtonText)

            if automaticallyStartTest {
                PeripheralButton0OnButtonDown(0,true)
            }
        } else if lc.currentLevelKey!.contains("scale") || lc.currentLevelKey!.contains("arpeggio") {
            resultsLabelDefaultText = sCollection!.returnReadableScaleName(iinput: trimmedTask)
            tempoActive = parseTempoStatus(iinput: task)
            tempoButtonsActive = !tempoActive
            setupTempoButtons(ibuttonsActive: tempoButtonsActive)
            specifiedNoteCollection = sCollection!.setupSpecifiedNoteCollection(iinput: trimmedTask, idirection: dir, istartingNote: startingNote, itype: type, idata: additionalData)
            
            hideAllFretMarkers(true)
            
            //set State for scales / arpeggios
            if lc.currentLevelKey!.contains("scale") {
                if tempoActive {
                    currentState = State.NotesTestIdle_Tempo
                } else {
                    currentState = State.NotesTestIdle_NoTempo
                }
            } else if lc.currentLevelKey!.contains("arpeggio") {
                if tempoActive {
                    currentState = State.NotesTestIdle_Tempo
                } else {
                    currentState = State.NotesTestIdle_NoTempo
                }
            }
        } else {
            tempoActive = false
            tempoButtonsActive = !tempoActive
            
            var freePlayUserDefault = UserDefaults.standard.object(forKey: "freePlayNoteCollection")
            if freePlayUserDefault == nil {
                UserDefaults.standard.set("MinorPentatonic", forKey: "freePlayNoteCollection")
                freePlayUserDefault = "MinorPentatonic"
            }
            freePlayNoteCollection = freePlayUserDefault as! String
            resultsLabelDefaultText = sCollection?.returnReadableScaleName(iinput: freePlayNoteCollection) as! String
          
            if currentRecordingId == "" {
                let fetchRequest: NSFetchRequest<RecordingData> = RecordingData.fetchRequest()
                if let results = try? globalDataController.viewContext.fetch(fetchRequest) {
                    if results.count > 0 {
                        currentRecordingId = results[results.count-1].id!
                    }
                }
            }
            
            let availableTypes = [lc.scale,lc.arpeggio]
            var typeIdx = -1
            for (i,typesArr) in availableTypes.enumerated() {
                if typeIdx == -1 {
                    for typeArr in typesArr {
                        for type in typeArr {
                            if type.contains(freePlayNoteCollection) {
                                typeIdx = i
                                break
                            }
                        }
                    }
                }
            }
            let type = typeIdx == 0 ? "Scale: " : "Arpeggio: "
            
            pc!.setResultButtonPopupText(itextArr: ["Free Play!",type + resultsLabelDefaultText])
            resultButtonText = "Click For Info  ⓘ"
            setResultButton(istr: resultButtonText)
            
            specifiedNoteCollection = sCollection!.setupSpecifiedNoteCollection(iinput: freePlayNoteCollection, idirection: "Both", istartingNote: startingNote)
            setupTempoButtons(ibuttonsActive: tempoButtonsActive)
            currentState = State.NotesTestIdle_NoTempo
        }
        
//        sCollection!.setupSpecifiedNoteCollection(iinput: trimmedTask, idirection: dir, istartingNote: startingNote, itype: type, idata: additionalData)
                
        defaultState = currentState
        ResultsLabel.text = resultsLabelDefaultText

        //result button text for scales / arpeggios
        if lc.currentLevelKey?.contains("interval") == false && lc.currentLevelKey?.contains("freePlay") == false {
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
    }
    
    func setupEarTrainingData() {
        let task = lc.returnCurrentTask()
        let data = lc.parseEarTrainingData(task)
//        let intervalsToTest = lc.parseIntervalDirection(data["Direction"] as! String)
//        earTrainingLevelData = lc.returnRandomizedArray(Int(data["Total"] as! String)!, intervalsToTest)
        tempoActive = true
        tempoButtonsActive = !tempoActive
        met!.bpm = Double(Int(data["Tempo"] as! String)!)
        setupTempoButtons(ibuttonsActive: tempoButtonsActive)
    }

    func getDynamicAudioVisualData() {
        let dataStrTypes = [
            "guitarTone",
            "clickTone",
            "fretOffset",
            "fretDot",
        ]
        for dataStr in dataStrTypes {
            let data = UserDefaults.standard.object(forKey: dataStr)
            if data == nil {
                let defaultVal = [
                    "guitarTone": "Acoustic",
                    "clickTone": "Digital",
                    "fretOffset": "0",
                    "fretDot": "Scale Degree",
                ]
                UserDefaults.standard.set(defaultVal[dataStr], forKey: dataStr)
                setDynamicAudioVisualVars(iinputType: dataStr, iinput: defaultVal[dataStr]!)
            } else {
                setDynamicAudioVisualVars(iinputType: dataStr, iinput: data as! String)
            }
        }
    }

    func setDynamicAudioVisualVars(iinputType: String, iinput: String) {
        switch iinputType {
        case "guitarTone":
            guitarTone = iinput
        case "fretDot":
            dotType = iinput
            // TODO: potentially add fingering to this
            let alphaNote = dotType == "Note Name"
            let degree = dotType == "Scale Degree"
            setupFretMarkerText(ishowAlphabeticalNote: alphaNote, ishowNumericDegree: degree)
        case "fretOffset":
            fretOffset = Int(iinput)!
            FretRefText.text = returnCurrentFretText()
            setFretBoardImage()
        default:
            clickTone = iinput
        }
    }
    
    func setFretBoardImage() {
        let imageName = sCollection!.fretOffsetToImage[(defaultFretOffset-1)+fretOffset]
        let image: UIImage = UIImage(named: imageName)!
        FretboardImage.image = image
    }

    func setupBackgroundImage() {
//        bgImage = UIImageView()
//        let key = lc.currentLevelKey!.replacingOccurrences(of: "Level", with: "") + "s"
//        bgImage.image = backgroundImage.returnImage(key)
//        bgImage.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
//        bgImage.contentMode = UIView.ContentMode.scaleAspectFill
//        view.insertSubview(bgImage, at: 0)
        backgroundImage = Int.random(in: 0 ..< 4)
        styler!.setupBackgroundImage(ibackgroundPic: "MainImage\(backgroundImage).jpg")
    }

    func trimCurrentTask(iinput: String) -> String {
        let signifiers = ["Up", "Tempo", "Both"]
        var modifiedStr = iinput
        if modifiedStr.contains("_") {
            for (_, str) in signifiers.enumerated() {
                if modifiedStr.contains(str) {
                    modifiedStr = modifiedStr.replacingOccurrences(of: "_" + str, with: "")
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
        return iinput.contains("Tempo") && !(lc.currentLevelKey?.contains("interval"))!
    }

    func setupPeripheralButtons(iiconArr: [String]) {
        for (i, button) in periphButtonArr.enumerated() {
            if i < iiconArr.count {
                button.isEnabled = true
                button.alpha = 1.0
                periphButtonArr[i].setTitle("", for: .normal)
                // control button size
                let insets: CGFloat = 10
                periphButtonArr[i].imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
                setButtonImage(ibutton: periphButtonArr[i], iimageStr: iiconArr[i])
                periphButtonArr[i].imageView?.tintColor = defaultColor.AlternateButtonInlayColor
                periphButtonArr[i].layer.masksToBounds = true
                periphButtonArr[i].layer.cornerRadius = 25
                periphButtonArr[i].backgroundColor = defaultColor.MenuButtonColor
                periphButtonArr[i].imageView?.alpha = 1.0
                //            giveButtonBackgroundShadow(ibutton: periphButtonArr[i])  //TODO: why isnt this working?
            } else {
                //                button.isHidden = true
                button.isEnabled = false
                button.alpha = 0.0
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

        // control button size
        let insets: CGFloat = 10
        setButtonImage(ibutton: TempoDownButton, iimageStr: "outline_expand_more_black_18dp")
        TempoDownButton.contentVerticalAlignment = .fill
        TempoDownButton.contentHorizontalAlignment = .fill
        TempoDownButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        TempoDownButton.backgroundColor = buttonColor
        TempoDownButton.imageView?.tintColor = inlayColor
        TempoDownButton.imageView?.alpha = 0.2
        TempoDownButton.layer.masksToBounds = true
        TempoDownButton.layer.cornerRadius = 25
        TempoDownButton.imageView?.alpha = 1.0

        setButtonImage(ibutton: TempoUpButton, iimageStr: "outline_expand_less_black_18dp")
        TempoUpButton.contentVerticalAlignment = .fill
        TempoUpButton.contentHorizontalAlignment = .fill
        TempoUpButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        TempoUpButton.backgroundColor = buttonColor
        TempoUpButton.imageView?.tintColor = inlayColor
        TempoUpButton.layer.masksToBounds = true
        TempoUpButton.layer.cornerRadius = 25
        TempoUpButton.imageView?.alpha = 1.0
        
        setButtonImage(ibutton: FretOffsetButton, iimageStr: "icons8-music-notation-50")
        FretOffsetButton.contentVerticalAlignment = .fill
        FretOffsetButton.contentHorizontalAlignment = .fill
        FretOffsetButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        FretOffsetButton.backgroundColor = defaultColor.MenuButtonColor
        FretOffsetButton.imageView?.tintColor = defaultColor.MenuButtonTextColor
        FretOffsetButton.layer.masksToBounds = true
        FretOffsetButton.layer.cornerRadius = 25
        FretOffsetButton.imageView?.alpha = 1.0
    }

    func setupFretMarkerText(ishowAlphabeticalNote: Bool, ishowNumericDegree: Bool, inumericDefaults: [String] = ["b5", "b6"]) {
        for (idx, _) in buttonDict {
            var str = buttonDict[idx]
            var note = ""
            if ishowAlphabeticalNote {
//
                note = sCollection?.returnOffsetFretNote(str!, fretOffset) as! String
                note = note.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789_"))
                if sCollection?.fretPositionAccidentalInheritence[5+fretOffset] == ScaleCollection.PositionType.Flat {
                    note = sCollection?.flatEquivalent[note] as! String
                }
            } else if ishowNumericDegree {
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
        let image = UIImage(named: iimageStr)!
        ibutton.setImage(image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        ibutton.imageView?.tintColor = defaultColor.MenuButtonTextColor
        ibutton.imageView?.alpha = 1.0
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
                    print(timeDelta)
                }
                noteCollectionTestData[noteCollectionTestData.count - 1].time = userInputTime
                noteCollectionTestData[noteCollectionTestData.count - 1].timeDelta = timeDelta
            }
        }
    }

    func checkForValidTempoInput() -> Bool {
        if !tempoButtonsActive { return false }
        return !returnValidState(iinputState: currentState, istateArr: [State.NotesTestActive_NoTempo, State.PlayingNotesCollection])
    }

    @IBAction func scrollTempo(_ sender: UIButton) {
        if developmentMode > 0 { print("scroll tempo, state: \(currentState)") }
        if !checkForValidTempoInput() { return }
        if popover!.popoverVisible || tutorialActive {return}
        pc!.resultButtonPopup.hide()
        let dir = sender.tag == 0 ? 1.0 : -1.0
        if met!.bpm + dir >= met!.minBPM, met!.bpm + dir <= met!.maxBPM {
            met!.bpm = met!.bpm + dir
            currentButtonLayer = tempoButtonArr![sender.tag].pulsate(ilayer: currentButtonLayer)
        }
        TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        tapTime.removeAll()
    }

    @IBAction func tempoTapped(_: Any) {
        if developmentMode > 0 { print("tempoTapped, state: \(currentState)") }
        if !checkForValidTempoInput() { return }
        if popover!.popoverVisible || tutorialActive {return}
        currentButtonLayer = TempoButton!.pulsate(ilayer: currentButtonLayer)
        wt.stopWaitThenOfType(iselector: #selector(timeoutTapTempo) as Selector)
        // this caps the low tempo at 40 bpm
        wt.waitThen(itime: 60.0 / 40.0, itarget: self, imethod: #selector(timeoutTapTempo) as Selector, irepeats: false, idict: ["arg1": 0 as AnyObject])
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
            // cap tapped tempo
            if met!.bpm > 350.0 { met!.bpm = 350.0 }
            TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        }
    }

    @objc func timeoutTapTempo() {
        tapTime.removeAll()
    }

    @IBAction func startMetronome(_: Any) {
        met?.startMetro()
    }
    
    @IBAction func handleFretOffsetButtonDown(_ sender: Any) {
        if popover!.popoverVisible || tutorialActive {return}
        if returnValidState(iinputState: currentState, istateArr: [
            State.NotesTestIdle_NoTempo,
            State.NotesTestShowNotes,
            State.NotesTestIdle_Tempo,
            State.NotesTestShowNotes,
            State.EarTrainingIdle,
            State.PlaygroundIdle,
            State.PlaygroundShowNotes
        ]) {
            fretOffsetPickerPopover?.addToView()
            popover?.popoverVisible = true
            for button in fretButtonDict {
                button.value.isEnabled = false
            }
            resetSideButtonLayers()
        }
    }
    
    func handleTutorialInput(iwchButton: Int) -> Bool {
        if popover!.popoverVisible {
            return false
        }

        if tutorialActive, currentTutorialPopup == iwchButton + 1 {
            progressTutorial()
            return false
        }
//        return true
        return !tutorialActive
    }
    
    @IBAction func FreePlayChooseNoteCollection(_ sender: Any) {
        if returnValidState(iinputState: currentState, istateArr: [
            State.NotesTestShowNotes,
            State.NotesTestIdle_NoTempo,
        ]) {
            UIView.setAnimationsEnabled(false)
            prepareScene = "freePlay"
            performSegue(withIdentifier: "NoteCollectionPicker", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if prepareScene == "freePlay" {
            let barViewControllers = segue.destination as! UITabBarController
            for i in 0..<3 {
                let destinationViewController = barViewControllers.viewControllers?[i] as! NoteCollectionPickerViewController
                destinationViewController.vc = self
            }
            barViewControllers.selectedIndex = lastPickedFreePlayMenuIndex
        }
//        destinationViewController.backgroundImageID = 1
    }

    @IBAction func PeripheralButtonDown(_ sender: UIButton) {
        pc!.resultButtonPopup.hide()
        if popover!.popoverVisible {return}
        if !tutorialActive {currentButtonLayer = periphButtonArr[sender.tag].pulsate(ilayer: currentButtonLayer)}
        if !returnValidState(iinputState: currentState, istateArr: [
            State.NotesTestCountIn_Tempo,
        ]) {
            ResultsLabel.text = resultsLabelDefaultText
        }
        UIView.setAnimationsEnabled(true)
        if developmentMode > 0 { print("PeripheralButtonButtonDown \(currentState)") }
        
        if !(lc.currentLevelKey?.contains("freePlay"))! {
            switch sender.tag {
            case 0:
                PeripheralButton0OnButtonDown(sender.tag)
            case 1:
                PeripheralButton1OnButtonDown(sender.tag)
            case 2:
                PeripheralButton2OnButtonDown(sender.tag)
            case 3:
                //            PeripheralButton3OnButtonDown()
                break
            default:
                break
            }
        } else {
            switch sender.tag {
            case 0:
                PeripheralButton1OnButtonDown(0)
            case 1:
                PeripheralButton2OnButtonDown(1)
            case 2:
                PeripheralButton2OnButtonDown(sender.tag)
            case 3:
                PeripheralButton3OnButtonDown(sender.tag)
                break
            default:
                break
            }
        }

    }

    // Peripheral Buttons Down
    @IBAction func PeripheralButton0OnButtonDown(_ iwchButton: Int,_ automaticallyStartTest: Bool = false) {
        if !handleTutorialInput(iwchButton: iwchButton) {
            return
        }

//        let s = #selector(pc!.enactTestReminder) as Selector
        wt.stopWaitThenOfType(iselector: #selector(pc!.enactTestReminder) as Selector)
        pc!.reminderPopup.hide()

        // Scale Test States - enable test
        if returnValidState(iinputState: currentState,
                            istateArr: [
                                State.NotesTestIdle_NoTempo,
                                State.NotesTestShowNotes,
                                State.NotesTestIdle_Tempo,
                                State.NotesTestShowNotes,
                            ]) {
            setupCurrentTaskHelper()
            currentState = toggleTestState(icurrentState: defaultState!)
            setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: activePeripheralIcon[iwchButton])
            hideAllFretMarkers()
            setNavBarColor(istate: "Testing")
            noteCollectionTestData.removeAll()
            scaleButtonForClickableEase(ibutton: fretButtonDict[specifiedNoteCollection[0]]!)
            setResultButton(istr: resultButtonText)
            wt.stopWaitThenOfType(iselector: #selector(setResultButtonHelper) as Selector)
            if currentState == State.NotesTestActive_Tempo {
                currentState = State.NotesTestCountIn_Tempo
                met?.startMetro()
            }
            return
        }
        // Scale Test States - disable test
        else if returnValidState(iinputState: currentState,
                                   istateArr: [
                                       State.NotesTestActive_NoTempo,
                                       State.NotesTestActive_Tempo,
                                       State.NotesTestCountIn_Tempo,
                                   ]) {
            setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: defaultPeripheralIcon[iwchButton])
            currentState = toggleTestState(icurrentState: currentState)
            met!.endMetronome()
            setResultButton(istr: resultButtonText)
            ResultsLabel.text = resultsLabelDefaultText
            wt.stopWaitThenOfType(iselector: #selector(setResultButtonHelper) as Selector)
            setNavBarColor()
            resetButtonFrames()
            return
        }
        // Ear Training - enable test
        else if returnValidState(iinputState: currentState, istateArr: [State.EarTrainingIdle]) {
            
            if !automaticallyStartTest {
                setupCurrentTaskHelper()
            }//
            wt.stopWaitThenOfType(iselector: #selector(setResultButtonHelper) as Selector)
            wt.stopWaitThenOfType(iselector: #selector(setupCurrentTask) as Selector)
            currentState = toggleTestState(icurrentState: currentState)
            setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: activePeripheralIcon[iwchButton])
            hideAllFretMarkers()
            setNavBarColor(istate: "Testing")
            et!.earTrainingSetup(earTrainingLevelData[earTrainingIdx])
            return
        }
        // Ear Training - disable test
        else if returnValidState(iinputState: currentState, istateArr: [State.EarTrainingCall,State.EarTrainingResponse]) {
            wt.stopWaitThenOfType(iselector: #selector(et!.beginEarTrainingHelper) as Selector)
            currentState = State.EarTrainingIdle
            setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: defaultPeripheralIcon[iwchButton])
            met!.endMetronome()
            setNavBarColor()
            earTrainingLevelData = randomizeEarTrainingData()
            setupCurrentTask()
        }
    }

    @IBAction func PeripheralButton1OnButtonDown(_ iwchButton: Int) {
        if !handleTutorialInput(iwchButton: iwchButton) {
            return
        }

        // Notes Test States
        if returnValidState(iinputState: currentState,
                            istateArr: [
                                State.NotesTestIdle_NoTempo,
                                State.NotesTestIdle_Tempo,
                                State.NotesTestShowNotes,
                            ]) {
            setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: activePeripheralIcon[iwchButton])
            setupCurrentTaskHelper()
            currentState = State.PlayingNotesCollection
            met?.startMetro()
            hideAllFretMarkers()
            return
        } else if returnValidState(iinputState: currentState,
                                   istateArr: [
                                       State.PlayingNotesCollection,
                                   ]) {
            setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: defaultPeripheralIcon[iwchButton])
            currentState = State.NotesTestIdle_NoTempo
            met?.endMetronome()
            return
        }
    }

    @IBAction func PeripheralButton2OnButtonDown(_ iwchButton: Int) {
        if !handleTutorialInput(iwchButton: iwchButton) {
            return
        }

        //Recording State
        if (lc.currentLevelKey?.contains("freePlay"))! && iwchButton != 1 {
            if returnValidState(iinputState: currentState, istateArr: [
                State.NotesTestShowNotes,
                State.NotesTestIdle_NoTempo,
            ]) {
                setupCurrentTaskHelper()
                setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: activePeripheralIcon[iwchButton])
                currentState = State.Recording
                setNavBarColor(istate: "Recording")
                recordStartTime = 0;
                recordData.removeAll()
                hideAllFretMarkers()
                return
            } else if returnValidState(iinputState: currentState, istateArr: [
                State.Recording,
            ]) {
                setupCurrentTaskHelper()
                setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: defaultPeripheralIcon[iwchButton])
                currentState = State.NotesTestIdle_NoTempo
                setNavBarColor()
                if recordData.count > 0 {
                    saveRecording()
                    playRecording()
                    setButtonImage(ibutton: periphButtonArr[3], iimageStr: activePeripheralIcon[3])
                }
                return
            }
        }
        
        // Scale/Arpeggio Test States
        if returnValidState(iinputState: currentState, istateArr: [
            State.NotesTestIdle_NoTempo,
            State.NotesTestIdle_Tempo,
        ]) {
            setupCurrentTaskHelper()
            currentState = State.NotesTestShowNotes
            setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: activePeripheralIcon[iwchButton])
            displayMultipleFretMarkers(iinputArr: specifiedNoteCollection, ialphaAmount: 1.0)
            return
        } else if currentState == State.NotesTestShowNotes {
            hideAllFretMarkers()
            currentState = defaultState!
            return
        }
    }

    @IBAction func PeripheralButton3OnButtonDown(_ iwchButton: Int) {

//        if recordData.count == 0 {return}

        if (lc.currentLevelKey?.contains("freePlay"))! && currentRecordingId != "" {
            //Recording State
            if returnValidState(iinputState: currentState, istateArr: [
                State.NotesTestShowNotes,
                State.NotesTestIdle_NoTempo,
            ]) {
                setupCurrentTaskHelper()
                hideAllFretMarkers()
                currentState = State.RecordingPlayback
                setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: activePeripheralIcon[iwchButton])
                playRecording()
                return
            } else if returnValidState(iinputState: currentState, istateArr: [
                State.RecordingPlayback,
            ]) {
                setupCurrentTaskHelper()
                setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: defaultPeripheralIcon[iwchButton])
                currentState = State.NotesTestIdle_NoTempo
                setNavBarColor()
                setButtonImage(ibutton: periphButtonArr[iwchButton], iimageStr: defaultPeripheralIcon[iwchButton])
                wt.stopWaitThenOfType(iselector: #selector(playSoundHelper) as Selector)
                return
            }
        }
    }
    
    @IBAction func ResultButtonDown(_: Any) {
        if developmentMode > 0 { print("currentState \(currentState)") }
        if popover!.popoverVisible {return}
        pc!.showResultButtonPopup()
    }

    @IBAction func onSettingsButtonDown(_: Any) {
        if (lc.currentLevelKey?.contains("freePlay"))! {
            if !returnValidState(iinputState: currentState, istateArr: [
                State.NotesTestShowNotes,
                State.NotesTestIdle_NoTempo,
            ]) {
                return
            }
        }
        met!.endMetronome()
        setNavBarColor()
        wt.stopWaitThenOfType(iselector: #selector(et!.beginEarTrainingHelper) as Selector)
        UIView.setAnimationsEnabled(false)
        performSegue(withIdentifier: "SettingsView", sender: nil)
    }

    func setNavBarColor(istate: String = "Idle") {
        let color = istate == "Idle" ? defaultColor.MenuButtonColor : UIColor.red
        navigationController?.navigationBar.barTintColor = color
    }

    @IBAction func FretPressed(_ sender: UIButton) {
        pc!.resultButtonPopup.hide()
        var tutorialDisplayed = false
        var inputNumb = sender.tag
        if inputNumb >= 100 {
            inputNumb -= 100
            tutorialDisplayed = true
        }

        if tutorialActive || popover!.popoverVisible {
            if currentTutorialPopup < 4, !tutorialDisplayed {
                return
            } else if !tutorialDisplayed {
                if buttonDict[inputNumb] != specifiedNoteCollection[currentTutorialPopup - (defaultPeripheralIcon.count + 1)] {
                    return
                }
                progressTutorial()
            }
        }
        
        if popover!.popoverVisible {return}
        
        if developmentMode > 0 { print("in fret pressed state \(currentState)") }

        let validState = returnValidState(iinputState: currentState, istateArr: [
            State.Recording,
            State.Idle,
            State.NotesTestActive_NoTempo,
            State.NotesTestIdle_NoTempo,
            State.NotesTestIdle_Tempo,
            State.NotesTestCountIn_Tempo,
            State.NotesTestActive_Tempo,
            State.NotesTestShowNotes,
            State.NotesTestActive_Tempo,
            State.EarTrainingResponse,
            State.EarTrainingIdle,
        ])
        if validState {
            var str = buttonDict[inputNumb]!
//            str = str.replacingOccurrences(of: "_0", with: "").replacingOccurrences(of: "_1", with: "")
            str = sCollection?.returnOffsetFretNote(str,fretOffset) as! String
            sc.playSound(isoundName: str + "_" + guitarTone, ivolume: volume.volumeTypes["masterVol"]! * volume.volumeTypes["guitarVol"]!, ioneShot: !tutorialActive, ifadeAllOtherSoundsDuration: defaultSoundFadeTime)

            displaySingleFretMarker(iinputStr: buttonDict[inputNumb]!, cascadeFretMarkers: tutorialActive)
            
            if currentState != State.EarTrainingIdle {
                hideAllFretMarkers()
                if !tutorialDisplayed {
                    displaySingleFretMarker(iinputStr: buttonDict[inputNumb]!, cascadeFretMarkers: tutorialActive)
                }
            } else {
                for note in specifiedNoteCollection {
                    if str == note {
                        killCurrentDotFade()
                        let alpha = str as AnyObject === String(startingEarTrainingNote) as AnyObject ? 1.0 : 0.5
                        dotFadeTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alphaSwoopImage), userInfo: ["ImageId": str, "Alpha": alpha], repeats: false)
                        previousNote = nil
                        break
                    }
                }
                for (i,otherNotes) in specifiedNoteCollection.enumerated() {
                    if otherNotes != str {
                        dotDict[otherNotes]!.alpha = i == 0 ? 1.0 : 0.5
                    }
                }
            }
            
            if currentState == State.NotesTestShowNotes {
                currentState = State.NotesTestIdle_NoTempo
            }
            
            if currentState == State.Recording {
                let r = InputData()
                r.time = CFAbsoluteTimeGetCurrent()
                r.note = buttonDict[inputNumb]!
                if recordStartTime == 0 {
                    recordStartTime = CFAbsoluteTimeGetCurrent()
//                    r.fretOffset = fretOffset  //dont need this
                }
                recordData.append(r)
            } else if currentState == State.EarTrainingResponse {
                earTrainResponseArr.append(buttonDict[inputNumb]!)
                if earTrainResponseArr.count == earTrainCallArr.count {
                    et!.presentEarTrainResults()
                }
            }

            // TODO: overlapping function invocations taking place below
            if currentState == State.NotesTestActive_Tempo, noteCollectionTestData.count < specifiedNoteCollection.count {
                let st = InputData()
                st.note = buttonDict[inputNumb]!
                st.time = 0
                noteCollectionTestData.append(st)
                recordTimeAccuracy()
            }

            if currentState == State.NotesTestActive_NoTempo, noteCollectionTestData.count < specifiedNoteCollection.count {
                let st = InputData()
                st.note = buttonDict[inputNumb]!
                st.time = 0
                noteCollectionTestData.append(st)

                var noteMismatch = false
                if st.note != specifiedNoteCollection[noteCollectionTestData.count - 1] {
                    noteMismatch = true
                    flashActionOverlay(isuccess: false)
                    resetButtonFrames()
                }
                if noteCollectionTestData.count == specifiedNoteCollection.count || developmentMode > 1 || noteMismatch {
                    let notesCorrect = sCollection!.analyzeNotes(iscaleTestData: noteCollectionTestData)
                    onTestComplete(itestPassed: notesCorrect)
                    var testResultStrs: [String] = []
                    if !notesCorrect {
                        testResultStrs.append(testResultStrDict["incorrect_notes"]!)
                    } else {
                        killCurrentDotFade()
                        setupUpDelayedNoteCollectionView(specifiedNoteCollection.uniques,"postSuccess");
                    }
                    wt.waitThen(itime: 0.5, itarget: self, imethod: #selector(presentTestResult) as Selector, irepeats: false, idict: ["notesCorrect": notesCorrect as AnyObject, "testResultStrs": testResultStrs as AnyObject])
                } else {
                    scaleButtonForClickableEase(ibutton: fretButtonDict[specifiedNoteCollection[noteCollectionTestData.count]]!)
                }
            }
        }
    }

    func onTestComplete(itestPassed: Bool, iflashRed: Bool = false) {
        setPeriphButtonsToDefault(idefaultIcons: defaultPeripheralIcon)
        setNavBarColor()
        resetButtonFrames()
        ResultButton.isEnabled = false
        if itestPassed {
            flashActionOverlay(isuccess: true)
            //            Vibration.success.vibrate()
        } else if iflashRed {
            flashActionOverlay(isuccess: false)
        }
    }

    func toggleTestState(icurrentState: State) -> State {
        let currentStateStr = icurrentState.rawValue
        if developmentMode > 0 { print("toggle state in \(currentStateStr)") }
        var newState: State
        if (currentStateStr.contains("EarTraining")) {
            newState = currentStateStr.contains("Idle") ? State.EarTrainingCall : State.EarTrainingResponse
        } else {
            if currentStateStr.contains("Active") || currentStateStr.contains("CountIn") {
                newState = currentStateStr.contains("_NoTempo") ? State.NotesTestIdle_NoTempo : State.NotesTestIdle_Tempo
            } else {
                newState = currentStateStr.contains("_NoTempo") ? State.NotesTestActive_NoTempo : State.NotesTestActive_Tempo
            }
            if currentStateStr.contains("Active") || currentStateStr.contains("CountIn") {
                newState = currentStateStr.contains("_NoTempo") ? State.NotesTestIdle_NoTempo : State.NotesTestIdle_Tempo
            } else {
                newState = currentStateStr.contains("_NoTempo") ? State.NotesTestActive_NoTempo : State.NotesTestActive_Tempo
            }
        }
        if developmentMode > 0 { print("toggle state out \(newState)") }
        return newState
    }

    func scaleButtonForClickableEase(ibutton: UIButton) {
        resetButtonFrames()
        let enlargementFactor: CGFloat = 1.5
        let buttonFrame = ibutton.frame
        ibutton.layer.zPosition = 1000 // for dev purposes
        view.bringSubviewToFront(ibutton) // this will cause issues with the complete button
        ibutton.frame =
            CGRect(
                x: buttonFrame.minX - (buttonFrame.width * enlargementFactor) / 2 + buttonFrame.width / 2,
                y: buttonFrame.minY - (buttonFrame.height * enlargementFactor) / 2 + buttonFrame.height / 2,
                width: buttonFrame.width * enlargementFactor,
                height: buttonFrame.height * enlargementFactor
            )
    }

    func resetButtonFrames() {
        for (str, fretButton) in fretButtonDict {
            fretButton.frame = fretButtonFrame[str]!
        }
    }

    @objc func presentTestResult(timer: Timer) {
        ResultButton.isEnabled = true
        var testPassed = false
        let resultObj = timer.userInfo as! [String: AnyObject]
        if let test = resultObj["notesCorrect"] {
            testPassed = test as! Bool
        } else {}

        let resultsText = testPassed ? "Great!" : "Try Again!  ⓘ"
        setResultButton(istr: resultsText)
        let newLevel = lc.analyzeNewLevel(itestPassed: testPassed, idevelopmentMode: developmentMode)
        if !newLevel["SubLevelIncremented"]! {
            if let testResultStrs = resultObj["testResultStrs"] {
                pc!.setResultButtonPopupText(itextArr: testResultStrs as! [String])
            }

        } else {
            if newLevel["LevelIncremented"]! {
                let level = lc.returnConvertedLevel(iinput: lc.currentLevel!)
                wt.waitThen(itime: 0.1, itarget: self, imethod: #selector(presentMainPopover) as Selector, irepeats: false, idict: ["arg1": "LevelComplete" as AnyObject, "arg2": level as AnyObject])
            }
            if newLevel["SubLevelMaxReached"]! {
                earTrainingLevelData = []
            }
            wt.waitThen(itime: 2, itarget: self, imethod: #selector(setupCurrentTask) as Selector, irepeats: false, idict: ["automaticallyStartTest": (earTrainingLevelData != []) as AnyObject])
        }
        currentState = toggleTestState(icurrentState: currentState)
    }
    
    @objc func presentEarTrainingFretMarkers(timer: Timer) {
        var testPassed = false
        let resultObj = timer.userInfo as! [String: AnyObject]
        if let test = resultObj["notesCorrect"] {
            testPassed = test as! Bool
            if !testPassed {
                displayMultipleFretMarkers(iinputArr: earTrainResponseArr, ialphaAmount: 0.5)
                setColorOnFretMarkers(earTrainResponseArr, defaultColor.FretMarkerStandard)
                
                //if wrong answer, mix up available test objects
                earTrainingLevelData = randomizeEarTrainingData()
            }
            displayMultipleFretMarkers(iinputArr: earTrainCallArr, ialphaAmount: 1, ikillAllFretMarkers: false)
            setColorOnFretMarkers(earTrainCallArr, defaultColor.FretMarkerSuccess)
            currentState = State.EarTrainingIdle
        }
    }
    
    func randomizeEarTrainingData() -> [String] {
        let data = lc.parseEarTrainingData(lc.returnCurrentTask())
        return lc.returnRandomizedArray(Int(data["Total"] as! String)!, lc.parseIntervalDirection(data["Direction"] as! String))
    }

    // State Handlers
    func setState(newState: State) {
        if developmentMode > 0 { print("setting \(newState)") }
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
        let objDict = timer.userInfo as! [String: AnyObject]
        let str = sCollection?.returnOffsetFretNote(objDict["Note"] as! String,fretOffset) as! String
        sc.playSound(isoundName: str + "_" + guitarTone, ivolume: volume.volumeTypes["masterVol"]! * volume.volumeTypes["guitarVol"]!)
        displaySingleFretMarker(iinputStr: objDict["Note"] as! String)
        if objDict["LastNote"] as! Bool && currentState == State.RecordingPlayback {
            currentState = State.NotesTestIdle_NoTempo
            setButtonImage(ibutton: periphButtonArr[3], iimageStr: defaultPeripheralIcon[3])
        }
    }

    func killCurrentDotFade() {
        if dotFadeTime != nil {
            dotFadeTime?.invalidate()
            dotFadeTime = nil
        }
    }

    func displayMultipleFretMarkers(iinputArr: [String], ialphaAmount: Float, ikillAllFretMarkers: Bool = true) {
        killCurrentDotFade()
        for (str, _) in dotDict {
            if ikillAllFretMarkers {
                dotDict[str]!.alpha = 0.0
            }
            if iinputArr.contains(str) {
                swoopAlpha(iobject: dotDict[str]!, ialpha: Float(ialphaAmount), iduration: 0.1)
                swoopScale(iobject: dotDict[str]!, iscaleX: 0, iscaleY: 0, iduration: 0)
                swoopScale(iobject: dotDict[str]!, iscaleX: 1, iscaleY: 1, iduration: 0.1)
            }
        }
        allMarkersDisplayed = true
    }

    func hideAllFretMarkers(_ overrideAllMarkersFlag: Bool = false) {
        if allMarkersDisplayed || overrideAllMarkersFlag {
            killCurrentDotFade()
            
            let idx = lc.currentLevelKey!.contains("freePlay") ? 1 : 2
            if defaultPeripheralIcon.indices.contains(idx) {
                setButtonImage(ibutton: periphButtonArr[idx], iimageStr: defaultPeripheralIcon[idx])
            }
            
            for (str, _) in dotDict {
                dotDict[str]!.alpha = 0.0
            }
            allMarkersDisplayed = false
        }
    }

    func displaySingleFretMarker(iinputStr: String, cascadeFretMarkers: Bool = false, fretAnim: String = "userFretPress") {
        if previousNote != nil, !cascadeFretMarkers {
            dotDict[previousNote!]?.alpha = 0.0
            swoopAlpha(iobject: dotDict[previousNote!]!, ialpha: Float(0.0), iduration: 0.3)
        }
        previousNote = iinputStr
        
//        dotDict[iinputStr]!.alpha = 0.0
//        swoopAlpha(iobject: dotDict[iinputStr]!, ialpha: Float(1.0), iduration: 0.1)
        killCurrentDotFade()
//        swoopScale(iobject: dotDict[iinputStr]!, iscaleX: 0, iscaleY: 0, iduration: 0)
//        swoopScale(iobject: dotDict[iinputStr]!, iscaleX: 1, iscaleY: 1, iduration: 0.1)
        dotDict[iinputStr]!.setAndPlayAnim(fretAnim)

        if !cascadeFretMarkers {
            dotFadeTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alphaSwoopImage), userInfo: ["ImageId": iinputStr], repeats: false)
        }
    }
    
    func setColorOnFretMarkers(_ inoteSelection: [String], _ icolor: UIColor) {
        for (_, item) in inoteSelection.enumerated() {
            dotDict[item]?.backgroundColor = icolor
        }
    }

//    func displaySelectionDots(inoteSelection: [String], ialphaAmount: Double) {
//        return
//        for (_, item) in inoteSelection.enumerated() {
//            dotDict[item]?.alpha = CGFloat(ialphaAmount)
//        }
//    }
    
//    func stripNoteQualifier(_ iinput: String) -> String {
//        return iinput.replacingOccurrences(of: "_0", with: "").replacingOccurrences(of: "_1", with: "")
//    }
//
//    func returnOffsetFretNote(_ iinput: String) -> String {
//        if fretOffset == 0 {
//            return iinput
//        }
//        var octave = sCollection?.parseNoteOctave(stripNoteQualifier(iinput))
//        let convertedNote = sCollection?.parseCoreNote(stripNoteQualifier(iinput))
//        var idx = sCollection?.refScale.firstIndex(of: convertedNote!)
//        let qualifier = iinput.contains("_") ? iinput.contains("0") ? "_0" : "_1" : ""
//        idx = (idx! + fretOffset)
//        if idx! < 0 {
//            idx = sCollection!.refScale.count + idx!
//            octave! -= 1
//        } else if idx! > sCollection!.refScale.count {
//            idx = idx!%sCollection!.refScale.count
//            octave! += 1
//        }
//
//        if let octave = octave {
//            return "\(sCollection!.refScale[idx!])\(octave)\(qualifier)"
//        }
//
//        return "A1"
//    }
    
    func handleFretOffsetChange() {
        setDynamicAudioVisualVars(iinputType: "fretDot", iinput: dotType)
        UserDefaults.standard.set(String(fretOffset), forKey: "fretOffset")
        FretRefText.text = returnCurrentFretText()
        popover?.popoverVisible = false
        setFretBoardImage()
        for button in fretButtonDict {
            button.value.isEnabled = true
        }
    }

    func setResultButton(istr: String? = "") {
        let str = istr == nil ? "" : istr
        ResultButton.setTitle(str, for: .normal)
    }

    @objc func setResultButtonHelper(timer: Timer) {
        let argDict = timer.userInfo as! [String: AnyObject]
        setResultButton(istr: argDict["arg1"] as? String)
    }

    @IBAction func closeMainPopover(_: Any) {
//        mainPopover.removeFromSuperview()
        popover?.removeFromView()
        if tutorialActive {
            progressTutorial()
        } else if popover?.mainPopoverState == "TutorialComplete" {
            allMarkersDisplayed = true
            swoopAlpha(iobject: DimOverlay, ialpha: 0, iduration: 0.3)
            pc!.startTestReminder(itime: 1)
            var tutorialComplete = UserDefaults.standard.object(forKey: "tutorialComplete")
            tutorialComplete = tutorialComplete as! String == "0.0" ? "1.0" : "2.0"
            UserDefaults.standard.set(tutorialComplete, forKey: "tutorialComplete")
            UserDefaults.standard.set("1.0", forKey: "scaleLevel")
        } else if popover?.mainPopoverState == "LevelComplete" {
            swoopAlpha(iobject: DimOverlay, ialpha: 0, iduration: 0.3)
            setupCurrentTaskHelper()
        }
        popover?.popoverVisible = false
    }

    func flashActionOverlay(isuccess: Bool) {
        if #available(iOS 13.0, *) {}
        else {
            self.view.bringSubviewToFront(ActionOverlay)
        }
        
        if isuccess {
            ActionOverlay.backgroundColor! = UIColor.white
        } else {
            ActionOverlay.backgroundColor! = UIColor.red
        }
        swoopAlpha(iobject: ActionOverlay, ialpha: 0.5, iduration: 0.0)
        swoopAlpha(iobject: ActionOverlay, ialpha: 0.0, iduration: 0.35)
    }

    @objc func presentMainPopover(timer: Timer) {
        let resultObj = timer.userInfo as! [String: AnyObject]
        let type = resultObj["arg1"] as! String
        let levelPassed = resultObj["arg2"] as! Int
        popover?.mainPopoverState = type
        // https://www.youtube.com/watch?v=qS21yjo822Y
        
        if type == "Tutorial" {
            pc!.tutorialPopup.hide()
            tutorialActive = true
            setButtonImage(ibutton: periphButtonArr[2], iimageStr: defaultPeripheralIcon[2])
            popover?.setupPopoverText(isubtitle: "Welcome To Fret Master™!", isubText: ["✅ Learn and sharpen valuable skills!", "🎸 Level up to become a great guitarist!","👍 Let get started with a simple tutorial!"])
        } else if type == "LevelComplete" {
            let key = (lc.currentLevelKey?.replacingOccurrences(of: "Level", with: ""))! + "s" //this is a bit hacky!!
            let nextLevelContents = lc.currentLevelName[key]![lc.returnConvertedLevel(iinput: lc.currentLevel!)]            
            popover?.setupPopoverText(isubtitle: "Level Complete!", isubText: ["✅ Level \(levelPassed) Passed!", "🎸 Level \(levelPassed+1) is Next!","🎵 \(nextLevelContents)"])
        } else if type == "TutorialComplete" {
            tutorialActive = false
            popover?.setupPopoverText(isubtitle: "Tutorial Complete!", isubText: ["✅ Complete levels to advance", "🕹 Levels will increase in difficulty!","🎵 Let's try Minor Pentatonic by yourself!"])
            pc!.tutorialPopup.hide()
        }
        
        popover?.addToView()
        
        
        swoopAlpha(iobject: DimOverlay, ialpha: 0.8, iduration: 0.3)

        // reset tempo/peripheral button layer orders
        resetSideButtonLayers()
//        for button in tempoButtonArr! {
//            button.layer.zPosition = getLayer(ilayer: "Default")
//        }
//        for button in periphButtonArr {
//            button.layer.zPosition = getLayer(ilayer: "Default")
//        }
    }
    
    func resetSideButtonLayers() {
        for button in tempoButtonArr! {
            button.layer.zPosition = getLayer(ilayer: "Default")
        }
        for button in periphButtonArr {
            button.layer.zPosition = getLayer(ilayer: "Default")
        }
    }

    func progressTutorial() {
        pc!.tutorialPopup.hide()

        let peripheralButtonTutorialNumb = defaultPeripheralIcon.count
        if currentTutorialPopup == tutorialPopupText.count {
            swoopAlpha(iobject: DimOverlay, ialpha: 0.0, iduration: 0.15)
            tutorialActive = false
            periphButtonArr[defaultPeripheralIcon.count - 1].layer.zPosition = getLayer(ilayer: "Default")
//            pc!.startTestReminder(itime: 1)
            return
        }
        for i in 0 ..< peripheralButtonTutorialNumb {
//            setLayer(iobject: periphButtonArr[i], ilayer: "Default")
            periphButtonArr[i].layer.zPosition = getLayer(ilayer: "Default")
        }

        // peripheral button popups
        var parentType = ""
        if currentTutorialPopup < peripheralButtonTutorialNumb {
            periphButtonArr[currentTutorialPopup].layer.zPosition = getLayer(ilayer: "TutorialFrontLayer0")
            parentType = "PeripheralButton"

        } else if currentTutorialPopup < tutorialPopupText.count - 1 {
            // show starting note
            let buttonStr = specifiedNoteCollection[currentTutorialPopup - peripheralButtonTutorialNumb]

            for (_, dot) in specifiedNoteCollection.enumerated() {
                dotDict[dot]!.layer.zPosition = getLayer(ilayer: "TutorialFrontLayer1")
            }
            FretboardImage.layer.zPosition = getLayer(ilayer: "TutorialFrontLayer0")
            dotDict[buttonStr]!.layer.zPosition = getLayer(ilayer: "TutorialFrontLayer1")
            parentType = buttonStr + "Fret"

            let button = UIButton()
            button.tag = buttonDict.filter { $1 == buttonStr }.map { $0.0 }[0] + 100

            FretPressed(button)
        } else {
            if developmentMode > 1 {
                pc!.tutorialPopup.hide()
            }
            for (_, dot) in specifiedNoteCollection.enumerated() {
//                setLayer(iobject: dotDict[dot]!, ilayer: "Default")
                dotDict[dot]!.layer.zPosition = getLayer(ilayer: "Default")
            }
//            setLayer(iobject: FretboardImage, ilayer: "Default")
            FretboardImage.layer.zPosition = getLayer(ilayer: "Default")
            pc!.tutorialPopup.hide()
            //            mainPopoverBodyText.font = mainPopoverBodyText.font.withSize(20)
            //            mainPopoverBodyText.text = tutorialPopupText[tutorialPopupText.count - 1]
            wt.waitThen(itime: 0.4, itarget: self, imethod: #selector(presentMainPopover) as Selector, irepeats: false, idict: ["arg1": "TutorialComplete" as AnyObject, "arg2": 0 as AnyObject])
            return
        }
        wt.waitThen(itime: 0.3, itarget: self, imethod: #selector(presentTutorialPopup) as Selector, irepeats: false, idict: ["arg1": currentTutorialPopup as AnyObject, "arg2": parentType as AnyObject])

        currentTutorialPopup += 1
        if developmentMode > 0 { print("currentTutorialPopup \(currentTutorialPopup)") }
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

    @objc func presentTutorialPopup(timer: Timer) {
        let argDict = timer.userInfo as! [String: AnyObject]
        let wchPopup = argDict["arg1"] as! Int
        let popupObjectParentType = argDict["arg2"] as! String
        if popupObjectParentType == "PeripheralButton" {
            let c = view.convert(periphButtonArr[wchPopup].frame, from: PeripheralStackView)
            pc!.tutorialPopup.show(text: tutorialPopupText[wchPopup], direction: .left, maxWidth: 200, in: view, from: c)
        } else if popupObjectParentType.contains("Fret") {
            let buttonStr = popupObjectParentType.replacingOccurrences(of: "Fret", with: "")
            let frame = dotDict[buttonStr]!.frame
            pc!.tutorialPopup.show(text: tutorialPopupText[wchPopup], direction: .left, maxWidth: 200, in: view, from: frame)
        } else {
            pc!.tutorialPopup.shouldDismissOnTap = true
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            let center = UIView(frame: CGRect(x: screenWidth / 2, y: screenHeight / 2, width: 0, height: 0))
            pc!.tutorialPopup.show(text: tutorialPopupText[wchPopup], direction: .none, maxWidth: 700, in: view, from: center.frame)
        }
    }

    func setupScreenOverlay() -> UIImageView {
        let overlay = UIImageView()
        let frame = navigationController?.navigationBar.frame
        overlay.frame = CGRect(x: (frame?.minX)!, y: (frame?.minY)! + (frame?.height)!, width: view.frame.width, height: view.frame.height)
        overlay.alpha = 0.0
        return overlay
    }
    
    func setAlphaOnDefualtImages(_ alpha: CGFloat) {
        tempoButtonArr = [TempoUpButton, TempoDownButton, FretOffsetButton]
        for btn in periphButtonArr {
            btn.alpha = alpha
        }
        TempoUpButton.alpha = alpha
        TempoDownButton.alpha = alpha
        TempoButton.alpha = alpha
        FretOffsetButton.alpha = alpha
        FretboardDummy.alpha = 0.0
        ResultButton.alpha = alpha
    }

    func setupFretBoardImage() {
        sceneHasBeenSetup = true
        let noteInputStrs = ["G#1", "A1", "A#1", "B1", "C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2", "C3", "C#3", "D3", "D#3_0", "D#3_1", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3", "C4"]

        let fretMarkerImageOffset: [String: CGFloat] = [
            "G#1": 1.2,
            "A1": 1.2,
            "A#1": 1.2,
            "B1": 1.2,
            "C2": 1.2,
            "C#2": 1.0,
            "D2": 1.0,
            "D#2": 1.0,
            "E2": 1.0,
            "F2": 1.0,
            "F#2": 1.0,
            "G2": 0.9,
            "G#2": 1.0,
            "A2": 1.0,
            "A#2": 1.0,
            "B2": 1.0,
            "C3": 1.0,
            "C#3": 1.0,
            "D3": 1.0,
            "D#3_0": 1.0,
            "D#3_1": 1.0,
            "E3": 1.0,
            "F3": 1.0,
            "F#3": 1.0,
            "G3": 1.0,
            "G#3": 0.8,
            "A3": 0.8,
            "A#3": 0.8,
            "B3": 0.8,
            "C4": 0.8,
        ]

        let image: UIImage = UIImage(named: "FretBoardOffDot")!
        FretboardImage = UIImageView()
        FretboardImage.image = image
//        setLayer(iobject: FretboardImage, ilayer: "Default")
        FretboardImage.layer.zPosition = getLayer(ilayer: "Default")

        let fretboardAspectFit = AVMakeRect(aspectRatio: FretboardDummy.image!.size, insideRect: FretboardDummy.bounds)

        FretboardDummy.alpha = 0

        var fretboardXLoc = CGFloat(FretboardDummy.frame.minX + fretboardAspectFit.minX)
        let fretboardYLoc = FretboardDummy.frame.minY
        let fretboardWidth = fretboardAspectFit.width
        let fretboardHeight = fretboardAspectFit.height

        let iphone11AspectFitWidth = 225.5464759959142

        FretboardImage.frame = CGRect(x: fretboardXLoc,
                                      y: fretboardYLoc,
                                      width: fretboardWidth,
                                      height: fretboardHeight)
        FretboardImage.alpha = 1.0
        
        fretboardXLoc *= FretboardDummy.frame.width / fretboardAspectFit.width

        view.addSubview(FretboardImage)
        fretboardXLoc = FretboardImage.frame.minX

        let buttonSize: [CGFloat] = [0.03, 0.2, 0.195, 0.18, 0.17, 0.163]
        let buttonWidth: [CGFloat] = [0.18, 0.164, 0.164, 0.164, 0.164, 0.18]

        let color = [UIColor.blue, UIColor.yellow, UIColor.red, UIColor.green, UIColor.black, UIColor.cyan]
        var buttonTag = 0
        
        for string in 0 ... 5 {
            var xOffset: CGFloat = 0
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

                view.addSubview(button)

                if i > 0 {
                    button.addTarget(self, action: #selector(FretPressed), for: .touchDown)
                    button.tag = buttonTag
//                    button.backgroundColor = color[i%color.count]

                    let image = SpringImageView()
                    image.setAndPlayAnim()
                    let imageXOffset: CGFloat = 0

                    let imageSize = 34 * (fretboardAspectFit.width / CGFloat(iphone11AspectFitWidth))
                    image.frame = CGRect(
                        x: (button.frame.width / 2 * fretMarkerImageOffset[noteInputStrs[buttonTag]]!) - imageSize / 2 - imageXOffset + button.frame.minX,
                        y: button.frame.height / 2 - 20 + button.frame.minY,
                        width: imageSize,
                        height: imageSize
                    )

                    image.backgroundColor = defaultColor.FretMarkerStandard
                    image.layer.masksToBounds = true
                    image.layer.cornerRadius = image.frame.width / 2

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
                    buttonTag += 1                }
            }
        }
        fretButtonDict["A1"]?.layer.zPosition = 1000
        fretButtonDict["A2"]?.layer.zPosition = 1000

        initializeFretReferenceText() //TODO: do if/when necessary
    }

    // Helper functions
    @objc func alphaSwoopImage(timer: Timer) {
        let image = timer.userInfo as! [String: AnyObject]
        var alpha = 0.0
        if let a = image["Alpha"] {
            alpha = a as! Double
        }
        swoopAlpha(iobject: dotDict[image["ImageId"] as! String]!, ialpha: Float(alpha), iduration: 0.2)
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

    func setLayer(iobject: AnyObject, ilayer: String) {
        return
//        if #available(iOS 13.0, *) {
//            iobject.layer.zPosition = getLayer(ilayer: ilayer)
//        } else {
//            // Fallback on earlier versions
//            print("Fallback within set Layer")
//        }
    }

    func getLayer(ilayer: String) -> CGFloat {
        let layer = layerArr.firstIndex(of: ilayer)
        if layer != nil {
            return CGFloat(layer!)
        }
        print("layer does not exist")
        return 0
    }

    @objc func onTestButtonDown() {
        //iterate through note label and update notes
    }

    // Testing
    @objc func randomButtonTest() {
        let randNumb = rand(max: 4)
        switch randNumb {
        case 0:
            let button = UIButton()
            button.tag = rand(max: 2)
            scrollTempo(button)
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
        let t = Double(rand(max: 50)) / 100.0
        wt.waitThen(itime: t, itarget: self, imethod: #selector(randomButtonTest) as Selector, irepeats: false, idict: ["arg1": "0" as AnyObject])
    }

    // Unused functions that will be employed when dev starts on other functionality
    func initializeFretReferenceText() {
        FretRefText = UILabel()
        FretRefText.text = returnCurrentFretText()
        let a1ButtonFrame = fretButtonFrame["A1"]!
        let width: CGFloat = 100.0, height: CGFloat = 100.0
//        let xPos = a1ButtonFrame.minX / 2 - width / 4
        let xPos = 0.0 //FretboardImage.frame.minX/2
        FretRefText.textAlignment = NSTextAlignment.center
        
//        fretRefText.frame = CGRect(x: xPos, y: a1ButtonFrame.minY - height / 2 + a1ButtonFrame.height / 2, width: width, height: height)
        
        print("dotDict[].frame.height",dotDict["A1"]?.frame.height)
        FretRefText.frame = CGRect(x: 0, y: (dotDict["A1"]?.frame.minY)!, width: FretboardImage.frame.minX, height: 30)
        
        FretRefText.textColor = defaultColor.FretMarkerStandard
//        fretRefText.backgroundColor = defaultColor.FretPositionLabelBackground
        view.addSubview(FretRefText)
    }
    
    func returnCurrentFretText() -> String {
        let fret = 5+fretOffset
//        return "\(fret)\(sCollection!.returnLinguisticNumberEquivalent(String(defaultFretOffset-fretOffset)))\(" Fret")"
        return "\(fret)\(sCollection!.returnLinguisticNumberEquivalent(String(fret)))\(" Fret")"
    }

    @IBAction func record(_: Any) {
        recordStartTime = 0
        currentState = State.Recording
        recordData.removeAll()
    }
    
    func setupMenuNoteCollectionPlayback(iinput: String) {
        let notes = sCollection?.setupSpecifiedNoteCollection(iinput: iinput, idirection: "Up")
        let waitTime = 0.2
        for (i,note) in notes!.enumerated() {
            let lastNote = i == notes!.count-1
            wt.waitThen(itime: waitTime*Double(i), itarget: self, imethod: #selector(playSoundHelper) as Selector, irepeats: false, idict: ["Note": note as AnyObject,"LastNote": lastNote as AnyObject])
        }
    }
        
    func setupPlayRecordingData() -> [InputData] {
        var recordedData: [InputData] = []
        let fetchRequest: NSFetchRequest<RecordingData> = RecordingData.fetchRequest()
        if let results = try? globalDataController.viewContext.fetch(fetchRequest) {
            print("result",results)
            for result in results {
                if result.id == currentRecordingId {
                    for (i,_) in result.notes!.enumerated() {
                        let input = InputData()
                        input.note = result.notes![i]
                        input.time = Double(result.time![i])!
                        input.fretOffset = Int(result.fretOffset)
                        recordedData.append(input)
                    }
                }
            }
        }
        return recordedData
    }
    
    func playRecording(_ iforceFretOffsetUpdate: Bool = false) {
        currentState = State.RecordingPlayback
        recordData = setupPlayRecordingData()
        recordStartTime = recordData[0].time
        if iforceFretOffsetUpdate {
            print("recordData[0].fretOffset recordData[0].fretOffset ", recordData[0].fretOffset)
            fretOffset = recordData[0].fretOffset
        }
        for (i, data) in recordData.enumerated() {
            let lastNote = i == recordData.count - 1
            wt.waitThen(itime: data.time - recordStartTime, itarget: self, imethod: #selector(playSoundHelper) as Selector, irepeats: false, idict: ["Note": data.note as AnyObject,"LastNote": lastNote as AnyObject])
        }
    }
    
    func saveRecording() {
        if recordData.count == 0 {return}
        let recordingInstance = RecordingData(context: globalDataController.viewContext)
        var notes: [String] = []
        var time: [String] = []
        for data in recordData {
            notes.append(data.note)
            time.append(String(data.time))
        }
        let currentTime = generateTimeStamp()
        recordingInstance.timeDelta = [""]
        recordingInstance.id = currentTime
        recordingInstance.notes = notes
        recordingInstance.time = time
        recordingInstance.fretOffset = Int16(fretOffset)
        do {
            try globalDataController.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        currentRecordingId = currentTime
    }
    
    func generateTimeStamp() -> String {
        let today = Date()
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm:ss E, d MMM y"
        return formatter3.string(from: today)
    }

    @IBAction func earTrainingPressed(_: Any) {
//        let numbNotes = 5
//        for _ in 0 ..< numbNotes {
//            earTrainCallArr.append(tempScale[rand(max: tempScale.count)])
//        }
//        currentState = State.EarTrainingCall
//        met?.currentClick = 0
//        let displayT = 1.0
//
//        wt.waitThen(itime: displayT, itarget: self, imethod: #selector(beginEarTrainingHelper) as Selector, irepeats: false, idict: ["NoteSelection": tempScale as AnyObject, "AlphaVal": 0.0 as AnyObject])
//
//        displaySelectionDots(inoteSelection: tempScale, ialphaAmount: 0.5)
//        dotDict[earTrainCallArr[0]]?.alpha = 1
    }

    @objc func beginEarTrainingHelper(timer: Timer) {
//        let argDict = timer.userInfo as! [String: AnyObject]
//        displaySelectionDots(inoteSelection: argDict["NoteSelection"] as! [String], ialphaAmount: argDict["AlphaVal"] as! Double)
//        met?.startMetro()
    }

    func presentEarTrainResults() {
        let resultText = earTrainCallArr == earTrainResponseArr ? "Good" : "Bad"
        ResultsLabel.text = resultText
        earTrainCallArr.removeAll()
        earTrainResponseArr.removeAll()
        currentState = State.Idle
    }
    
    func setupUpDelayedNoteCollectionView(_ inoteCollection: [String], _ itype: String) {
        let waitTime = 0.03
        for (i,_) in inoteCollection.enumerated() {
            wt.waitThen(itime: Double(i)*waitTime, itarget: self, imethod: #selector(displaySingleFretMarkerWrapper) as Selector, irepeats: false, idict: ["arg1": inoteCollection[i] as AnyObject,"arg2": true as AnyObject, "arg3": itype as AnyObject])
        }
    }
    
    @objc func displaySingleFretMarkerWrapper(timer: Timer) {
        let resultObj = timer.userInfo as! [String: AnyObject]
        let input = resultObj["arg1"] as! String
        let cascadeFretMarkers = resultObj["arg2"] as! Bool
        let animType = resultObj["arg3"] as! String
//        let levelPassed = resultObj["arg2"] as! Int
        displaySingleFretMarker(iinputStr: input, cascadeFretMarkers: cascadeFretMarkers, fretAnim: animType)
        
    }
    
    func getTimingFunction(curve: String) -> CAMediaTimingFunction {
        if let curve = AnimationCurve(rawValue: curve) {
            switch curve {
            case .EaseIn: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            case .EaseOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            case .EaseInOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            case .Linear: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//            case .Spring: return CAMediaTimingFunction(controlPoints: 0.5, 1.1+Float(force/3), 1, 1)
            case .Spring: return CAMediaTimingFunction(controlPoints: 0.5, 1.1+Float(3/3), 1, 1)
            case .EaseInSine: return CAMediaTimingFunction(controlPoints: 0.47, 0, 0.745, 0.715)
            case .EaseOutSine: return CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1)
            case .EaseInOutSine: return CAMediaTimingFunction(controlPoints: 0.445, 0.05, 0.55, 0.95)
            case .EaseInQuad: return CAMediaTimingFunction(controlPoints: 0.55, 0.085, 0.68, 0.53)
            case .EaseOutQuad: return CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
            case .EaseInOutQuad: return CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
            case .EaseInCubic: return CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
            case .EaseOutCubic: return CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
            case .EaseInOutCubic: return CAMediaTimingFunction(controlPoints: 0.645, 0.045, 0.355, 1)
            case .EaseInQuart: return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
            case .EaseOutQuart: return CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
            case .EaseInOutQuart: return CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
            case .EaseInQuint: return CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
            case .EaseOutQuint: return CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
            case .EaseInOutQuint: return CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
            case .EaseInExpo: return CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
            case .EaseOutExpo: return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
            case .EaseInOutExpo: return CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
            case .EaseInCirc: return CAMediaTimingFunction(controlPoints: 0.6, 0.04, 0.98, 0.335)
            case .EaseOutCirc: return CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.165, 1)
            case .EaseInOutCirc: return CAMediaTimingFunction(controlPoints: 0.785, 0.135, 0.15, 0.86)
            case .EaseInBack: return CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
            case .EaseOutBack: return CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
            case .EaseInOutBack: return CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
            }
        }
        return CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
    }
    
    public enum AnimationCurve: String {
        case EaseIn = "easeIn"
        case EaseOut = "easeOut"
        case EaseInOut = "easeInOut"
        case Linear = "linear"
        case Spring = "spring"
        case EaseInSine = "easeInSine"
        case EaseOutSine = "easeOutSine"
        case EaseInOutSine = "easeInOutSine"
        case EaseInQuad = "easeInQuad"
        case EaseOutQuad = "easeOutQuad"
        case EaseInOutQuad = "easeInOutQuad"
        case EaseInCubic = "easeInCubic"
        case EaseOutCubic = "easeOutCubic"
        case EaseInOutCubic = "easeInOutCubic"
        case EaseInQuart = "easeInQuart"
        case EaseOutQuart = "easeOutQuart"
        case EaseInOutQuart = "easeInOutQuart"
        case EaseInQuint = "easeInQuint"
        case EaseOutQuint = "easeOutQuint"
        case EaseInOutQuint = "easeInOutQuint"
        case EaseInExpo = "easeInExpo"
        case EaseOutExpo = "easeOutExpo"
        case EaseInOutExpo = "easeInOutExpo"
        case EaseInCirc = "easeInCirc"
        case EaseOutCirc = "easeOutCirc"
        case EaseInOutCirc = "easeInOutCirc"
        case EaseInBack = "easeInBack"
        case EaseOutBack = "easeOutBack"
        case EaseInOutBack = "easeInOutBack"
    }
}

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

extension UIImageView {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 2.0
        pulse.fromValue = 0.95
        pulse.toValue = 1.3
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 10.5
        pulse.damping = 1.0
    }
}

extension SpringImageView {
    public func setAndPlayAnim(_ itype: String = "userFretPress") {
        switch itype {
        case "userFretPress":
            self.animation = "zoomIn"
            self.curve = "easeOut"
            self.force = 1.0
            self.duration = 0.4
            self.delay = 0.0
        case "displayFret":
            self.animation = "fadeIn"
            self.curve = "easeOut"
            self.force = 1.0
            self.duration = 0.1
            self.delay = 0.0
        case "postSuccess":
            self.animation = "zoomIn"
            self.curve = "easeOut"
            self.force = 0.5
            self.duration = 0.4
            self.delay = 0.0
        case "tutorialSlideIn":
            self.animation = "slideRight"
            self.curve = "easeInOut"
            self.force = 5.0
            self.duration = 0.6
        case "fadeOnPopoverDismiss":
            self.animation = "fadeOut"
            self.curve = "easeIn"
            self.force = 1.0
            self.duration = 0.4
        default:
            return
        }
        UIView.setAnimationsEnabled(true)
        self.animate()
    }
}

extension SpringLabel {
    public func setAndPlayAnim(_ itype: String = "titleTextIntro") {
        switch itype {
        case "titleTextIntro":
            self.animation = "slideRight"
            self.curve = "easeInOut"
            self.force = 5.0
            self.duration = 0.6
        case "subTitleTextIntro":
            self.animation = "squeezeUp"
            self.curve = "easeIn"
            self.force = 1.0
            self.duration = 0.4
//            self.rotate = 0.7
//            self.scaleX = 1.7
//            self.scaleY = 1.7
        case "subTextIntro" :
            self.animation = "slideLeft"
            self.curve = "spring"
            self.force = 1.0
            self.duration = 0.6
        case "buttonTextIntro" :
            self.animation = "fadeIn"
            self.curve = "easeIn"
            self.force = 1.0
            self.duration = 1.6
        default:
            return
        }
        UIView.setAnimationsEnabled(true)
        self.animate()
    }
}

extension SpringButton {
    public func setAndPlayAnim(_ itype: String = "slamButton") {
        switch itype {
        case "slamButton":
            self.animation = "zoomIn"
            self.curve = "easeOut"
            self.force = 1.0
            self.duration = 0.4
            self.delay = 0.0
        case "xButtonIntro" :
            self.animation = "fadeIn"
            self.curve = "easeIn"
            self.force = 1.0
            self.duration = 1.6
        default:
            return
        }
        UIView.setAnimationsEnabled(true)
        self.animate()
    }
}

extension UIButton {

    func blink(enabled: Bool = true, duration: CFTimeInterval = 1.0, stopAfter: CFTimeInterval = 0.0) {
        enabled ? UIView.animate(withDuration: duration,
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

        layer.zPosition += 1.0
        return (ilayer + 1)
    }
}

extension UIImage {
    func darkened() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return nil
        }

        // flip the image, or result appears flipped
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.translateBy(x: 0, y: -size.height)

        let rect = CGRect(origin: .zero, size: size)
        ctx.draw(cgImage, in: rect)
        UIColor(white: 0, alpha: 0.35).setFill()
        ctx.fill(rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension Dictionary where Value: Equatable {
    /// Returns all keys mapped to the specified value.
    /// ```
    /// let dict = ["A": 1, "B": 2, "C": 3]
    /// let keys = dict.keysForValue(2)
    /// assert(keys == ["B"])
    /// assert(dict["B"] == 2)
    /// ```
    func keysForValue(value: Value) -> [Key] {
        return compactMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}
