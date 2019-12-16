//
//  Metronome.swift
//  MetronomeIdea
//
//  Created by Alex Shubin on 26.03.17.
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
       
    //Game Objects
    @IBOutlet weak var Dot_GS1: UIImageView!
    @IBOutlet weak var Dot_A1: UIImageView!
    @IBOutlet weak var Dot_AS1: UIImageView!
    @IBOutlet weak var Dot_B1: UIImageView!
    @IBOutlet weak var Dot_C2: UIImageView!
    @IBOutlet weak var Dot_CS2: UIImageView!
    @IBOutlet weak var Dot_D2: UIImageView!
    @IBOutlet weak var Dot_DS2: UIImageView!
    @IBOutlet weak var Dot_E2: UIImageView!
    @IBOutlet weak var Dot_F2: UIImageView!
    @IBOutlet weak var Dot_FS2: UIImageView!
    @IBOutlet weak var Dot_G2: UIImageView!
    @IBOutlet weak var Dot_GS2: UIImageView!
    @IBOutlet weak var Dot_A2: UIImageView!
    @IBOutlet weak var Dot_AS2: UIImageView!
    @IBOutlet weak var Dot_B2: UIImageView!
    @IBOutlet weak var Dot_C3: UIImageView!
    @IBOutlet weak var Dot_CS3: UIImageView!
    @IBOutlet weak var Dot_D3: UIImageView!
    @IBOutlet weak var Dot_DS3: UIImageView!
    @IBOutlet weak var Dot_E3: UIImageView!
    @IBOutlet weak var Dot_F3: UIImageView!
    @IBOutlet weak var Dot_FS3: UIImageView!
    @IBOutlet weak var Dot_G3: UIImageView!
    @IBOutlet weak var Dot_GS3: UIImageView!
    @IBOutlet weak var Dot_A3: UIImageView!
    @IBOutlet weak var Dot_AS3: UIImageView!
    @IBOutlet weak var Dot_B3: UIImageView!
    @IBOutlet weak var Dot_C4: UIImageView!
    
    @IBOutlet weak var BPM_textField: UITextField!
    @IBOutlet weak var ResultsLabel0: UILabel!
    @IBOutlet weak var ResultsLabel1: UILabel!
    @IBOutlet weak var PeriphButton0: UIButton!
    @IBOutlet weak var PeriphButton1: UIButton!
    @IBOutlet weak var PeriphButton2: UIButton!
    @IBOutlet weak var PeriphButton3: UIButton!
    @IBOutlet weak var PeriphButton4: UIButton!
    @IBOutlet weak var PeriphButton5: UIButton!
    
    @IBOutlet weak var NavBar: UINavigationBar!
    @IBOutlet weak var NavBarFiller: UIImageView!
    @IBOutlet weak var NavBackButton: UIBarButtonItem!
    @IBOutlet weak var NavSettingsButton: UIBarButtonItem!
    @IBOutlet weak var NavBarTitle: UINavigationItem!
    @IBOutlet weak var TempoButton: UIButton!
    @IBOutlet weak var TempoDownButton: UIButton!
    @IBOutlet weak var TempoUpButton: UIButton!
    
    @IBOutlet weak var ResultButton1: UIButton!

    lazy var dotDict: [String:UIImageView] = [
        "G#1": Dot_GS1,
        "A1" : Dot_A1,
        "A#1" : Dot_AS1,
        "B1" : Dot_B1,
        "C2" : Dot_C2,
        "C#2" : Dot_CS2,
        "D2" : Dot_D2,
        "D#2" : Dot_DS2,
        "E2" : Dot_E2,
        "F2" : Dot_F2,
        "F#2" : Dot_FS2,
        "G2" : Dot_G2,
        "G#2" : Dot_GS2,
        "A2" : Dot_A2,
        "A#2" : Dot_AS2,
        "B2" : Dot_B2,
        "C3" : Dot_C3,
        "C#3" : Dot_CS3,
        "D3" : Dot_D3,
        "D#3" : Dot_DS3,
        "E3" : Dot_E3,
        "F3" : Dot_F3,
        "F#3" : Dot_FS3,
        "G3" : Dot_G3,
        "G#3" : Dot_GS3,
        "A3" : Dot_A3,
        "A#3" : Dot_AS3,
        "B3" : Dot_B3,
        "C4" : Dot_C4
    ]

    //TIMERS
    var dotFadeTime : Timer?
    var userInputTime = CFAbsoluteTimeGetCurrent()
    var recordStartTime: CFAbsoluteTime = 0
    var recordStopTime: CFAbsoluteTime = 0
    var previousNote: String?
    
    class InputData {
        var time: CFAbsoluteTime = 0
        var note = ""
        var timeDelta = 0.0
    }
    
    var periphButtonArr : [UIButton] = []
    var recordData : [InputData] = []
    var scaleTestData : [InputData] = []
    var earTrainCallArr: [String] = []
    var earTrainResponseArr: [String] = []
    
    var defaultPeripheralIcon: [String] = []
    var activePeripheralIcon: [String] = []
    
    var developmentMode = true
    
    let timeThreshold : [String:Double] = [
        "Easy": 0.1,
        "Medium": 0.075,
        "Hard": 0.05
    ]
    
    var specifiedScale : [String] = []
    let tempScale : [String] = ["A1","C2","D2","E2","G2"]
    
    var result1ViewStrs : [String] = []
    var currentResultView = 0
    
    let sc = SoundController(isubInstances: 10)
    let click = SoundController(isubInstances: 10)
    var met : Metronome? = nil
    var sCollection : ScaleCollection? = nil
    var et : EarTraining? = nil
    
    var tempoButtonsActive = false
    
    var buttonDict: [Int:String] = [
        0 : "G#1",
        1 : "A1",
        2 : "A#1",
        3 : "B1",
        4 : "C2",
        5 : "C#2",
        6 : "D2",
        7 : "D#2",
        8 : "E2",
        9 : "F2",
        10 : "F#2",
        11 : "G2",
        12 : "G#2",
        13 : "A2",
        14 : "A#2",
        15 : "B2",
        16 : "C3",
        17 : "C#3",
        18 : "D3",
        19 : "D#3",
        20 : "E3",
        21 : "F3",
        22 : "F#3",
        23 : "G3",
        24 : "G#3",
        25 : "A3",
        26 : "A#3",
        27 : "B3",
        28 : "C4",
    ]
    
    var buttonNote : [String:UILabel] = [:]
    
    enum State {
        case Idle
        case RecordingIdle
        case Recording
        case Playback
        
        case EarTrainCall
        case EarTrainResponse
        
        case PlayingScale
        
        case ScaleTest_NoTempo
        case ScaleTestIdle_NoTempo
        case ScaleTestActive_NoTempo
        
        case ScaleTestCountIn_Tempo
        case ScaleTestActive_Tempo
        case ScaleTestIdle_Tempo
        
        case ScaleTestShowScale
//        case ScaleTestResult
    }
    
    var currentState = State.Idle
    var allMarkersDisplayed = false
    var defaultState : State?
    var currentLevel: String?
    var currentLevelConstruct: [[String]] = [[]]
    var currentLevelKey: String?
    let digitInput = DigitsInput()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = defaultColor.BackgroundColor
        
        met = Metronome(ivc: self)
        sCollection = ScaleCollection(ivc: self)
        et = EarTraining(ivc: self)
        
        BPM_textField.text = String(Int(met!.bpm))
        BPM_textField.isHidden = true
        
        self.digitInput.vc = self
        self.BPM_textField.delegate = self.digitInput
        
        ResultsLabel0.text = ""
        ResultsLabel1.text = ""
        
        ResultsLabel0?.adjustsFontSizeToFitWidth = true
        ResultsLabel1?.adjustsFontSizeToFitWidth = true
        
        ResultsLabel0?.textColor = defaultColor.MenuButtonTextColor
        
        setupFretMarkerText(ishowAlphabeticalNote: false, ishowNumericDegree: true)
        
        NavBar.barTintColor = defaultColor.MenuButtonColor
        NavBarFiller.backgroundColor = defaultColor.MenuButtonColor
        NavBackButton.tintColor = defaultColor.MenuButtonTextColor
        NavSettingsButton.tintColor = defaultColor.MenuButtonTextColor
        NavBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:defaultColor.NavBarTitleColor]
        
        ResultButton1.titleLabel?.adjustsFontSizeToFitWidth = true
        ResultButton1.setTitleColor(.black, for: .normal)
        ResultButton1.setTitle("", for: .normal)
        ResultButton1.titleLabel?.adjustsFontSizeToFitWidth = true
        ResultButton1.titleLabel?.minimumScaleFactor = 0.5
        ResultButton1.backgroundColor = defaultColor.ResultsButtonColor
        ResultButton1.setTitleColor(.white, for: .normal)
        
        periphButtonArr.append(PeriphButton0)
        periphButtonArr.append(PeriphButton1)
        periphButtonArr.append(PeriphButton2)
        periphButtonArr.append(PeriphButton3)
        periphButtonArr.append(PeriphButton4)
        periphButtonArr.append(PeriphButton5)
        
        setupToSpecificState()
    }
    
    func setStateProperties (icurrentState: State, itempoButtonsActive: Bool, icurrentLevel: String, ilevelConstruct: [[String]], ilevelKey: String) {
        currentState = icurrentState
        defaultState = currentState
        tempoButtonsActive = itempoButtonsActive
        currentLevel = icurrentLevel
        currentLevelConstruct = ilevelConstruct
        currentLevelKey = ilevelKey
    }
    
    func setupToSpecificState () {
        print("setupToSpecificState \(currentState)")
        
        if (currentState == State.RecordingIdle)
        {
            setButtonState(ibutton : PeriphButton0,ibuttonState : false)
        }
        if (currentState == State.ScaleTestIdle_NoTempo)
        {
            setupCurrentTask()
            defaultPeripheralIcon = ["play","music.note","info"]
            activePeripheralIcon = ["pause","arrowshape.turn.up.left","arrowshape.turn.up.left"]
            setupTempoButtons(ibuttonsActive: tempoButtonsActive)
            displayMultipleFretMarkers(iinputArr: specifiedScale, ialphaAmount: 1.0)
            
        }
        setupPeripheralButtons(iiconArr : defaultPeripheralIcon)
    }
    
    func setupCurrentTask () {
        let task = returnCurrentTask()
        sCollection!.setupSpecifiedScale(iinput: task)
//        setupFretMarkerText(ishowAlphabeticalNote: false, ishowNumericDegree: true)
        ResultsLabel0.text = sCollection!.returnReadableScaleName(iinput: task)
    }
    
    func returnCurrentTask() -> String {
        let level = returnConvertedLevel(iinput: currentLevel!)
        let subLevel = returnConvertedSubLevel(iinput: currentLevel!)
        
        //make sure the current level/sublevel is not out of range
        if (currentLevelConstruct[level].count > subLevel) {
            return currentLevelConstruct[level][subLevel]
        }
        
        //level/sublevel is out of range, return last task in construct
        return currentLevelConstruct[level][subLevel-1]
    }
    
    func setupPeripheralButtons (iiconArr : [String ]) {
        
        for (i, _) in iiconArr.enumerated() {
            periphButtonArr[i].setTitle("", for: .normal)  //TODO: eventually get rid of text completely
            
            setButtonImage(ibutton: periphButtonArr[i], iimageStr: iiconArr[i])
            periphButtonArr[i].imageView?.tintColor = defaultColor.AlternateButtonInlayColor
            periphButtonArr[i].layer.masksToBounds = true
            periphButtonArr[i].layer.cornerRadius = 25
//            periphButtonArr[i].titleLabel?.minimumScaleFactor = 0.5
//            periphButtonArr[i].titleLabel?.numberOfLines = 0
//            periphButtonArr[i].titleLabel?.adjustsFontSizeToFitWidth = true
            periphButtonArr[i].setTitleColor(.black, for: .normal)
            periphButtonArr[i].backgroundColor = defaultColor.MenuButtonColor
        }
        
        for (i, button) in periphButtonArr.enumerated() {
            if (i < iiconArr.count)
            {
                button.isHidden = false
            }
            else
            {
                button.isHidden = true
            }
        }
    }
    
    func restorePeriphButtonsToDefault (idefaultIcons: [String]) {
        for (i, _) in idefaultIcons.enumerated() {
            setButtonImage(ibutton: periphButtonArr[i], iimageStr: idefaultIcons[i])
        }
    }
    
    func setupTempoButtons (ibuttonsActive : Bool) {
        var buttonColor : UIColor
        var inlayColor : UIColor
        if (ibuttonsActive) {
            buttonColor = defaultColor.MenuButtonColor
            inlayColor = defaultColor.InactiveInlay
        } else {
            buttonColor = defaultColor.InactiveButton
            inlayColor = defaultColor.InactiveInlay
        }
               
        TempoButton.backgroundColor = buttonColor
        TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        TempoButton.setTitleColor(inlayColor, for: .normal)
        TempoButton.layer.masksToBounds = true
        TempoButton.layer.cornerRadius = 25
        
        let insets : CGFloat = 18
        TempoDownButton.contentVerticalAlignment = .fill
        TempoDownButton.contentHorizontalAlignment = .fill
        TempoDownButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        TempoDownButton.backgroundColor = buttonColor
        TempoDownButton.imageView?.tintColor = inlayColor
        TempoDownButton.imageView?.alpha = 0.2
        TempoDownButton.layer.masksToBounds = true
        TempoDownButton.layer.cornerRadius = 25
        
        TempoUpButton.contentVerticalAlignment = .fill
        TempoUpButton.contentHorizontalAlignment = .fill
        TempoUpButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        TempoUpButton.backgroundColor = buttonColor
        TempoUpButton.imageView?.tintColor = inlayColor
        TempoUpButton.layer.masksToBounds = true
        TempoUpButton.layer.cornerRadius = 25
    }
    
    func setupFretMarkerText (ishowAlphabeticalNote: Bool, ishowNumericDegree: Bool, inumericDefaults: [String] = ["b5","b6"]) {
        if (!ishowAlphabeticalNote && !ishowNumericDegree) {
            return
        }
        var idx = 0
        for (str, view) in dotDict {
            view.alpha = 0
            
            var note = ""
            if (ishowAlphabeticalNote) {
                note = str.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789"))
            } else {
                note = sCollection!.returnNoteDistance(iinput: String(str.dropLast()), icomparedNote: "A")
                if (note == "#4" && inumericDefaults[0] == "b5") {
                    note = "b5"
                } else if (note == "#5" && inumericDefaults[1] == "b6") {
                    note = "b6"
                }
                idx += 1
            }

            let scrollView = UILabel()
            let xVal = note.count > 1 ? 7.5 : 11.5
            scrollView.frame = CGRect(x: xVal,y: -22.5,width: 80,height: 80)
            scrollView.textAlignment = NSTextAlignment.natural
            scrollView.text = note;  //"C"
            scrollView.layer.zPosition = 1;
            buttonNote[str] = scrollView
            dotDict[str]!.addSubview(buttonNote[str]!)
        }
    }
    
    func setButtonState (ibutton : UIButton, ibuttonState : Bool) {
        let alpha = ibuttonState ? 1.0 : 0.0
        ibutton.isEnabled = ibuttonState
        ibutton.alpha = CGFloat(alpha)
    }
    
    func setButtonImage (ibutton: UIButton, iimageStr : String) {
        if #available(iOS 13.0, *) {
            ibutton.setImage(UIImage(systemName: iimageStr), for: .normal)
        } else {
            // Fallback on earlier versions
        //            PeriphButton0.setImage(UIImage(named: "pencil"), for: UIControl.State.normal)  //i am not sure if this works
        }
    }
    
    func setPeripheralButtonsToDefault () {
        for (i, str) in defaultPeripheralIcon.enumerated() {
            setButtonImage(ibutton: periphButtonArr[i], iimageStr: str)
        }
    }
    
    func recordTimeAccuracy() {
        if (met!.currentClick >= met!.countInClick || true)
        {
            userInputTime = CFAbsoluteTimeGetCurrent()
            
            if (userInputTime - met!.clickTime > 0.5)
            {
            }
            else
            {
                let timeDelta = abs(userInputTime - met!.clickTime)
                if (timeDelta < 0.05)
                {
                    print("good")
                }
                else
                {
                    print ("late")
                }
                scaleTestData[scaleTestData.count-1].time = userInputTime
                scaleTestData[scaleTestData.count-1].timeDelta = timeDelta
            }
        }
        //sc.playSound(isoundName: "ButtonClick")
    }
    
    func returnValidState (iinputState : State, istateArr : [State]) -> Bool {
        for (_,item) in istateArr.enumerated() {
            if (iinputState == item) {
                return true
            }
        }
        return false
    }
    
    @IBAction func NavToMainMenu(_ sender: Any) {
        var controller: MainMenuViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    @IBAction func scrollTempo(_ sender: UIButton) {
        if (!tempoButtonsActive) {return}
        let dir = sender.tag == 0 ? 1.0 : -1.0
        met!.bpm = met!.bpm + dir
        TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
    }
   
    
    @IBAction func startMetronome(_ sender: Any) {
        met?.startMetro()
    }
    
    
    //Peripheral Buttons Down
    @IBAction func PeripheralButton0OnButtonDown(_ sender: Any) {
                
        print("PeripheralButton0OnButtonDown \(currentState)")
        let wchButton = 0
        setPeripheralButtonsToDefault()
               
        //Scale Test States
        if (currentState == State.ScaleTestIdle_NoTempo || currentState == State.ScaleTestShowScale) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
            currentState = State.ScaleTestActive_NoTempo
            hideAllFretMarkers()
//            met?.currentClick = 0
//            scaleTestData.removeAll()
//            met?.startMetro()
        }
        else if (currentState == State.ScaleTestActive_NoTempo) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
            currentState = State.ScaleTestIdle_NoTempo
            
            met!.endMetronome()
            ResultButton1.setTitle("", for: .normal)
        }
    }
    
    @IBAction func PeripheralButton1OnButtonDown(_: AnyObject) {
        
        print("PeripheralButton1OnButtonDown \(currentState)")
        let wchButton = 1
        
        //Scale Test States
        if (currentState == State.ScaleTestIdle_NoTempo) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
            currentState = State.PlayingScale
            met?.startMetro()
            hideAllFretMarkers()
        } else if (currentState == State.PlayingScale) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
            currentState = State.ScaleTestIdle_NoTempo
            met?.endMetronome()
        }
    }
    
    @IBAction func PeripheralButton2OnButtonDown(_ sender: Any) {
        
        print("PeripheralButton2OnButtonDown \(currentState)")
        let wchButton = 2
        
        //Scale Test States
        if (currentState == State.ScaleTestIdle_NoTempo || currentState == State.ScaleTestShowScale) {
            
            if (currentState == State.ScaleTestIdle_NoTempo) {
                setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
                displayMultipleFretMarkers(iinputArr: specifiedScale, ialphaAmount: 1.0)
                currentState = State.ScaleTestShowScale
            }
            else {
                setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
                hideAllFretMarkers()
                currentState = State.ScaleTestIdle_NoTempo
            }
        }
    }
    
    
    @IBAction func Result1ButtonDown(_ sender: Any) {
        
        print("currentState \(currentState)")
        
        if (!result1ViewStrs.isEmpty)
        {
            ResultButton1.setTitle(result1ViewStrs[currentResultView], for: .normal)
            currentResultView = (currentResultView + 1)%result1ViewStrs.count
        }
    }
    
    @IBAction func onBackButtonDown(_ sender: Any) {
               
//        let states = [State.PlayingScale,State.ScaleTestCountIn,State.ScaleTestActive,State.ScaleTestIdle,State.ScaleTestShowScale]
//
//        for (_,state) in states.enumerated() {
//            if (currentState == state) {
//                met!.endMetronome()
//            }
//        }
        
        met!.endMetronome()
        var controller: MainMenuViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    @IBAction func FretPressed(_ sender: UIButton) {
        
        print("in fret pressed state \(currentState)")
        
       let validState = returnValidState(iinputState: currentState, istateArr: [State.Recording, State.Idle, State.EarTrainResponse, State.ScaleTestActive_NoTempo, State.ScaleTestCountIn_Tempo, State.ScaleTestIdle_NoTempo, State.ScaleTestShowScale])
        if (validState)
        {
            hideAllFretMarkers()
            if (currentState == State.ScaleTestShowScale) {
                
                currentState = State.ScaleTestIdle_NoTempo
//                PeriphButton1.setTitle("Show Scale", for: .normal)
            }
            
            
            sc.playSound(isoundName: buttonDict[sender.tag]!)
            displaySingleFretMarker(iinputStr: buttonDict[sender.tag]!)
            if (currentState == State.Recording)
            {
                if (recordStartTime == 0)
                {
                    recordStartTime = CFAbsoluteTimeGetCurrent()
                }
                let r = InputData()
                r.time = CFAbsoluteTimeGetCurrent()
                r.note = buttonDict[sender.tag]!
                recordData.append(r)
            }
            if (currentState == State.EarTrainResponse)
            {
                earTrainResponseArr.append(buttonDict[sender.tag]!)
                if (earTrainResponseArr.count == earTrainCallArr.count)
                {
                    presentEarTrainResults()
                }
            }
            
            if (currentState == State.ScaleTestActive_Tempo)
            {
                let st = InputData()
                st.note = buttonDict[sender.tag]!
                st.time = 0
                scaleTestData.append(st)
                recordTimeAccuracy()
            }
            
            if (currentState == State.ScaleTestActive_NoTempo)
            {
                let st = InputData()
                st.note = buttonDict[sender.tag]!
                st.time = 0
                scaleTestData.append(st)
                if (scaleTestData.count == specifiedScale.count || developmentMode) {
                    currentState = State.ScaleTestIdle_NoTempo
                    restorePeriphButtonsToDefault(idefaultIcons: defaultPeripheralIcon)
                    let scaleCorrect = sCollection!.analyzeScale(iscaleTestData: scaleTestData)
                    _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(presentTestResult), userInfo: ["ScaleCorrect":scaleCorrect], repeats: false)
                }
//                recordTimeAccuracy()
            }
        }
    }
    
//    func analyzeScale () -> Bool {
//        for (i,item) in scaleTestData.enumerated() {
//            if (item.note != specifiedScale[i])
//            {
//                return false
//            }
//        }
//        return true
//    }
    
    @objc func presentTestResult (timer:Timer) {

        var testPassed = false
        let resultObj = timer.userInfo as! Dictionary<String, AnyObject>
        if let test = resultObj["ScaleCorrect"] {
            testPassed = test as! Bool
        } else {
            // abc is nil
        }

        var resultsText = ""
        resultsText =  testPassed ? "Great!" : "Try Again!"
        result1ViewStrs.append(resultsText)
        ResultButton1.setTitle(result1ViewStrs[0], for: .normal)
        
//        analyzeNewLevel(itestPassed: testPassed)
        analyzeNewLevel(itestPassed: true)
    }
    
    func analyzeNewLevel(itestPassed: Bool) {
        if (!itestPassed && !developmentMode) {return}
        
        print("sub level passed \(userLevelData.scaleLevel)")
        
        var level = returnConvertedLevel(iinput: currentLevel!)
        var subLevel = returnConvertedSubLevel(iinput: currentLevel!) + 1
        
        if (subLevel == currentLevelConstruct[level].count) {
            //upgrade level
            let levelConstruct = LevelConstruct()
            if (level < levelConstruct.scale.count - 1) {
                level = level + 1
                subLevel = 0
            } else {
//                subLevel = subLevel - 1
            }
        }
                
        currentLevel = "\(level).\(subLevel)"
        UserDefaults.standard.set(currentLevel, forKey: currentLevelKey!)
        print("updated current level \(currentLevel ?? "")")
        
        setupCurrentTask()
    }
    
    //these functions should exist inone place
    func returnConvertedLevel (iinput : String) -> Int {
        
        let numb = Int(iinput.split(separator: ".")[0])
        return numb!
    }
    
    func returnConvertedSubLevel (iinput : String) -> Int {
        
        let numb = Int(iinput.split(separator: ".")[1])
        return numb!
    }
    
    @IBAction func record(_ sender: Any) {
        recordStartTime = 0
        currentState = State.Recording
        recordData.removeAll()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        print("stopRecording\(recordStartTime)")
        currentState = State.Playback
        
        for (i, data) in recordData.enumerated() {
            _ = Timer.scheduledTimer(timeInterval: data.time - recordStartTime, target: self, selector: #selector(self.playSoundHelper), userInfo: ["Note":data.note], repeats: false)
            if (i == recordData.count-1)
            {
                setState(newState: State.Idle)
            }
        }
    }
    
    @IBAction func earTrainingPressed(_ sender: Any) {
        let numbNotes = 5
        for _ in 0..<numbNotes {
            
            earTrainCallArr.append(tempScale[rand(max: tempScale.count)])
        }
        currentState = State.EarTrainCall
        met?.currentClick = 0
        let displayT = 1
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(displayT), target: self, selector: #selector(self.beginEarTrainingHelper), userInfo: ["NoteSelection":tempScale,"AlphaVal":0.0], repeats: false)
        
        
        displaySelectionDots(inoteSelection: tempScale, ialphaAmount: 0.5)
        dotDict[earTrainCallArr[0]]?.alpha = 1
    }
    
    func setState(newState:State)
    {
        print ("setting \(newState)")
        currentState = newState;
    }
    
    @objc func setStateHelper(timer:Timer)
    {
        let stateDict = timer.userInfo as! Dictionary<String, AnyObject>
        setState(newState: stateDict["state"] as! State)
        //currentState = newState;
    }
    
    @objc func playSoundHelper(timer:Timer)
    {
        let noteDict = timer.userInfo as! Dictionary<String, AnyObject>
        sc.playSound(isoundName: noteDict["Note"] as! String)
        
        displaySingleFretMarker(iinputStr: noteDict["Note"] as! String)
    }
    
    @IBAction func playScale(_ sender: Any)
    {
        if (currentState == State.Idle)
        {
            currentState = State.PlayingScale
            sCollection?.setupSpecifiedScale(iinput: "MinorPentatonic")
            met?.startMetro()
        }
    }
    
    func killCurrentDotFade()
    {
        if dotFadeTime != nil {
            dotFadeTime?.invalidate()
            dotFadeTime = nil
        }
    }
    
    func displayMultipleFretMarkers(iinputArr: [String], ialphaAmount: Double)
    {
        killCurrentDotFade()
        for (str,_) in dotDict {
            dotDict[str]!.alpha = 0.0
           
            if (iinputArr.contains(str)) {
                UIView.animate(withDuration: 0.1, animations: {
                    self.dotDict[str]!.alpha = CGFloat(ialphaAmount)
                },completion: nil)
                
                swoopScale(iobject: self.dotDict[str]!,iscaleX: 0,iscaleY: 0,iduration: 0)
                swoopScale(iobject: self.dotDict[str]!,iscaleX: 1,iscaleY: 1,iduration: 0.1)
            }
        }
        allMarkersDisplayed = true
    }
    
    func hideAllFretMarkers()
    {
        if (allMarkersDisplayed) {
            killCurrentDotFade()
            for (str,_) in dotDict {
                dotDict[str]!.alpha = 0.0
            }
            allMarkersDisplayed = false
        }
    }
    
    func displaySingleFretMarker(iinputStr: String)
    {
        if previousNote != nil
        {
            dotDict[previousNote!]?.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.dotDict[self.previousNote!]?.alpha = 0.0
            },completion: nil)
            
        }
        previousNote = iinputStr
        
        dotDict[iinputStr]!.alpha = 0.0
        UIView.animate(withDuration: 0.1, animations: {
            self.dotDict[iinputStr]!.alpha = 1.0
        },completion: nil)
        
        killCurrentDotFade()
        
        swoopScale(iobject: self.dotDict[iinputStr]!,iscaleX: 0,iscaleY: 0,iduration: 0)
        swoopScale(iobject: self.dotDict[iinputStr]!,iscaleX: 1,iscaleY: 1,iduration: 0.1)
        
        dotFadeTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.alphaSwoopImage), userInfo: ["ImageId":iinputStr], repeats: false)
    }
    
    @objc func alphaSwoopImage(timer:Timer)
    {
        let image = timer.userInfo as! Dictionary<String, AnyObject>
        
        UIView.animate(withDuration: 0.2, animations: {
            self.dotDict[image["ImageId"] as! String]!.alpha = 0.0
        },completion: { _ in
            
        })
    }
    
    func swoopScale(iobject:UIView,iscaleX:Double,iscaleY:Double,iduration:Double)
    {
        UIView.animate(withDuration: iduration, animations: {() -> Void in
            iobject.transform = CGAffineTransform(scaleX: CGFloat(iscaleX), y: CGFloat(iscaleY))
        }, completion: nil)
    }
    
    func rand (max:Int) -> Int
    {
        return Int.random(in: 0 ..< max)
    }
    
    func presentEarTrainResults()
    {
        let resultText = earTrainCallArr == earTrainResponseArr ? "Good" : "Bad"
        ResultsLabel0.text = resultText
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.resetResultsLabel), userInfo: nil, repeats: false)
        earTrainCallArr.removeAll()
        earTrainResponseArr.removeAll()
        currentState = State.Idle
    }
    
    @objc func beginEarTrainingHelper(timer:Timer)
    {
        let argDict = timer.userInfo as! Dictionary<String, AnyObject>
        displaySelectionDots(inoteSelection: argDict["NoteSelection"] as! [String],ialphaAmount: argDict["AlphaVal"] as! Double)
        met?.startMetro()
    }
    
    func displaySelectionDots (inoteSelection:[String], ialphaAmount:Double)
    {
        for (_,item) in inoteSelection.enumerated() {
            dotDict[item]?.alpha = CGFloat(ialphaAmount)
        }
    }
    
    @objc func resetResultsLabel()
    {
//        ResultsLabel0.text = ""
         ResultsLabel1.text = ""
    }
}

