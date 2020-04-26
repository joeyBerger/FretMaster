import AVFoundation

class Metronome {
    
    var vc : MainViewController?
    
    init (ivc:MainViewController) {
        vc = ivc;
    }

    var previousClick = CFAbsoluteTimeGetCurrent()

    var clickTime = CFAbsoluteTimeGetCurrent()
    var userInputTime = CFAbsoluteTimeGetCurrent()
    var recordStartTime: CFAbsoluteTime = 0
    var recordStopTime: CFAbsoluteTime = 0
    
    var countInClick = 4
    var numbTestClicks = 4
    var currentClick = 0

    //timers
    var metroTimer : Timer?
    var nextTimer : Timer?

    var isOn = false
    var bpm = 120.0
    var minBPM = 40.0
    var maxBPM = 350.0

    var barNoteValue = 4
    var noteInBar = 0
    var subdivision = 1;
    
    let timeThreshold: [String: Double] = [
        "Easy": 0.1,
        "Medium": 0.075,
        "Hard": 0.05,
    ]

    func startMetro() {
        endMetronome()
        MetronomeCount()
        
        currentClick = 0
        barNoteValue = 4
        noteInBar = 0
        isOn = true
    }

    //Main Metro Pulse Timer
    func MetronomeCount() {
        previousClick = CFAbsoluteTimeGetCurrent()

        metroTimer = Timer.scheduledTimer(timeInterval: (60.0/Double(bpm)) * 0.01, target: self, selector: #selector(self.MetroClick), userInfo: ["bpm":bpm], repeats: true)

        nextTimer = Timer.scheduledTimer(timeInterval: (60.0/Double(bpm)) * 0.01, target: self, selector: #selector(self.tick), userInfo: ["bpm":bpm], repeats: true)
    }


    @objc func MetroClick(timer:Timer) {
        tick(timer:nextTimer!)
    }

    @objc func tick(timer:Timer) {
        let elapsedTime:CFAbsoluteTime = CFAbsoluteTimeGetCurrent() - previousClick
        let targetTime:Double = 60/bpm
        if (elapsedTime > targetTime) || (abs(elapsedTime - targetTime) < 0.0003) {
            if (vc!.currentState == MainViewController.State.PlayingNotesCollection) {
                vc!.sc.playSound(isoundName: vc!.specifiedNoteCollection[currentClick] + "_" + vc!.guitarTone, ivolume: volume.volumeTypes["masterVol"]!*volume.volumeTypes["guitarVol"]!, ioneShot: true, ifadeAllOtherSoundsDuration: 0.1)
                vc!.displaySingleFretMarker(iinputStr: vc!.specifiedNoteCollection[currentClick])
                if (currentClick == vc!.specifiedNoteCollection.count-1) {
                    endMetronome()
                    vc!.currentState = vc!.tempoActive ? MainViewController.State.NotesTestIdle_Tempo : MainViewController.State.NotesTestIdle_NoTempo
                    
                    vc!.setPeriphButtonsToDefault(idefaultIcons: vc!.defaultPeripheralIcon)
                }
            }
            else if (vc!.currentState == MainViewController.State.EarTrainCall) {
                vc!.sc.playSound(isoundName: vc!.earTrainCallArr[currentClick], ivolume: volume.volumeTypes["masterVol"]!*volume.volumeTypes["guitarVol"]!)
                if (currentClick == vc!.earTrainCallArr.count-1) {
                    endMetronome()
                    vc!.currentState = MainViewController.State.EarTrainResponse
                }
            }
            //Scale Test Active
            else {
                vc!.click.playSound(isoundName: "Click_" + vc!.clickTone, ivolume: volume.volumeTypes["masterVol"]!*volume.volumeTypes["clickVol"]!)
                clickTime = CFAbsoluteTimeGetCurrent()
                if (currentClick == countInClick-1 && vc!.currentState == MainViewController.State.NotesTestCountIn_Tempo) {
                    vc!.currentState = MainViewController.State.NotesTestActive_Tempo
                    vc!.ResultsLabel.text = "Count In: " + String(currentClick+1)
                }
                else if (currentClick < 3) {
                    vc!.ResultsLabel.text = "Count In: " + String(currentClick+1)
                }
                else if (currentClick == 4) {
                    vc!.ResultsLabel.text = "GO!"
                }
                if (currentClick >= countInClick) {
                    if (clickTime - userInputTime > 0.5) {
                        //print ("late")
                    }
                    else {
                        let timeDelta = clickTime - userInputTime
                        if (timeDelta < 0.05) {
                            print("good0")
                        }
                        else {
                            print("early0")
                        }
                        vc!.noteCollectionTestData[vc!.noteCollectionTestData.count-1].time = userInputTime
                        vc!.noteCollectionTestData[vc!.noteCollectionTestData.count-1].timeDelta = timeDelta
                    }
                }
                if (currentClick == countInClick + vc!.specifiedNoteCollection.count - 1) {
                    endMetronome()
                    _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.analyzeNotesInTempoTest), userInfo: nil, repeats: false)
                }
            }
            previousClick = CFAbsoluteTimeGetCurrent()
            currentClick = currentClick + 1;
        }
    }

    func endMetronome() {
        if nextTimer != nil {
            nextTimer?.invalidate()
            nextTimer = nil
        }
        if metroTimer != nil {
            metroTimer?.invalidate()
            metroTimer = nil
        }
        if (vc!.currentState == MainViewController.State.NotesTestCountIn_Tempo || vc!.currentState == MainViewController.State.NotesTestActive_Tempo) {
            vc!.ResultsLabel.text = vc!.resultsLabelDefaultText
        }
    }
    
    @objc func analyzeNotesInTempoTest() {
        let notesMatch = vc!.sCollection!.analyzeNotes(iscaleTestData: vc!.noteCollectionTestData)
        var timeAcurracyMet = true
        for (_, items) in vc!.noteCollectionTestData.enumerated() {
            if (items.timeDelta > (timeThreshold["Easy"])!) {
                timeAcurracyMet = false
            }
        }
        
        var testResultStrs: [String] = []
        if (!notesMatch) {
            testResultStrs.append(vc!.testResultStrDict["incorrect_notes"]!)
        }
        if (!timeAcurracyMet) {
            testResultStrs.append(vc!.testResultStrDict["incorrect_time"]!)
        }
        
        print("notesMatch \(notesMatch)")
        print("timeAcurracyMet \(timeAcurracyMet)")
        let notesCorrect = notesMatch && timeAcurracyMet
        vc!.onTestComplete(itestPassed : notesCorrect, iflashRed : true)
        vc!.wt.waitThen(itime: 0.5, itarget: vc!, imethod: #selector(vc!.presentTestResult) as Selector, irepeats: false, idict: ["notesCorrect": notesCorrect as AnyObject, "testResultStrs": testResultStrs as AnyObject])
    }

//    private let audioPlayerNode: AVAudioPlayerNode
//    private let audioFileMainClick: AVAudioFile
//    private let audioFileAccentedClick: AVAudioFile
//    private let audioEngine: AVAudioEngine
//
//    init (mainClickFile: URL, accentedClickFile: URL? = nil) {
//
//        audioFileMainClick = try! AVAudioFile(forReading: mainClickFile)
//        audioFileAccentedClick = try! AVAudioFile(forReading: accentedClickFile ?? mainClickFile)
//
//        audioPlayerNode = AVAudioPlayerNode()
//
//        audioEngine = AVAudioEngine()
//        audioEngine.attach(self.audioPlayerNode)
//
//        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFileMainClick.processingFormat)
//        try! audioEngine.start()
//    }
//
//    private func generateBuffer(bpm: Double) -> AVAudioPCMBuffer {
//
//        audioFileMainClick.framePosition = 0
//        audioFileAccentedClick.framePosition = 0
//
//        let beatLength = AVAudioFrameCount(audioFileMainClick.processingFormat.sampleRate * 60 / bpm)
//        let bufferMainClick = AVAudioPCMBuffer(pcmFormat: audioFileMainClick.processingFormat,
//                                               frameCapacity: beatLength)!
//        try! audioFileMainClick.read(into: bufferMainClick)
//        bufferMainClick.frameLength = beatLength
//
//        let bufferAccentedClick = AVAudioPCMBuffer(pcmFormat: audioFileMainClick.processingFormat,
//                                                   frameCapacity: beatLength)!
//        try! audioFileAccentedClick.read(into: bufferAccentedClick)
//        bufferAccentedClick.frameLength = beatLength
//
//        let bufferBar = AVAudioPCMBuffer(pcmFormat: audioFileMainClick.processingFormat,
//                                         frameCapacity: 4 * beatLength)!
//        bufferBar.frameLength = 4 * beatLength
//
//        // don't forget if we have two or more channels then we have to multiply memory pointee at channels count
//        let channelCount = Int(audioFileMainClick.processingFormat.channelCount)
//        let accentedClickArray = Array(
//            UnsafeBufferPointer(start: bufferAccentedClick.floatChannelData![0],
//                                count: channelCount * Int(beatLength))
//        )
//        let mainClickArray = Array(
//            UnsafeBufferPointer(start: bufferMainClick.floatChannelData![0],
//                                count: channelCount * Int(beatLength))
//        )
//
//        var barArray = [Float]()
//        // one time for first beat
//        barArray.append(contentsOf: accentedClickArray)
//        // three times for regular clicks
//        for _ in 1...3 {
//            barArray.append(contentsOf: mainClickArray)
//        }
//        bufferBar.floatChannelData!.pointee.assign(from: barArray,
//                                                   count: channelCount * Int(bufferBar.frameLength))
//        return bufferBar
//    }
//
//    func play(bpm: Double) {
//        print("playing")
//        let buffer = generateBuffer(bpm: bpm)
//
//        if audioPlayerNode.isPlaying {
//            audioPlayerNode.scheduleBuffer(buffer, at: nil, options: .interruptsAtLoop, completionHandler: nil)
//        } else {
//            self.audioPlayerNode.play()
//        }
//
//        self.audioPlayerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
//    }
//
//    func stop() {
//        audioPlayerNode.stop()
//    }
//
//    var isPlaying: Bool {
//        return audioPlayerNode.isPlaying
//    }
}
