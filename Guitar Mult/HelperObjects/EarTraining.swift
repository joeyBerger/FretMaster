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

        vc!.currentState = MainViewController.State.EarTrainingCall
        vc!.met!.currentClick = 0
        let displayT = 0.2
        
        vc!.wt.waitThen(itime: displayT, itarget: self, imethod: #selector(beginEarTrainingHelper) as Selector, irepeats: false, idict: ["NoteSelection": vc!.tempScale as AnyObject, "AlphaVal": 0.0 as AnyObject])

//        vc!.displaySelectionDots(inoteSelection: [vc!.earTrainCallArr[0]], ialphaAmount: 1.0)
//        vc!.setColorOnFretMarkers(vc!.earTrainCallArr, defaultColor.FretMarkerStandard)
        vc!.setColorOnFretMarkers(vc!.specifiedNoteCollection, defaultColor.FretMarkerStandard)
    }

    func presentEarTrainResults() {
        var testPassed = false
       
        var resultTextArr:[String] = []
        if vc!.earTrainCallArr == vc!.earTrainResponseArr || checkForDSharp() {
            testPassed = true
            let interval = vc!.sCollection!.returnInterval(vc!.earTrainCallArr[0],vc!.earTrainCallArr[1])
            resultTextArr = ["Great! You Correctly Played A \(interval)."]
            print(resultTextArr)
        } else {
            if vc!.earTrainResponseArr[0] != vc!.earTrainCallArr[0] {
                resultTextArr = ["Wrong Starting Note Played", "Start On Highlighted Note"]
            } else {
                let correctInterval = vc!.sCollection!.returnInterval(vc!.earTrainCallArr[0],vc!.earTrainCallArr[1])
                let wrongInterval = vc!.sCollection!.returnInterval(vc!.earTrainResponseArr[0],vc!.earTrainResponseArr[1])
                resultTextArr = ["Wrong Interval Played", "You Played \(wrongInterval.contains("Octave") ? "an" : "a") \(wrongInterval)", "Correct answer is a \(correctInterval)"]
            }
        }
        
        vc!.onTestComplete(itestPassed: testPassed)
        let waitTime = 0.25
        vc!.wt.waitThen(itime: waitTime, itarget: vc!, imethod: #selector(vc!.presentTestResult) as Selector, irepeats: false, idict: ["notesCorrect": testPassed as AnyObject, "testResultStrs": resultTextArr as AnyObject])
        vc!.wt.waitThen(itime: waitTime, itarget: vc!, imethod: #selector(vc!.presentEarTrainingFretMarkers) as Selector, irepeats: false, idict: ["notesCorrect": testPassed as AnyObject])
    }
    
    func checkForDSharp() -> Bool {
        for (i,_) in vc!.earTrainCallArr.enumerated() {
            if vc!.earTrainCallArr[i] == "D#3" && (vc!.earTrainResponseArr[i] == "D#3_0" || vc!.earTrainResponseArr[i] == "D#3_1")  {
                return true
            }
        }
        return false
    }

    @objc func beginEarTrainingHelper(timer: Timer) {
        vc!.startMetronome(self)
    }
}
