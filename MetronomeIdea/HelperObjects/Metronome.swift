import AVFoundation

class Metronome {
    var vc: MainViewController?
    var metCore = MetronomeCore()

    var previousClick = CFAbsoluteTimeGetCurrent()
    var clickTime = CFAbsoluteTimeGetCurrent()
    var userInputTime = CFAbsoluteTimeGetCurrent()
    var countInClick = 4
    var currentClick = 0
    var bpm = 120.0
    var minBPM = 40.0
    var maxBPM = 350.0
    var initialMetDeployed = true
    
    init(ivc: MainViewController) {
        vc = ivc
        metCore.onTick = { (nextTick) in
            self.tick()
        }
    }

    let timeThreshold: [String: Double] = [
        "Easy": 0.1,
        "Medium": 0.075,
        "Hard": 0.05,
    ]

    func startMetro() {
        endMetronome()
        currentClick = 0
        metCore.bpm = bpm
        metCore.enabled = true
        initialMetDeployed = true
    }
    
    func deployInitialMet() {
        initialMetDeployed = false
        metCore.enabled = true
        metCore.bpm = 300.0
    }
    
    func tick() {
        
        if !initialMetDeployed {
            return
        } else {
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
                clickTime = CFAbsoluteTimeGetCurrent()
                if currentClick == countInClick - 1, vc!.currentState == MainViewController.State.NotesTestCountIn_Tempo {
                    vc!.currentState = MainViewController.State.NotesTestActive_Tempo
                    vc!.ResultsLabel.text = "Count In: " + String(currentClick + 1)
                } else if currentClick < 3 {
                    vc!.ResultsLabel.text = "Count In: " + String(currentClick + 1)
                } else if currentClick == 4 {
                    vc!.ResultsLabel.text = "GO!"
                }
                if currentClick >= countInClick {
                    if clickTime - userInputTime > 0.5 {
                    } else {
                        let timeDelta = clickTime - userInputTime
                        if timeDelta < 0.05 {
                            print("good0")
                        } else {
                            print("early0")
                        }
                        vc!.noteCollectionTestData[vc!.noteCollectionTestData.count - 1].time = userInputTime
                        vc!.noteCollectionTestData[vc!.noteCollectionTestData.count - 1].timeDelta = timeDelta
                    }
                }
                if currentClick == countInClick + vc!.specifiedNoteCollection.count - 1 {
                    endMetronome()
                    _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(analyzeNotesInTempoTest), userInfo: nil, repeats: false)
                }
            }
            previousClick = CFAbsoluteTimeGetCurrent()
            currentClick = currentClick + 1
        }
    }

    func endMetronome() {
        metCore.enabled = false
        if vc!.currentState == MainViewController.State.NotesTestCountIn_Tempo || vc!.currentState == MainViewController.State.NotesTestActive_Tempo {
            vc!.ResultsLabel.text = vc!.resultsLabelDefaultText
        }
    }

    @objc func analyzeNotesInTempoTest() {
        let notesMatch = vc!.sCollection!.analyzeNotes(iscaleTestData: vc!.noteCollectionTestData)
        var timeAcurracyMet = true
        for (_, items) in vc!.noteCollectionTestData.enumerated() {
            if items.timeDelta > (timeThreshold["Easy"])! {
                timeAcurracyMet = false
            }
        }

        var testResultStrs: [String] = []
        if !notesMatch {
            testResultStrs.append(vc!.testResultStrDict["incorrect_notes"]!)
        }
        if !timeAcurracyMet {
            testResultStrs.append(vc!.testResultStrDict["incorrect_time"]!)
        }

        print("notesMatch \(notesMatch)")
        print("timeAcurracyMet \(timeAcurracyMet)")
        let notesCorrect = notesMatch && timeAcurracyMet
        vc!.onTestComplete(itestPassed: notesCorrect, iflashRed: true)
        vc!.wt.waitThen(itime: 0.5, itarget: vc!, imethod: #selector(vc!.presentTestResult) as Selector, irepeats: false, idict: ["notesCorrect": notesCorrect as AnyObject, "testResultStrs": testResultStrs as AnyObject])
    }
}


class MetronomeCore {
    var bpm = 120.0
    var enabled: Bool = false { didSet {
        if enabled {
            start()
        } else {
            stop()
        }
        }}
    var onTick: ((_ nextTick: DispatchTime) -> Void)?
    var nextTick: DispatchTime = DispatchTime.distantFuture

    let player: AVAudioPlayer = {
        do {
            let soundURL = Bundle.main.url(forResource: "Click_Digital", withExtension: "wav")!
            let soundFile = try AVAudioFile(forReading: soundURL)
            let player = try AVAudioPlayer(contentsOf: soundURL)
            return player
        } catch {
            print("Oops, unable to initialize metronome audio buffer: \(error)")
            return AVAudioPlayer()
        }
    }()

    private func start() {
        print("Starting metronome, BPM: \(bpm)")
        nextTick = DispatchTime.now()
        player.prepareToPlay()
        nextTick = DispatchTime.now()
        tick()
    }

    private func stop() {
        player.stop()
        print("Stoping metronome")
    }

    private func tick() {
        guard
            enabled,
            nextTick <= DispatchTime.now()
            else { return }

        let interval: TimeInterval = 60.0 / TimeInterval(bpm)
        nextTick = nextTick + interval
        DispatchQueue.main.asyncAfter(deadline: nextTick) { [weak self] in
            self?.tick()
        }

        player.play(atTime: interval)
        onTick?(nextTick)
    }
}
