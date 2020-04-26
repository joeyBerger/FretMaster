import Foundation

class EarTraining {
    
    init (ivc:MainViewController) {
        vc = ivc;
    }
    
    var vc : MainViewController?
    var earTrainCallArr: [String] = []
    var earTrainResponseArr: [String] = []
    
    func earTrainingSetup() {
        let numbNotes = 5
        for _ in 0..<numbNotes {
            earTrainCallArr.append(vc!.tempScale[vc!.rand(max: vc!.tempScale.count)])
        }
        vc!.currentState = MainViewController.State.EarTrainCall
        vc!.met!.currentClick = 0
        let displayT = 1
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(displayT), target: self, selector: #selector(self.beginEarTrainingHelper), userInfo: ["NoteSelection":vc!.tempScale,"AlphaVal":0.0], repeats: false)
        
        vc!.displaySelectionDots(inoteSelection: vc!.tempScale, ialphaAmount: 0.5)
    }
    
    func presentEarTrainResults()
    {
        let resultText = earTrainCallArr == earTrainResponseArr ? "Good" : "Bad"
        vc!.ResultsLabel.text = resultText
        earTrainCallArr.removeAll()
        earTrainResponseArr.removeAll()
        vc!.currentState = MainViewController.State.Idle
    }
    
    @objc func beginEarTrainingHelper(timer:Timer)
    {
        let argDict = timer.userInfo as! Dictionary<String, AnyObject>
        vc!.displaySelectionDots(inoteSelection: argDict["NoteSelection"] as! [String],ialphaAmount: argDict["AlphaVal"] as! Double)
        vc!.startMetronome(self)
    }
}
