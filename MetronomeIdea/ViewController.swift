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
    @IBOutlet weak var NavBackButton: UIBarButtonItem!
    @IBOutlet weak var NavSettingsButton: UIBarButtonItem!
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
    var sClass : ScaleClass? = nil
    var et : EarTraining? = nil
    
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
        case ScaleTestCountIn
        case ScaleTestActive
        case ScaleTestIdle
        case ScaleTestShowScale
//        case ScaleTestResult
    }
    
    var currentState = State.Idle
    let digitInput = DigitsInput()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = defaultColor.BackgroundColor
        
        met = Metronome(ivc: self)
        sClass = ScaleClass(ivc: self)
        et = EarTraining(ivc: self)
        
        BPM_textField.text = String(Int(met!.bpm))
        
        self.digitInput.vc = self
        self.BPM_textField.delegate = self.digitInput
        
        ResultsLabel0.text = ""
        ResultsLabel1.text = ""
        
        ResultsLabel0?.adjustsFontSizeToFitWidth = true
        ResultsLabel1?.adjustsFontSizeToFitWidth = true
        
        for (str, view) in dotDict {
            //view.isHidden = true
            view.alpha = 0
            
            let note = str.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789"))

            let scrollView = UILabel()
            let xVal = note.count > 1 ? 7.5 : 11.5
            scrollView.frame = CGRect(x: xVal,y: -22.5,width: 80,height: 80)
            scrollView.textAlignment = NSTextAlignment.natural
            scrollView.text = note;  //"C"
            scrollView.layer.zPosition = 1;

            buttonNote[str] = scrollView
            dotDict[str]!.addSubview(buttonNote[str]!)
        }
        
        
        NavBar.barTintColor = defaultColor.MenuButtonColor

        NavBackButton.tintColor = defaultColor.MenuButtonTextColor
        NavSettingsButton.tintColor = defaultColor.MenuButtonTextColor
        
        
        TempoButton.backgroundColor = defaultColor.MenuButtonColor
        TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
        TempoButton.setTitleColor(defaultColor.MenuButtonTextColor, for: .normal)
        
        
        TempoDownButton.contentVerticalAlignment = .fill
        TempoDownButton.contentHorizontalAlignment = .fill
        TempoDownButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        TempoDownButton.backgroundColor = defaultColor.MenuButtonColor
        //arrow color
        TempoDownButton.imageView?.tintColor = defaultColor.AlternateButtonInlayColor
        
        TempoUpButton.contentVerticalAlignment = .fill
        TempoUpButton.contentHorizontalAlignment = .fill
        TempoUpButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        TempoUpButton.backgroundColor = defaultColor.MenuButtonColor
        //arrow color
        TempoUpButton.imageView?.tintColor = defaultColor.AlternateButtonInlayColor
        
        ResultButton1.titleLabel?.adjustsFontSizeToFitWidth = true
        ResultButton1.setTitleColor(.black, for: .normal)
        ResultButton1.setTitle("", for: .normal)
        ResultButton1.titleLabel?.adjustsFontSizeToFitWidth = true
        ResultButton1.titleLabel?.minimumScaleFactor = 0.5
//        ResultButton1.titleLabel?.numberOfLines = 0
        
        result1ViewStrs.append("Try Again!")
        result1ViewStrs.append("Not Enough Notes")
        result1ViewStrs.append("Try!")
        result1ViewStrs.append("NOTES : INCORRECT")
        
        
        print ("appending")
        periphButtonArr.append(PeriphButton0)
        periphButtonArr.append(PeriphButton1)
        periphButtonArr.append(PeriphButton2)
        periphButtonArr.append(PeriphButton3)
        periphButtonArr.append(PeriphButton4)
        periphButtonArr.append(PeriphButton5)
        
        for (_, button) in periphButtonArr.enumerated() {
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = defaultColor.MenuButtonColor
        }

        setupToSpecificState()
    }
    
    func setupToSpecificState () {
        print(currentState)
        if (currentState == State.RecordingIdle)
        {
            setButtonState(ibutton : PeriphButton0,ibuttonState : false)
            

        }
        if (currentState == State.ScaleTestIdle)
        {
            setupPeripheralButtons(itextArr : ["Start Test","Show Scale","Play Scale"])
            sClass!.setupSpecifiedScale()
        }
    }
    
    func setupPeripheralButtons (itextArr : [String ]) {
        
        for (i, _) in itextArr.enumerated() {
//            periphButtonArr[i].setTitle(itextArr[i], for: .normal)
            periphButtonArr[i].setTitle("", for: .normal)
            periphButtonArr[i].layer.masksToBounds = true
            periphButtonArr[i].layer.cornerRadius = 25
        }
        
        for (i, button) in periphButtonArr.enumerated() {
            if (i < itextArr.count)
            {
                button.isHidden = false
            }
            else
            {
                button.isHidden = true
            }
        }
    }
    
    func setButtonState (ibutton : UIButton, ibuttonState : Bool) {
        let alpha = ibuttonState ? 1.0 : 0.0
        ibutton.isEnabled = ibuttonState
        ibutton.alpha = CGFloat(alpha)
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
    
    @IBAction func NavToMainMenu(_ sender: Any) {
        var controller: MainMenuViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    @IBAction func scrollTempo(_ sender: UIButton) {
        let dir = sender.tag == 0 ? 1.0 : -1.0
        met!.bpm = met!.bpm + dir
        TempoButton.setTitle(String(Int(met!.bpm)), for: .normal)
    }
    
    
    
    //    @IBAction func testNav2(_ sender: Any) {
//
//        let vc = setViewController(iviewControllerStr: "ViewController")
//
//        vc.currentState = ViewController.State.RecordingIdle
//
//        presentViewController(iviewController: vc)
//    }
//
//    func setViewController(iviewControllerStr: String) -> ViewController {
//        var controller: ViewController
//
//        controller = self.storyboard?.instantiateViewController(withIdentifier: iviewControllerStr) as! ViewController
//
//        return controller
//    }
//
//    func presentViewController(iviewController: ViewController) {
//
//        iviewController.modalPresentationStyle = .fullScreen
//        present(iviewController, animated: false, completion: nil)
//    }
    
    
    @IBAction func startMetronome(_ sender: Any) {
        met?.startMetro()
    }
    
    
    //Peripheral Buttons Down
    @IBAction func PeripheralButton0OnButtonDown(_ sender: Any) {
        
        print("PeripheralButton0OnButtonDown \(currentState)")
        //Scale Test States
        if (currentState == State.ScaleTestIdle || currentState == State.ScaleTestShowScale) {
            PeriphButton0.setTitle("Stop Test", for: .normal)
            currentState = State.ScaleTestActive
            
            currentState = State.ScaleTestCountIn
            met?.currentClick = 0
            scaleTestData.removeAll()
            met?.startMetro()
        }
        else if (currentState == State.ScaleTestActive) {
            PeriphButton0.setTitle("Start Test", for: .normal)
            currentState = State.ScaleTestIdle
            
            met!.endMetronome()
            ResultButton1.setTitle("", for: .normal)
        }
    }
    
    @IBAction func PeripheralButton1OnButtonDown(_: AnyObject) {
        
        print("PeripheralButton1OnButtonDown \(currentState)")
        //Scale Test States
        if (currentState == State.ScaleTestIdle || currentState == State.ScaleTestShowScale) {
            
            let buttonStr = PeriphButton1.titleLabel?.text == "Show Scale" ? "Hide Scale" : "Show Scale"
            PeriphButton1.setTitle(buttonStr, for: .normal)
            if (buttonStr == "Hide Scale") {
                displayMultipleFretMarkers(iinputArr: specifiedScale)
                currentState = State.ScaleTestShowScale
            }
            else {
                hideAllFretMarkers()
                currentState = State.ScaleTestIdle
            }
        }
    }
    
    @IBAction func PeripheralButton2OnButtonDown(_ sender: Any) {
        
        print("PeripheralButton2OnButtonDown \(currentState)")
        print ("currentState \(currentState)")
        //Scale Test States
        if (currentState == State.ScaleTestIdle) {
            currentState = State.PlayingScale
            met?.startMetro()
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
        
//        if ()
        
        let states = [State.PlayingScale,State.ScaleTestCountIn,State.ScaleTestActive,State.ScaleTestIdle,State.ScaleTestShowScale]
        
        for (_,state) in states.enumerated() {
            if (currentState == state) {
                met!.endMetronome()
            }
        }
        
        
        var controller: MainMenuViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    @IBAction func FretPressed(_ sender: UIButton) {
        
        print("in fret pressed state \(currentState)")
        if (currentState == State.Recording || currentState == State.Idle || currentState == State.EarTrainResponse || currentState == State.ScaleTestActive || currentState == State.ScaleTestCountIn || currentState == State.ScaleTestIdle || currentState == State.ScaleTestShowScale)
        {
            if (currentState == State.ScaleTestShowScale)
            {
                hideAllFretMarkers()
                currentState = State.ScaleTestIdle
                PeriphButton1.setTitle("Show Scale", for: .normal)
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
            
            if (currentState == State.ScaleTestActive)
            {
                let st = InputData()
                st.note = buttonDict[sender.tag]!
                st.time = 0
                scaleTestData.append(st)
                recordTimeAccuracy()
            }
        }
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
            sClass?.setupSpecifiedScale()
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
    
    func displayMultipleFretMarkers(iinputArr: [String ])
    {
        killCurrentDotFade()
        
        for (str,_) in dotDict {
            dotDict[str]!.alpha = 0.0
           
            if (iinputArr.contains(str)) {
                UIView.animate(withDuration: 0.1, animations: {
                    self.dotDict[str]!.alpha = 1.0
                },completion: nil)
                
                swoopScale(iobject: self.dotDict[str]!,iscaleX: 0,iscaleY: 0,iduration: 0)
                swoopScale(iobject: self.dotDict[str]!,iscaleX: 1,iscaleY: 1,iduration: 0.1)
            }
        }
    }
    
    func hideAllFretMarkers()
    {
        killCurrentDotFade()
        
        for (str,_) in dotDict {
            dotDict[str]!.alpha = 0.0
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

