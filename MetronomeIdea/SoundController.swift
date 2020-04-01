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

    func playSound(isoundName: String, ioneShot: Bool = false, ifadeAllOtherSoundsDuration: Double = -1.0) {
        if (ioneShot) {scSubIdx = scSubIdx + 1}
        scSub[scSubIdx%scSub.count].playSound(isoundName: isoundName)
        if (ifadeAllOtherSoundsDuration >= 0) {
            for i in 0...scSub.count-1 {
                if (i != scSubIdx%scSub.count) {
                    scSub[i].fadeSound(iduration: ifadeAllOtherSoundsDuration)
                }
            }
        }
    }
    
    func fadeSound (isoundName: String, iduration: Double) {
        if (isoundName != "") {
             for i in 0...scSub.count-1 {
                 if (scSub[i].lastPlayedSound == isoundName) {
                    scSub[i].fadeSound(iduration: iduration)
                }
            }
        } else {
            scSub[scSubIdx%scSub.count].fadeSound(iduration: iduration)
        }
    }
    
//    func fadeSound(iduration: Double) {
//        scSub[scSubIdx%scSub.count].fadeSound(iduration: iduration)
//    }
}

class SoundControllerSub : NSObject, AVAudioRecorderDelegate  {
    
    var player: AVAudioPlayer!
    var lastPlayedSound: String!
    
    func playSound(isoundName: String) {
        let path = Bundle.main.path(forResource: isoundName, ofType : "wav")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
            lastPlayedSound = isoundName
        }
        catch {
            print (error)
        }
    }
    
    func fadeSound(iduration: Double = 0) {
        if let player = player {
            player.setVolume(0, fadeDuration: iduration)
        }
        
    }
}
