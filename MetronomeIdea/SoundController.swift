import AVFoundation

class SoundController: NSObject,AVAudioRecorderDelegate {
    var player: AVAudioPlayer!
    var scSub = [SoundControllerSub]()
    var scSubIdx = Int()
    
    init (isubInstances:Int) {
        for _ in 0..<isubInstances {
            scSub.append(SoundControllerSub())
            scSubIdx = 0
        }
    }

    func playSound(isoundName: String, ioneShot: Bool = false) {
        if (ioneShot) {scSubIdx = scSubIdx + 1}
        scSub[scSubIdx%scSub.count].playSound(isoundName: isoundName)
    }
}

class SoundControllerSub : NSObject, AVAudioRecorderDelegate  {
    
    var player: AVAudioPlayer!
    
    func playSound(isoundName: String) {
        let path = Bundle.main.path(forResource: isoundName, ofType : "wav")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        }
        catch {
            print (error)
        }
    }
}
