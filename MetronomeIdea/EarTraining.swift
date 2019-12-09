//
//  EarTraining.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 11/14/19.
//  Copyright © 2019 ashubin.com. All rights reserved.
//

import Foundation
class EarTraining {
    
    var vc : ViewController?
    
    init (ivc:ViewController) {
        vc = ivc;
        
    }
    
    var earTrainCallArr: [String] = []
    var earTrainResponseArr: [String] = []
    
    func earTrainingSetup() {
        let numbNotes = 5
        for _ in 0..<numbNotes {
            earTrainCallArr.append(vc!.tempScale[vc!.rand(max: vc!.tempScale.count)])
        }
        vc!.currentState = ViewController.State.EarTrainCall
        vc!.met!.currentClick = 0
        let displayT = 1
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(displayT), target: self, selector: #selector(self.beginEarTrainingHelper), userInfo: ["NoteSelection":vc!.tempScale,"AlphaVal":0.0], repeats: false)
        
        vc!.displaySelectionDots(inoteSelection: vc!.tempScale, ialphaAmount: 0.5)
        vc!.dotDict[earTrainCallArr[0]]?.alpha = 1
    }
    
    
    func presentEarTrainResults()
    {
        let resultText = earTrainCallArr == earTrainResponseArr ? "Good" : "Bad"
        vc!.ResultsLabel0.text = resultText
        _ = Timer.scheduledTimer(timeInterval: 2, target: vc!, selector: #selector(vc!.resetResultsLabel), userInfo: nil, repeats: false)
        earTrainCallArr.removeAll()
        earTrainResponseArr.removeAll()
        vc!.currentState = ViewController.State.Idle
    }
    
    @objc func beginEarTrainingHelper(timer:Timer)
    {
        let argDict = timer.userInfo as! Dictionary<String, AnyObject>
        vc!.displaySelectionDots(inoteSelection: argDict["NoteSelection"] as! [String],ialphaAmount: argDict["AlphaVal"] as! Double)
//        vc!.met.startMetro()
        vc!.startMetronome(self)
    }
}
