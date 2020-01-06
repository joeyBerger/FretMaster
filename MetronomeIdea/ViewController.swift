//
//  Metronome.swift
//  MetronomeIdea
//
//  Created by Alex Shubin on 26.03.17.
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import UIKit
import AMPopTip

extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.bounds.contains(point) ? self : nil
    }
    func blink(enabled: Bool = true, duration: CFTimeInterval = 1.0, stopAfter: CFTimeInterval = 0.0 ) {
        enabled ? (UIView.animate(withDuration: duration, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.15
        pulse.fromValue = 0.95
        pulse.toValue = 1.3
        pulse.autoreverses = true
        pulse.repeatCount = 0;
        pulse.initialVelocity = 10.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    

       
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
    
    @IBOutlet var mainPopover: UIView!
    @IBOutlet weak var mainPopoverCloseButton: UIButton!
    @IBOutlet weak var mainPopoverBodyText: UILabel!
    @IBOutlet weak var mainPopoverTitle: UILabel!
    @IBOutlet weak var mainPopoverButton: UIButton!
    
    @IBOutlet var tutorialPopover: UIView!
    
    
    @IBOutlet weak var DimOverlay: UIImageView!
    @IBOutlet weak var OverlayButton: UIButton!

    
    @IBOutlet weak var PeripheralStackView: UIStackView!
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
    @IBOutlet weak var GS1Button: UIButton!
    
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
    var noteCollectionTestData : [InputData] = []
    var earTrainCallArr: [String] = []
    var earTrainResponseArr: [String] = []
    
    var defaultPeripheralIcon: [String] = []
    var activePeripheralIcon: [String] = []
    
    var tutorialPopupText: [String] = []
    var currentTutorialPopup = 0
    
    var developmentMode = true
    
    let timeThreshold : [String:Double] = [
        "Easy": 0.1,
        "Medium": 0.075,
        "Hard": 0.05
    ]
    
    var specifiedNoteCollection : [String] = []
    let tempScale : [String] = ["A1","C2","D2","E2","G2"]
        
    var resultViewStrs : [String] = []
    var currentResultView = 0
    
    let sc = SoundController(isubInstances: 10)
    let click = SoundController(isubInstances: 10)
    var met : Metronome? = nil
    var sCollection : ScaleCollection? = nil
    var et : EarTraining? = nil
    var pc : PopupController? = nil
    var wt = waitThen();
    
    var tempoButtonsActive = false
    var tutorialActive = false
    var mainPopoverVisible = false
    var tempoActive = false
    var tempoUpdaterCycle = 0.0
    var tempoButtonArr: [UIButton]? = []
    
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
    
    let layerArr = [
        "Default",
        "TutorialButton"
    ]
    
    enum State {
        case Idle
        case RecordingIdle
        case Recording
        case Playback
        
        case EarTrainCall
        case EarTrainResponse
        
        case PlayingNoteCollection
        

        case ScaleTestIdle_NoTempo
        case ScaleTestActive_NoTempo
        
        case ScaleTestCountIn_Tempo
        case ScaleTestActive_Tempo
        case ScaleTestIdle_Tempo
        
        
        case ArpeggioTestIdle_NoTempo
        case ArpeggioTestActive_NoTempo
        
        case ArpeggioTestCountIn_Tempo  //still need to do this
        case ArpeggioTestActive_Tempo
        case ArpeggioTestIdle_Tempo
        
        case ScaleTestShowNotes
        case ArpeggioTestShowNotes
//        case ScaleTestResult
    }
    
    var currentState = State.Idle
    var allMarkersDisplayed = false
    var defaultState : State?
    var currentLevel: String?
    var currentLevelConstruct: [[String]] = [[]]
    var currentLevelKey: String?
    var tutorialComplete: Bool?
    let digitInput = DigitsInput()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = defaultColor.BackgroundColor
        
        met = Metronome(ivc: self)
        sCollection = ScaleCollection(ivc: self)
        et = EarTraining(ivc: self)
        pc = PopupController(ivc: self)
        
        if (developmentMode) {
            met?.bpm = 350.0
            print("butt")
        }
            
        BPM_textField.text = String(Int(met!.bpm))
        BPM_textField.isHidden = true
        
        self.digitInput.vc = self
        self.BPM_textField.delegate = self.digitInput
        
        ResultsLabel0.text = ""
        ResultsLabel1.text = ""
        
        ResultsLabel0?.adjustsFontSizeToFitWidth = true
        ResultsLabel1?.adjustsFontSizeToFitWidth = true
        
        ResultsLabel0?.textColor = defaultColor.MenuButtonTextColor
        
        mainPopover.layer.cornerRadius = 10
        
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
        
        mainPopover.backgroundColor = defaultColor.MenuButtonColor
        mainPopoverCloseButton.tintColor = defaultColor.MenuButtonTextColor
        mainPopoverBodyText.textColor = defaultColor.MenuButtonTextColor
        mainPopoverBodyText.contentMode = .scaleToFill
        mainPopoverBodyText.numberOfLines = 0
        
        mainPopoverTitle.textColor = defaultColor.MenuButtonTextColor
        mainPopoverButton.setTitleColor(.white, for: .normal)
        mainPopoverButton.backgroundColor = UIColor.red
                    
        periphButtonArr.append(PeriphButton0)
        periphButtonArr.append(PeriphButton1)
        periphButtonArr.append(PeriphButton2)
        periphButtonArr.append(PeriphButton3)
        periphButtonArr.append(PeriphButton4)
        periphButtonArr.append(PeriphButton5)
        
        DimOverlay.alpha = 0.0
        
        setupToSpecificState()
        
        if (!tutorialComplete!) {
            hideAllFretMarkers()
            wt.waitThen(itime: 0.2, itarget: self, imethod: #selector(self.presentMainPopover) as Selector, irepeats: false, idict: ["arg1": 0 as AnyObject])
            setupPopupTutorialText()
        }
        
        //setup long pressed recognizers
        let recognizer0 = UILongPressGestureRecognizer(target: self, action: #selector(tempoButtonLongPressed))
        TempoUpButton.addGestureRecognizer(recognizer0)
        recognizer0.view?.tag = 0
        
        let recognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(tempoButtonLongPressed))
        TempoDownButton.addGestureRecognizer(recognizer1)
        recognizer1.view?.tag = 1
        
        tempoButtonArr = [TempoUpButton,TempoDownButton]
        
        
//        var image = UIImageView()
//        image.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        image.backgroundColor = UIColor.red
//        image.layer.masksToBounds = true
//        image.layer.cornerRadius = image.frame.width/2
//
//        let noteLabel = UILabel()
//        let xVal = 2 > 1 ? 7.5 : 11.5
//        noteLabel.frame = CGRect(x: 0,y: 0,width: 40, height: 40)
//        noteLabel.textAlignment = NSTextAlignment.center
//        noteLabel.text = "C#";  //"C"
//        noteLabel.layer.zPosition = 1;
//
//        image.addSubview(noteLabel)
//        GS1Button.addSubview(image)
        
        
//        let image = UIImage(named: "name") as UIImage?
//        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
//        button.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
//        var image = UIImageView()
//        image.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
//        button.addSubview(image)
        
//        let img = UIImage()
//        img.withTintColor(<#T##color: UIColor##UIColor#>)
//        let myButton = UIButton(type: UIButton.ButtonType.custom)
//        myButton.frame = CGRect.init(x: 420, y: -500, width: 100, height: 45)
//        myButton.setImage(img, for: .normal)
////        myButton.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControl.Event.touchUpInside)
//        self.view.addSubview(myButton)
        
        let newFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let button = UIButton(frame: newFrame)
        button.backgroundColor = UIColor.red
//        button.setImage(image, for: .normal)
//        image. = UIColor.red
//        button.addTarget(self, action: "btnTouched:", forControlEvents:.touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func tempoButtonLongPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            wt.stopWaitThenOfType(iselector: #selector(self.tempoButtonUpdater) as Selector)
            tempoUpdaterCycle = 0.0
        } else if sender.state == .began {
            wt.waitThen(itime: 0.02, itarget: self, imethod: #selector(self.tempoButtonUpdater) as Selector, irepeats: true, idict: ["arg1": sender.view!.tag as AnyObject])
        } else if sender.state == .changed {
            
        }
    }
    
    let tempoHoldTimeThresholds = [1.2,3.0,4.5]
    @objc func tempoButtonUpdater(timer:Timer) {
        tempoUpdaterCycle += 1.0
        let resultObj = timer.userInfo as! Dictionary<String, AnyObject>
        let dir = resultObj["arg1"] as! Int == 0 ? 1 : -1
        let tempoUpdaterThrehold = 5
        var mult = 1.0
        
        if (tempoUpdaterCycle > 0 && Int(tempoUpdaterCycle)%tempoUpdaterThrehold == 0)
        {
            if (tempoUpdaterCycle >= tempoHoldTimeThresholds[tempoHoldTimeThresholds.count-1] * 50) {
                 mult = 30.0
            } else if (tempoUpdaterCycle >= tempoHoldTimeThresholds[tempoHoldTimeThresholds.count-2] * 50) {
                if (tempoUpdaterCycle == tempoHoldTimeThresholds[tempoHoldTimeThresholds.count-2] * 50) {
                    met!.bpm = ((met!.bpm/10.0).rounded(.up)) * 10.0
                }
                mult = 10.0
            } else if (tempoUpdaterCycle >= tempoHoldTimeThresholds[0] * 50) {
                if (tempoUpdaterCycle == tempoHoldTimeThresholds[0] * 50) {
                    var parsedTempo = met!.bpm/10.0
                    if (parsedTempo > parsedTempo.rounded()) {
                        parsedTempo = parsedTempo.rounded()+0.5
                    } else {
                        parsedTempo = parsedTempo.rounded()
                    }
                    met!.bpm = parsedTempo*10.0
                }
                mult = 5.0
            }
            met!.bpm = met!.bpm + Double(dir)*mult
            TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        }
    }
    
    func setStateProperties (icurrentState: State, itempoButtonsActive: Bool, icurrentLevel: String, ilevelConstruct: [[String]], ilevelKey: String, itutorialComplete: String = "1.0") {
        currentState = icurrentState
        defaultState = currentState
//        tempoButtonsActive = itempoButtonsActive
        currentLevel = icurrentLevel
        currentLevelConstruct = ilevelConstruct
        currentLevelKey = ilevelKey
        print("itutorialComplete \(itutorialComplete)")
        tutorialComplete = itutorialComplete == "1.0"
    }
    
    func setupToSpecificState () {
        print("setupToSpecificState \(currentState)")
        
        if (currentState == State.RecordingIdle) {
            setButtonState(ibutton : PeriphButton0,ibuttonState : false)
        }
        //Scale/Arpeggio test
        if (currentState == State.ScaleTestIdle_NoTempo || currentState == State.ArpeggioTestIdle_NoTempo) {
            setupCurrentTask()
            defaultPeripheralIcon = ["play","music.note","info"]
            activePeripheralIcon = ["pause","arrowshape.turn.up.left","arrowshape.turn.up.left"]
//            setupTempoButtons(ibuttonsActive: tempoButtonsActive)
            displayMultipleFretMarkers(iinputArr: specifiedNoteCollection, ialphaAmount: 1.0)
        }
        setupPeripheralButtons(iiconArr : defaultPeripheralIcon)
    }
    
    func setupCurrentTask () {
        let task = returnCurrentTask()
        let trimmedTask = trimCurrentTask(iinput: task)
        let dir = parseTaskDirection(iinput: task)
        tempoActive = parseTempoStatus(iinput: task)
        tempoButtonsActive = !tempoActive
        setupTempoButtons(ibuttonsActive: tempoButtonsActive)
        sCollection!.setupSpecifiedScale(iinput: trimmedTask, idirection: dir)
//        setupFretMarkerText(ishowAlphabeticalNote: false, ishowNumericDegree: true)
        ResultsLabel0.text = sCollection!.returnReadableScaleName(iinput: trimmedTask)
        
        
        let resultPopoverDirText : String
        var resultPopoverTempoText = "Tempo: "
        var resultButtonText = ""
        
        if (dir == "Up") {
            resultPopoverDirText = "Play From Low To High Note"
            resultButtonText = "Up"
        } else if (dir == "Down") {
            resultPopoverDirText = "Play From High To Low Note"
            resultButtonText = "Down"
        } else {
            resultPopoverDirText = "Play From Low To High Note Back To Low"
            resultButtonText = "Up And Down"
        }
        
        resultButtonText += " / "
        
        if (!tempoActive) {
            resultPopoverTempoText += "None, Play Freely!"
            resultButtonText += "No Tempo"
        } else {
            let tempo = String(met!.bpm) + " BPM"
            resultPopoverTempoText += tempo
            resultButtonText += tempo
        }
        
        pc!.setResultButtonPopupText(itextArr: [ResultsLabel0.text!,resultPopoverDirText,resultPopoverTempoText])
        
        ResultButton1.setTitle(resultButtonText, for: .normal)
    }
        
    func returnCurrentTask() -> String {
        let level = returnConvertedLevel(iinput: currentLevel!)
        let subLevel = returnConvertedSubLevel(iinput: currentLevel!)
        
        //make sure the current level/sublevel is not out of range
        if (currentLevelConstruct[level].count > subLevel) {
            return currentLevelConstruct[level][subLevel]
        }
        
        //level/sublevel is out of range, return last task in construct
        return currentLevelConstruct[level][currentLevelConstruct[level].count-1]
    }
    
    
    func trimCurrentTask(iinput: String) -> String {
        let signifiers = ["Up","Tempo"]
        var modifiedStr = iinput
        if (modifiedStr.contains("_")) {
            for (_,str) in signifiers.enumerated() {
                if (modifiedStr.contains(str)) {
                    modifiedStr = modifiedStr.replacingOccurrences(of: "_"+str, with: "")
                    print(modifiedStr)
                }
            }
        }
        return modifiedStr
    }
    
    func parseTaskDirection(iinput: String) -> String {
        let signifiers = ["Up","Down","Both"]
        var dir = ""
        for (_,str) in signifiers.enumerated() {
            if (iinput.contains(str)) {
                dir = str
                break
            }
        }
        return dir
    }
    
    func parseTempoStatus(iinput: String) -> Bool {
        return iinput.contains("Tempo")
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
            if (i < iiconArr.count) {
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }
    
    func restorePeriphButtonsToDefault (idefaultIcons: [String]) {
        for (i, _) in idefaultIcons.enumerated() {
            setButtonImage(ibutton: periphButtonArr[i], iimageStr: idefaultIcons[i])
        }
    }
    
    func setupTempoButtons(ibuttonsActive : Bool) {
        var buttonColor : UIColor
        var inlayColor : UIColor
        if (ibuttonsActive) {
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

            let noteLabel = UILabel()
            let xVal = note.count > 1 ? 7.5 : 11.5
            noteLabel.frame = CGRect(x: xVal,y: -22.5,width: 80,height: 80)
            noteLabel.textAlignment = NSTextAlignment.natural
            noteLabel.text = note;  //"C"
            noteLabel.layer.zPosition = 1;
            buttonNote[str] = noteLabel
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
                noteCollectionTestData[noteCollectionTestData.count-1].time = userInputTime
                noteCollectionTestData[noteCollectionTestData.count-1].timeDelta = timeDelta
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
        tempoButtonArr![sender.tag].pulsate()
        pc!.resultButtonPopup.hide()
        let dir = sender.tag == 0 ? 1.0 : -1.0
        met!.bpm = met!.bpm + dir
        TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        tapTime.removeAll()
    }
    
    var tapTime: [Double] = []
    var currentTapTempo = 0.0
    @IBAction func tempoTapped(_ sender: Any) {
        wt.stopWaitThenOfType(iselector: #selector(self.timeoutTapTempo) as Selector)
        wt.waitThen(itime: 1.2, itarget: self, imethod: #selector(self.timeoutTapTempo) as Selector, irepeats: false, idict: ["arg1": 0 as AnyObject])
        tapTime.append(CFAbsoluteTimeGetCurrent())
        if (tapTime.count > 1) {
            let tappedCount = Double(tapTime.count-1)
            var accTime = 0.0
            for (i,_) in tapTime.enumerated() {
                if (i > 0) {
                    accTime += tapTime[i]-tapTime[i-1]
                }
            }
            met!.bpm = ((tappedCount/accTime)*60).rounded()
            TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        }
    }
    
    @objc func timeoutTapTempo() {
        print("timeoutTapTempo")
        tapTime.removeAll()
    }
    
    @IBAction func startMetronome(_ sender: Any) {
        met?.startMetro()
    }
    
    func handleTutorialInput(iwchButton: Int) -> Bool {
        if (mainPopoverVisible) {
            return false;
        }
        
        if (tutorialActive && currentTutorialPopup == iwchButton + 1) {
            progressTutorial()
            return false;
        }
        return true
    }
    
    @IBAction func PeripheralButtonDown(_ sender: UIButton) {
        pc!.resultButtonPopup.hide()
//        periphButtonArr[sender.tag].blink()
//        periphButtonArr[sender.tag].showsTouchWhenHighlighted = true
//        periphButtonArr[sender.tag].imageView.sat
        
        periphButtonArr[sender.tag].pulsate()
        
        switch sender.tag {
        case 0:
            PeripheralButton0OnButtonDown()
            break
        case 1:
            PeripheralButton1OnButtonDown()
            break
        case 2:
            PeripheralButton2OnButtonDown()
            break
        case 3:
//            PeripheralButton3OnButtonDown()
            break
        default:
            break
        }
    }
    
    //Peripheral Buttons Down
    @IBAction func PeripheralButton0OnButtonDown() {
        let wchButton = 0
        
        if (!handleTutorialInput(iwchButton: wchButton)) {
            return
        }

        print("PeripheralButton0OnButtonDown \(currentState)")
       
        setPeripheralButtonsToDefault()
        let s = #selector(pc!.enactTestReminder) as Selector
        wt.stopWaitThenOfType(iselector: s)
        pc!.reminderPopup.hide()
               
        //Scale Test States
        if (currentState == State.ScaleTestIdle_NoTempo || currentState == State.ScaleTestShowNotes) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
            currentState = State.ScaleTestActive_NoTempo
            hideAllFretMarkers()
//            met?.currentClick = 0
//            scaleTestData.removeAll()
//            met?.startMetro()
            return
        }
        else if (currentState == State.ScaleTestActive_NoTempo) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
            currentState = State.ScaleTestIdle_NoTempo
            met!.endMetronome()
            ResultButton1.setTitle("", for: .normal)
            return
        }
        
        //Arpeggio Test States
        if (currentState == State.ArpeggioTestIdle_NoTempo || currentState == State.ArpeggioTestShowNotes) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
            currentState = State.ArpeggioTestActive_NoTempo
            hideAllFretMarkers()
    //            met?.currentClick = 0
    //            scaleTestData.removeAll()
    //            met?.startMetro()
            return
        }
        else if (currentState == State.ArpeggioTestActive_NoTempo) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
            currentState = State.ArpeggioTestIdle_NoTempo
            met!.endMetronome()
            ResultButton1.setTitle("", for: .normal)
            return
        }
    }
    
    @IBAction func PeripheralButton1OnButtonDown() {
        
        let wchButton = 1
        
        if (!handleTutorialInput(iwchButton: wchButton)) {
            return
        }
        
        print("PeripheralButton1OnButtonDown \(currentState)")
        
        
        //Scale Test States
        if (currentState == State.ScaleTestIdle_NoTempo) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
            currentState = State.PlayingNoteCollection
            met?.startMetro()
            hideAllFretMarkers()
            return
        } else if (currentState == State.PlayingNoteCollection) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
            currentState = State.ScaleTestIdle_NoTempo
            met?.endMetronome()
            return
        }
        
        //Arpeggio Test States
        if (currentState == State.ArpeggioTestIdle_NoTempo) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
            currentState = State.PlayingNoteCollection
            met?.startMetro()
            hideAllFretMarkers()
            return
        } else if (currentState == State.PlayingNoteCollection) {
            setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
            currentState = State.ArpeggioTestIdle_NoTempo
            met?.endMetronome()
            return
        }
    }
    
    @IBAction func PeripheralButton2OnButtonDown() {
        
        let wchButton = 2
        
        if (!handleTutorialInput(iwchButton: wchButton)) {
            return
        }
        
        print("PeripheralButton2OnButtonDown \(currentState)")
        
        
        //Scale Test States
        if (currentState == State.ScaleTestIdle_NoTempo || currentState == State.ScaleTestShowNotes) {
            if (currentState == State.ScaleTestIdle_NoTempo) {
                setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
                displayMultipleFretMarkers(iinputArr: specifiedNoteCollection, ialphaAmount: 1.0)
                currentState = State.ScaleTestShowNotes
                return
            }
            else if (currentState == State.ScaleTestShowNotes) {
                setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
                hideAllFretMarkers()
                currentState = State.ScaleTestIdle_NoTempo
                return
            }
        }
        
        //Arpeggio Test States
        if (currentState == State.ArpeggioTestIdle_NoTempo || currentState == State.ArpeggioTestShowNotes) {
            if (currentState == State.ArpeggioTestIdle_NoTempo) {
                setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: activePeripheralIcon[wchButton])
                displayMultipleFretMarkers(iinputArr: specifiedNoteCollection, ialphaAmount: 1.0)
                currentState = State.ArpeggioTestShowNotes
                return
            }
            else if (currentState == State.ArpeggioTestShowNotes){
                setButtonImage(ibutton: periphButtonArr[wchButton], iimageStr: defaultPeripheralIcon[wchButton])
                hideAllFretMarkers()
                currentState = State.ArpeggioTestIdle_NoTempo
                return
            }
        }
    }
    
    
    @IBAction func ResultButtonDown(_ sender: Any) {
        
        print("currentState \(currentState)")
        
        pc!.showResultButtonPopup()
        
//        if (!resultViewStrs.isEmpty)
//        {
//            ResultButton1.setTitle(resultViewStrs[currentResultView], for: .normal)
//            currentResultView = (currentResultView + 1)%resultViewStrs.count
//        }
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
        pc!.resultButtonPopup.hide()
        var tutorialDisplay = false
        var inputNumb = sender.tag
        if (inputNumb >= 100) {
            inputNumb -= 100
            tutorialDisplay = true
        }
        
        if (tutorialActive || mainPopoverVisible) {
            if (currentTutorialPopup < 4 && !tutorialDisplay) {
                return
            } else if (!tutorialDisplay) {
                if (buttonDict[inputNumb] != specifiedNoteCollection[currentTutorialPopup-(defaultPeripheralIcon.count+1)]) {
                    return
                }
                progressTutorial()
            }
        }
        print("in fret pressed state \(currentState)")
        
        let validState = returnValidState(iinputState: currentState, istateArr: [State.Recording, State.Idle, State.EarTrainResponse, State.ScaleTestActive_NoTempo, State.ScaleTestCountIn_Tempo, State.ScaleTestIdle_NoTempo, State.ScaleTestShowNotes, State.ArpeggioTestCountIn_Tempo, State.ArpeggioTestActive_Tempo, State.ArpeggioTestIdle_NoTempo, State.ArpeggioTestShowNotes, State.ArpeggioTestActive_NoTempo])
        if (validState)
        {
            hideAllFretMarkers()
            if (currentState == State.ScaleTestShowNotes) {
                
                currentState = State.ScaleTestIdle_NoTempo
//                PeriphButton1.setTitle("Show Scale", for: .normal)
            }
            
            
            sc.playSound(isoundName: buttonDict[inputNumb]!)
            displaySingleFretMarker(iinputStr: buttonDict[inputNumb]!, cascadeFretMarkers: tutorialActive)
            if (currentState == State.Recording)
            {
                if (recordStartTime == 0)
                {
                    recordStartTime = CFAbsoluteTimeGetCurrent()
                }
                let r = InputData()
                r.time = CFAbsoluteTimeGetCurrent()
                r.note = buttonDict[inputNumb]!
                recordData.append(r)
            }
            if (currentState == State.EarTrainResponse)
            {
                earTrainResponseArr.append(buttonDict[inputNumb]!)
                if (earTrainResponseArr.count == earTrainCallArr.count)
                {
                    presentEarTrainResults()
                }
            }
            
            if (currentState == State.ScaleTestActive_Tempo) {
                let st = InputData()
                st.note = buttonDict[inputNumb]!
                st.time = 0
                noteCollectionTestData.append(st)
                recordTimeAccuracy()
            }
            
            if (currentState == State.ScaleTestActive_NoTempo || currentState == State.ArpeggioTestActive_NoTempo) {
                let st = InputData()
                st.note = buttonDict[inputNumb]!
                st.time = 0
                noteCollectionTestData.append(st)
                if (noteCollectionTestData.count == specifiedNoteCollection.count || developmentMode) {
                    currentState = State.ScaleTestIdle_NoTempo
                    restorePeriphButtonsToDefault(idefaultIcons: defaultPeripheralIcon)
                    let scaleCorrect = sCollection!.analyzeScale(iscaleTestData: noteCollectionTestData)
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
        }

        var resultsText = ""
        resultsText =  testPassed ? "Great!" : "Try Again!"
        resultViewStrs.append(resultsText)
        ResultButton1.setTitle(resultViewStrs[0], for: .normal)
        
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
//        if (currentState == State.Idle)
//        {
//            currentState = State.PlayingNoteCollection
//            sCollection?.setupSpecifiedScale(iinput: "MinorPentatonic")
//            met?.startMetro()
//        }
    }
    
    func killCurrentDotFade()
    {
        if dotFadeTime != nil {
            dotFadeTime?.invalidate()
            dotFadeTime = nil
        }
    }
    
    func displayMultipleFretMarkers(iinputArr: [String], ialphaAmount: Float)
    {
        killCurrentDotFade()
        for (str,_) in dotDict {
            dotDict[str]!.alpha = 0.0
           
            if (iinputArr.contains(str)) {
//                UIView.animate(withDuration: 0.1, animations: {
//                    self.dotDict[str]!.alpha = CGFloat(ialphaAmount)
//                },completion: nil)
                
                swoopAlpha(iobject: self.dotDict[str]!, ialpha: Float(ialphaAmount), iduration: 0.1)
                swoopScale(iobject: self.dotDict[str]!,iscaleX: 0,iscaleY: 0,iduration: 0)
                swoopScale(iobject: self.dotDict[str]!,iscaleX: 1,iscaleY: 1,iduration: 0.1)
            }
        }
        
//        for (i,str) in defaultPeripheralIcon.enumerated() {
//            if (str == "info") {
//                setButtonImage(ibutton: periphButtonArr[i], iimageStr: activePeripheralIcon[i])
//                break
//            }
//        }
        
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
    
    func displaySingleFretMarker(iinputStr: String, cascadeFretMarkers: Bool = false)
    {
        if (previousNote != nil && !cascadeFretMarkers)
        {
            dotDict[previousNote!]?.alpha = 0.0
//            UIView.animate(withDuration: 0.3, animations: {
//                self.dotDict[self.previousNote!]?.alpha = 0.0
//            },completion: nil)
            
            swoopAlpha(iobject: dotDict[previousNote!]!, ialpha: Float(0.0), iduration: 0.3)
        }
        previousNote = iinputStr
        
        dotDict[iinputStr]!.alpha = 0.0
//        UIView.animate(withDuration: 0.1, animations: {
//            self.dotDict[iinputStr]!.alpha = 1.0
//        },completion: nil)
        
        swoopAlpha(iobject: dotDict[iinputStr]!, ialpha: Float(1.0), iduration: 0.1)
        killCurrentDotFade()
        swoopScale(iobject: dotDict[iinputStr]!,iscaleX: 0,iscaleY: 0,iduration: 0)
        swoopScale(iobject: dotDict[iinputStr]!,iscaleX: 1,iscaleY: 1,iduration: 0.1)
        
        if (!cascadeFretMarkers) {
            dotFadeTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.alphaSwoopImage), userInfo: ["ImageId":iinputStr], repeats: false)
        }
    }
    
    @objc func alphaSwoopImage(timer:Timer)
    {
        let image = timer.userInfo as! Dictionary<String, AnyObject>
        
//        UIView.animate(withDuration: 0.2, animations: {
//            self.dotDict[image["ImageId"] as! String]!.alpha = 0.0
//        },completion: { _ in
//
//        })
        
        swoopAlpha(iobject: dotDict[image["ImageId"] as! String]!, ialpha: Float(0.0), iduration: 0.2)
    }
    
    func swoopScale(iobject:UIView,iscaleX:Double,iscaleY:Double,iduration:Double) {
        UIView.animate(withDuration: iduration, animations: {() -> Void in
            iobject.transform = CGAffineTransform(scaleX: CGFloat(iscaleX), y: CGFloat(iscaleY))
        }, completion: nil)
    }
    
    func swoopAlpha(iobject: UIImageView, ialpha: Float, iduration: Float) {
        UIView.animate(withDuration: TimeInterval(iduration), animations: {
            iobject.alpha = CGFloat(ialpha)
        },completion: nil)
    }
    
    func rand (max:Int) -> Int {
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
    
    @IBAction func closeMainPopover(_ sender: Any) {
        mainPopover.removeFromSuperview()
        if (tutorialActive) {
            progressTutorial()
        } else {
            allMarkersDisplayed = true
            swoopAlpha(iobject: DimOverlay, ialpha: 0, iduration: 0.3)
            pc!.startTestReminder(itime: 20)
            
            var tutorialComplete = UserDefaults.standard.object(forKey: "tutorialComplete")
            tutorialComplete = tutorialComplete as! String == "0.0" ? "1.0" : "2.0"
            UserDefaults.standard.set(tutorialComplete, forKey: "tutorialComplete")
        }
        
        mainPopoverVisible = false
//        tutorialActive = false
    }
    
    
    @IBAction func testButton(_ sender: Any) {
//        presentMainPopover()
        
        pc!.setResultButtonPopupText(itextArr: ["amigo","friend"])
        pc!.showResultButtonPopup()
    }
    
    @objc func presentMainPopover() {
        //https://www.youtube.com/watch?v=qS21yjo822Y
        swoopAlpha(iobject: DimOverlay, ialpha: 0.8, iduration: 0.3)
        view.addSubview(mainPopover)
        mainPopover.center = view.center
//        mainPopover.center.y += -100
        mainPopoverVisible = true
        tutorialActive = !tutorialActive
    }
    
    func progressTutorial() {
        pc!.tutorialPopup.hide()
        print("hiding")
        let peripheralButtonTutorialNumb = defaultPeripheralIcon.count
        if (currentTutorialPopup == tutorialPopupText.count) {
            swoopAlpha(iobject: DimOverlay, ialpha: 0.0, iduration: 0.15)
            tutorialActive = false
            periphButtonArr[defaultPeripheralIcon.count-1].layer.zPosition = getLayer(ilayer: "Default")
            pc!.startTestReminder(itime: 20)
            return;
        }
        for i in  0..<peripheralButtonTutorialNumb {
            setLayer(iobject: periphButtonArr[i], ilayer: "Default")
        }
        
        //peripheral button popups
        var parentType = ""
        if (currentTutorialPopup < peripheralButtonTutorialNumb) {
            setLayer(iobject: periphButtonArr[currentTutorialPopup], ilayer: "TutorialButton")
            parentType = "PeripheralButton"
  
        } else if (currentTutorialPopup < tutorialPopupText.count-1) {
            //show starting note
            let buttonStr = specifiedNoteCollection[currentTutorialPopup - peripheralButtonTutorialNumb]
            
            
            
            for (_,dot) in specifiedNoteCollection.enumerated() {
                setLayer(iobject: dotDict[dot]!, ilayer: "Default")
            }

            setLayer(iobject: dotDict[buttonStr]!, ilayer: "TutorialButton")
            parentType = buttonStr + "Fret"
            print("setting button")
            let button = UIButton()
            button.tag = buttonDict.filter{$1 == buttonStr}.map{$0.0}[0] + 100
            
            FretPressed(button)
        } else {
            if (developmentMode) {
                pc!.tutorialPopup.hide()
            }
            for (_,dot) in specifiedNoteCollection.enumerated() {
                setLayer(iobject: dotDict[dot]!, ilayer: "Default")
            }
            pc!.tutorialPopup.hide()
            mainPopoverBodyText.font = mainPopoverBodyText.font.withSize(35)
            mainPopoverBodyText.text = tutorialPopupText[tutorialPopupText.count-1]
            wt.waitThen(itime: 0.2, itarget: self, imethod: #selector(self.presentMainPopover) as Selector, irepeats: false, idict: ["arg1": 0 as AnyObject])
            return
        }
        wt.waitThen(itime: 0.2, itarget: self, imethod: #selector(self.presentTutorialPopup) as Selector, irepeats: false, idict: ["arg1": currentTutorialPopup as AnyObject, "arg2": parentType as AnyObject])

        currentTutorialPopup += 1
        print("currentTutorialPopup \(currentTutorialPopup)")
    }
    
    @IBAction func OverlayButtonFunc(_ sender: Any) {
        print("i might need help")
    }
    
    
    func returnStackViewButtonCoordinates(istackViewButton: UIButton, istack: UIStackView, ixoffset: CGFloat = 0.0, iyoffset: CGFloat = 0.0) -> CGRect {

        let spacing = istack.arrangedSubviews[1].frame.minY - istack.arrangedSubviews[0].frame.minY
        let minX = istack.frame.minX + ixoffset
        let minY = istack.frame.minY - CGFloat(spacing) + istackViewButton.frame.height/2 + istackViewButton.frame.minY + iyoffset
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
                             "Tutorial Complete!"
                            ]
    }

    func setLayer(iobject: AnyObject, ilayer: String) {
        if #available(iOS 13.0, *) {
            iobject.layer.zPosition = getLayer(ilayer: ilayer)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getLayer(ilayer: String) -> CGFloat {
        let layer = layerArr.firstIndex(of: ilayer)
        if (layer != nil) {
            return CGFloat(layer!)
        }
        print("layer does not exist")
        return 0
    }
    
    @objc func presentTutorialPopup (timer:Timer) {
        
        let argDict = timer.userInfo as! Dictionary<String, AnyObject>
        let wchPopup = argDict["arg1"] as! Int
        let popupObjectParentType = argDict["arg2"] as! String
        if (popupObjectParentType == "PeripheralButton") {
            let c = returnStackViewButtonCoordinates(istackViewButton: periphButtonArr[wchPopup], istack: PeripheralStackView, iyoffset: -25)
            pc!.tutorialPopup.show(text: tutorialPopupText[wchPopup], direction: .left, maxWidth: 200, in: view, from: c)
        } else if (popupObjectParentType.contains("Fret")) {
            let buttonStr = popupObjectParentType.replacingOccurrences(of: "Fret", with: "")
            pc!.tutorialPopup.show(text: tutorialPopupText[wchPopup], direction: .left, maxWidth: 200, in: view, from: dotDict[buttonStr]!.frame)
        } else {
            print("got here")
            pc!.tutorialPopup.shouldDismissOnTap = true
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            let center = UIView(frame: CGRect(x: screenWidth/2, y: screenHeight/2, width: 0, height: 0))
            pc!.tutorialPopup.show(text: tutorialPopupText[wchPopup], direction: .none, maxWidth: 700, in: view, from: center.frame)
        }

    }
    

    
    
    //TODO: blurred functionality that you can simply parent to the dimOverlay, or like-minded object
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
    
    func toggleDevMode () {
        developmentMode = !developmentMode
    }
}

class PopupController {
    
    let vc : ViewController?
    let tutorialPopup = PopTip()
    let reminderPopup = PopTip()
    let resultButtonPopup = PopTip()
    var resultButtonView: UIView? = nil
    var resultButtonPopupVisible = false
    
    init (ivc:ViewController) {
        vc = ivc;
        
        tutorialPopup.textColor = UIColor.white
        tutorialPopup.bubbleColor = UIColor.red
        tutorialPopup.shouldDismissOnTap = false
        tutorialPopup.shouldDismissOnTapOutside = false
        tutorialPopup.animationOut = 0.15
        tutorialPopup.layer.zPosition = 2.0
        
        reminderPopup.textColor = UIColor.blue
        reminderPopup.bubbleColor = UIColor.red
//        reminderPopup.shouldDismissOnTap = false
//        reminderPopup.shouldDismissOnTapOutside = false
        
        resultButtonPopup.textColor = UIColor.white
        resultButtonPopup.bubbleColor = UIColor.red
        resultButtonPopup.layer.zPosition = 2.0
        resultButtonPopup.dismissHandler = { resultButtonPopup in
            self.resultButtonPopupVisible = false
        }
        resultButtonPopup.appearHandler = { resultButtonPopup in
            self.resultButtonPopupVisible = true
        };
    }
    
    
    @objc func startTestReminder(itime: Double) {
        
        vc!.wt.waitThen(itime: itime, itarget: self, imethod: #selector(self.enactTestReminder) as Selector, irepeats: false, idict: ["arg1": 0 as AnyObject])

    }
    
    @objc func enactTestReminder (timer:Timer) {
        let c = vc!.returnStackViewButtonCoordinates(istackViewButton: vc!.periphButtonArr[0], istack: vc!.PeripheralStackView, iyoffset: -25)
        reminderPopup.show(text: "Start Test When Ready!", direction: .left, maxWidth: 200, in: vc!.view, from: c)
    }
    
    func setResultButtonPopupText(itextArr: [String]) {
        let textSpacing = 30
        let popoverSize = (vc!.returnStackViewButtonCoordinates(istackViewButton: vc!.PeriphButton0, istack: vc!.PeripheralStackView).maxX - vc!.TempoDownButton.frame.maxX)*0.72
        resultButtonView?.removeFromSuperview()
        resultButtonView = UIView(frame: CGRect(x: 0, y: 0, width: Int(popoverSize), height: itextArr.count*textSpacing))
        
        for (i,_) in itextArr.enumerated() {
            let popoverText = UILabel()
            popoverText.frame = CGRect(x: 0,y: i*textSpacing,width: Int(popoverSize),height: textSpacing)
            popoverText.textAlignment = NSTextAlignment.center
            popoverText.text = itextArr[i];
            popoverText.layer.zPosition = 2.0;
            popoverText.textColor = UIColor.white
            resultButtonView!.addSubview(popoverText)
        }
    }
    
    func showResultButtonPopup () {
        if (!resultButtonPopupVisible) {
            var mid = vc!.ResultButton1.frame
            mid = mid.offsetBy(dx: 0.0, dy: 10.0)
            resultButtonPopup.show(customView: resultButtonView!, direction: .down, in: vc!.view, from: mid)
        }
    }
}

    
    


