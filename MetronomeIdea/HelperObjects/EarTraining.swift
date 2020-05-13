import Foundation

class EarTraining {
    init(ivc: MainViewController) {
        vc = ivc
    }

    var vc: MainViewController?
//    var earTrainCallArr: [String] = []
//    var earTrainResponseArr: [String] = []

    func earTrainingSetup(_ iinput: String) {
        
        let note = vc!.sCollection!.parseCoreNote(vc!.startingEarTrainingNote)
        let octave = vc!.sCollection!.parseNoteOctave(vc!.startingEarTrainingNote)
        let noteCollection = vc!.sCollection!.parseIntervalNotes(note,octave,[iinput])
        vc!.earTrainCallArr = noteCollection
        vc!.earTrainResponseArr.removeAll()

        print("vc!.earTrainCallArr \(vc!.earTrainCallArr)")
        vc!.currentState = MainViewController.State.EarTrainingCall
        vc!.met!.currentClick = 0
        let displayT = 0.2
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(displayT), target: self, selector: #selector(beginEarTrainingHelper), userInfo: ["NoteSelection": vc!.tempScale, "AlphaVal": 0.0], repeats: false)

        vc!.displaySelectionDots(inoteSelection: [vc!.earTrainCallArr[0]], ialphaAmount: 1.0)
    }

    func presentEarTrainResults() {
       
        var testPassed = false
        var resultTextArr = ["Wrong Intercal Played", "You Played a 5th, instead of a 2nd."]
        if vc!.earTrainCallArr == vc!.earTrainResponseArr {
            testPassed = true
            resultTextArr = ["Great! You Correctly Played a 5th."]
        }
        
        vc!.onTestComplete(itestPassed: testPassed)
        vc!.wt.waitThen(itime: 0.5, itarget: vc!, imethod: #selector(vc!.presentTestResult) as Selector, irepeats: false, idict: ["notesCorrect": testPassed as AnyObject, "testResultStrs": resultTextArr as AnyObject])
    }

    @objc func beginEarTrainingHelper(timer: Timer) {
        let argDict = timer.userInfo as! [String: AnyObject]
//        vc!.displaySelectionDots(inoteSelection: argDict["NoteSelection"] as! [String], ialphaAmount: argDict["AlphaVal"] as! Double)
        vc!.startMetronome(self)
    }
}
