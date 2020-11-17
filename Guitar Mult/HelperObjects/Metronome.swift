import AVFoundation
//import AudioKitUI
import AudioKit

var metronome2 = AKMetronome()


class Metronome {
    var vc: MainViewController?
    
    
    var previousClick = CFAbsoluteTimeGetCurrent()
    var clickTime : [Double] = []
    var userInputTime = CFAbsoluteTimeGetCurrent()
    var countInClick = 4
    var currentClick = 0
    var bpm = 120.0
    var minBPM = 40.0
    var maxBPM = 350.0
    
    var metronome1 = AKSamplerMetronome()
    var mixer = AKMixer()
    
    init(ivc: MainViewController) {
        vc = ivc
        
        currentClick = 0
        if !audioKitStarted {
            metronome2.subdivision = 4
            metronome2.tempo = 250
            metronome2.frequency1 = 0
            metronome2.frequency2 = 0
            AudioKit.output = metronome2
            audioKitStarted = true
            AKSettings.bufferLength = .veryShort
        }
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        metronome2.callback = {
            DispatchQueue.main.async {
                self.tick()
            }
        }
    }

    let timeThreshold: [String: Double] = [
        "Easy": 0.1,
        "Medium": 0.075,
        "Hard": 0.035,
    ]

    func startMetro() {
        endMetronome()
        currentClick = 0
        metronome2.tempo = bpm
        metronome2.reset()
        metronome2.restart()
    }
    
    func tick() {
        if vc!.viewingNoteCollection {
            var str = vc!.specifiedNoteCollection[currentClick]
            str = vc!.sCollection?.returnOffsetFretNote(str,vc!.fretOffset) as! String
            vc!.sc.playSound(isoundName: str + "_" + vc!.guitarTone, ivolume: volume.volumeTypes["masterVol"]! * volume.volumeTypes["guitarVol"]!, ioneShot: true, ifadeAllOtherSoundsDuration: 0.1)
            if currentClick == vc!.specifiedNoteCollection.count - 1 {
                endMetronome()
            }
            currentClick = currentClick + 1
            return
        }
        if vc!.currentState == MainViewController.State.PlayingNotesCollection {
            var str = vc!.specifiedNoteCollection[currentClick]
            str = vc!.sCollection?.returnOffsetFretNote(str,vc!.fretOffset) as! String
            vc!.sc.playSound(isoundName: str + "_" + vc!.guitarTone, ivolume: volume.volumeTypes["masterVol"]! * volume.volumeTypes["guitarVol"]!, ioneShot: true, ifadeAllOtherSoundsDuration: 0.1)
            vc!.displaySingleFretMarker(iinputStr: vc!.specifiedNoteCollection[currentClick],cascadeFretMarkers: false,fretAnim: "displayFret")
            if currentClick == vc!.specifiedNoteCollection.count - 1 {
                endMetronome()
                vc!.currentState = vc!.tempoActive ? MainViewController.State.NotesTestIdle_Tempo : MainViewController.State.NotesTestIdle_NoTempo

                vc!.setPeriphButtonsToDefault(idefaultIcons: vc!.defaultPeripheralIcon)
            }
        } else if vc!.currentState == MainViewController.State.EarTrainingCall {
            var str = vc!.earTrainCallArr[currentClick]
            str = vc!.sCollection?.returnOffsetFretNote(str,vc!.fretOffset) as! String
            vc!.sc.playSound(isoundName: str + "_" + vc!.guitarTone, ivolume: volume.volumeTypes["masterVol"]! * volume.volumeTypes["guitarVol"]!)
            if currentClick == vc!.earTrainCallArr.count - 1 {
                endMetronome()
                vc!.currentState = MainViewController.State.EarTrainingResponse
            }
        }
        // Scale Test Active
        else {
            vc!.click.playSound(isoundName: "Click_" + vc!.clickTone, ivolume: volume.volumeTypes["masterVol"]! * volume.volumeTypes["clickVol"]!)
//                clickTime = CFAbsoluteTimeGetCurrent()
            if currentClick == countInClick - 1, vc!.currentState == MainViewController.State.NotesTestCountIn_Tempo {
                vc!.currentState = MainViewController.State.NotesTestActive_Tempo
                vc!.ResultsLabel.text = "Count In: " + String(currentClick + 1)
                clickTime.removeAll()
            } else if currentClick < 3 {
                vc!.ResultsLabel.text = "Count In: " + String(currentClick + 1)
            } else if currentClick == 4 {
                vc!.ResultsLabel.text = "GO!"
            }
            if currentClick >= 4 {
                clickTime.append(CFAbsoluteTimeGetCurrent())
            }
            if currentClick == countInClick + vc!.specifiedNoteCollection.count - 1 {
                endMetronome()
                _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(analyzeNotesInTempoTest), userInfo: nil, repeats: false)
            }
        }
        previousClick = CFAbsoluteTimeGetCurrent()
        currentClick = currentClick + 1
    }

    func endMetronome() {
        if vc!.currentState == MainViewController.State.NotesTestCountIn_Tempo || vc!.currentState == MainViewController.State.NotesTestActive_Tempo {
            vc!.ResultsLabel.text = vc!.resultsLabelDefaultText
        }
        metronome2.stop()
        metronome2.reset()
    }

    @objc func analyzeNotesInTempoTest() {
        let notesMatch = vc!.sCollection!.analyzeNotes(iscaleTestData: vc!.noteCollectionTestData)
        var timeAcurracyMet = true
        var earlyNotesCounter = 0
        var lateNotesCounter = 0
        let timeThresholdStr = vc!.rhythmicAccuracy
        if clickTime.count == vc!.noteCollectionTestData.count {
            for (i, items) in vc!.noteCollectionTestData.enumerated() {
                if abs(clickTime[i] - items.time) > (timeThreshold[timeThresholdStr])! {
                    timeAcurracyMet = false
                    if clickTime[i] < items.time {
//                        print(i,"note was late")
                        lateNotesCounter += 1
                    } else {
                        earlyNotesCounter += 1
//                        print(i,"note was early")
                    }
                }
            }
        }
        var testResultStrs: [String] = []
        if !notesMatch {
            testResultStrs.append(vc!.testResultStrDict["incorrect_notes"]!)
        }
        if !timeAcurracyMet {
            testResultStrs.append(vc!.testResultStrDict["incorrect_time"]!)
            if earlyNotesCounter > 0 {
                let noteStr = earlyNotesCounter > 1 ? "Notes Were" : "Note Was"
                testResultStrs.append("\(earlyNotesCounter) \(noteStr) Early")
            }
            if lateNotesCounter > 0 {
                let noteStr = lateNotesCounter > 1 ? "Notes Were" : "Note Was"
                testResultStrs.append("\(lateNotesCounter) \(noteStr) Late")
            }
        }
        let notesCorrect = notesMatch && timeAcurracyMet
        if (notesCorrect) {
//            for button in vc!.fretButtonDict {
//                button.value.isEnabled = falsex
//            }
             vc!.setupUpDelayedNoteCollectionView(vc!.specifiedNoteCollection.uniques,"postSuccess");
        }
        vc!.onTestComplete(itestPassed: notesCorrect, iflashRed: true)
        vc!.wt.waitThen(itime: 0.5, itarget: vc!, imethod: #selector(vc!.presentTestResult) as Selector, irepeats: false, idict: ["notesCorrect": notesCorrect as AnyObject, "testResultStrs": testResultStrs as AnyObject])
        if notesCorrect {
//            vc!.setupUpDelayedNoteCollectionView(vc!.specifiedNoteCollection.uniques,"postSuccess");
        }
    }
}
