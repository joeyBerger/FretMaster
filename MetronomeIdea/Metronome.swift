//
//  Metronome.swift
//  MetronomeIdea
//
//  Created by Alex Shubin on 26.03.17.
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import AVFoundation

class Metronome {
    
    var vc : ViewController?
    
    init (ivc:ViewController) {
        vc = ivc;
//        print(vc!.currentState);
    }

    
    var previousClick = CFAbsoluteTimeGetCurrent()    //When Metro Starts Last Click

    var clickTime = CFAbsoluteTimeGetCurrent()
    var userInputTime = CFAbsoluteTimeGetCurrent()
    var recordStartTime: CFAbsoluteTime = 0
    var recordStopTime: CFAbsoluteTime = 0
    
    var countInClick = 4
    var numbTestClicks = 4
    var currentClick = 0

    //TIMERS
    var metroTimer : Timer?
    var nextTimer : Timer?

    //Metro Features
    var isOn = false
    var bpm = 120.0//60.0     //Tempo Used for beeps, calculated into time value

    var barNoteValue = 4        //How Many Notes Per Bar (Set To Amount Of Hits Per Pattern)
    var noteInBar = 0        //What Note You Are On In Bar
    var subdivision = 1;

    func startMetro()
    {
        endMetronome()
        MetronomeCount()
        
        currentClick = 0
        barNoteValue = 4         // How Many Notes Per Bar (Set To Amount Of Hits Per Pattern)
        noteInBar = 0         // What Note You Are On In Bar
        isOn = true
    }

    //Main Metro Pulse Timer
    func MetronomeCount()
    {
        previousClick = CFAbsoluteTimeGetCurrent()

        metroTimer = Timer.scheduledTimer(timeInterval: (60.0/Double(bpm)) * 0.01, target: self, selector: #selector(self.MetroClick), userInfo: ["bpm":bpm], repeats: true)

        nextTimer = Timer.scheduledTimer(timeInterval: (60.0/Double(bpm)) * 0.01, target: self, selector: #selector(self.tick), userInfo: ["bpm":bpm], repeats: true)
    }


    @objc func MetroClick(timer:Timer)
    {
        // print ("MetroClick")
        tick(timer:nextTimer!)
    }

    @objc func tick(timer:Timer)
    {
        let elapsedTime:CFAbsoluteTime = CFAbsoluteTimeGetCurrent() - previousClick
        let targetTime:Double = 60/bpm
        if (elapsedTime > targetTime) || (abs(elapsedTime - targetTime) < 0.0003)
        {
            if (vc!.currentState == ViewController.State.PlayingNoteCollection)
            {
                vc!.sc.playSound(isoundName: vc!.specifiedNoteCollection[currentClick])
                vc!.displaySingleFretMarker(iinputStr: vc!.specifiedNoteCollection[currentClick])
                if (currentClick == vc!.specifiedNoteCollection.count-1)
                {
                    endMetronome()
                    vc!.currentState = vc!.tempoActive ? ViewController.State.ScaleTestIdle_Tempo : ViewController.State.ScaleTestIdle_NoTempo
                }
            }
            else if (vc!.currentState == ViewController.State.EarTrainCall)
            {
                vc!.sc.playSound(isoundName: vc!.earTrainCallArr[currentClick])
                if (currentClick == vc!.earTrainCallArr.count-1)
                {
                    endMetronome()
                    vc!.currentState = ViewController.State.EarTrainResponse
                }
            }
            //Scale Test Active
            else
            {
                vc!.click.playSound(isoundName: "MenuButtonClick")
                clickTime = CFAbsoluteTimeGetCurrent()
                //                print ("playing something\(clickTime) diff = \(clickTime - userInputTime)")
                if (currentClick == countInClick-1 && vc!.currentState == ViewController.State.ScaleTestCountIn_Tempo)
                {
                    vc!.currentState = ViewController.State.ScaleTestActive_Tempo
                    vc!.ResultsLabel0.text = String(currentClick+1)
                }
                else if (currentClick < 3)
                {
                    vc!.ResultsLabel0.text = String(currentClick+1)
                }
                else if (currentClick == 4)
                {
                    vc!.ResultsLabel0.text = "GO!"
                }
                if (currentClick >= countInClick)
                {
                    if (clickTime - userInputTime > 0.5)
                    {
                        //print ("late")
                    }
                    else
                    {
                        let timeDelta = clickTime - userInputTime
                        if (timeDelta < 0.05)
                        {
                            print("good0")
                        }
                        else
                        {
                            print("early0")
                        }
                        vc!.noteCollectionTestData[vc!.noteCollectionTestData.count-1].time = userInputTime
                        vc!.noteCollectionTestData[vc!.noteCollectionTestData.count-1].timeDelta = timeDelta
                    }
                }
                if (currentClick == countInClick + vc!.specifiedNoteCollection.count - 1)
                {
                    endMetronome()
                    _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.analyzeScaleTest), userInfo: nil, repeats: false)
                    
                }
            }
            previousClick = CFAbsoluteTimeGetCurrent()
            currentClick = currentClick + 1;
        }
    }
//
    func endMetronome()
    {
        if nextTimer != nil {
            nextTimer?.invalidate()
            nextTimer = nil
        }
        if metroTimer != nil {
            metroTimer?.invalidate()
            metroTimer = nil
        }
        if (vc!.currentState == ViewController.State.ScaleTestCountIn_Tempo || vc!.currentState == ViewController.State.ScaleTestActive_Tempo)
        {
            vc!.ResultsLabel0.text = "Minor Pentatonic"            
        }
    }
    
    @objc func analyzeScaleTest()
    {
        vc!.currentState = vc!.tempoActive ? ViewController.State.ScaleTestIdle_Tempo : ViewController.State.ScaleTestIdle_NoTempo
        vc!.resultViewStrs.removeAll()
        for item in vc!.noteCollectionTestData {
            print(item.note)
            print(item.time)
        }
        if (vc!.noteCollectionTestData.count != vc!.specifiedNoteCollection.count)
        {
//            print("Not Enough Notes Inputted")
            vc!.resultViewStrs.append("Try Again!")
            vc!.resultViewStrs.append("Not Enough Notes Inputted")
            vc!.ResultButton1.setTitle(vc!.resultViewStrs[0], for: .normal)
            return
        }
        let notesMatch = vc!.sCollection!.analyzeScale(iscaleTestData: vc!.noteCollectionTestData)
        var timeAcurracyMet = true
//        notesMatch = 
        for (_, items) in vc!.noteCollectionTestData.enumerated()
        {
            if (items.timeDelta > (vc!.timeThreshold["Easy"])!)
            {
                timeAcurracyMet = false
            }
        }
        var resultsText = ""
        
        resultsText = notesMatch && timeAcurracyMet ? "Great!" : "Try Again!"
        vc!.resultViewStrs.append(resultsText)
        if (!notesMatch)
        {
            vc!.resultViewStrs.append("NOTES : INCORRECT")
        }
        if (!timeAcurracyMet)
        {
            vc!.resultViewStrs.append("TIME : INCORRECT")
        }
        vc!.ResultButton1.setTitle(vc!.resultViewStrs[0], for: .normal)
//        vc!.ResultsLabel1.text = resultsText
        print(resultsText)
        _ = Timer.scheduledTimer(timeInterval: 2, target: vc, selector: #selector(vc!.resetResultsLabel), userInfo: nil, repeats: false)
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
