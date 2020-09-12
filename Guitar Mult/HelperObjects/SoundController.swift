import AVFoundation

class SoundController: NSObject, AVAudioRecorderDelegate {
    var player: AVAudioPlayer!
    var scSub = [SoundControllerSub]()
    var scSubIdx = Int()

    init(isubInstances: Int) {
        for _ in 0 ..< isubInstances {
            scSub.append(SoundControllerSub())
            scSubIdx = 0
        }
    }
    
    func validateInputStr(_ iinput: String) -> String {
        return iinput.replacingOccurrences(of: "_0", with: "").replacingOccurrences(of: "_1", with: "")
    }

    func playSound(isoundName: String, ivolume: Float, ioneShot: Bool = false, ifadeAllOtherSoundsDuration: Double = -1.0) {
        if ioneShot { scSubIdx = scSubIdx + 1 }
        scSub[scSubIdx % scSub.count].playSound(isoundName: validateInputStr(isoundName), ivolume: ivolume)
        if ifadeAllOtherSoundsDuration >= 0 {
            for i in 0 ... scSub.count - 1 {
                if i != scSubIdx % scSub.count {
                    scSub[i].fadeSound(iduration: ifadeAllOtherSoundsDuration)
                }
            }
        }
    }

    func fadeSound(isoundName: String, iduration: Double) {
        if isoundName != "" {
            for i in 0 ... scSub.count - 1 {
                if scSub[i].lastPlayedSound == isoundName {
                    scSub[i].fadeSound(iduration: iduration)
                }
            }
        } else {
            scSub[scSubIdx % scSub.count].fadeSound(iduration: iduration)
        }
    }
}

class SoundControllerSub: NSObject, AVAudioRecorderDelegate {
    var player: AVAudioPlayer!
    var lastPlayedSound: String!

    func playSound(isoundName: String, ivolume: Float) {
        let path = Bundle.main.path(forResource: isoundName, ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.setVolume(ivolume, fadeDuration: 0)
            player.play()
            lastPlayedSound = isoundName
        } catch {
            print(error)
        }
    }

    func fadeSound(iduration: Double = 0) {
        if let player = player {
            player.setVolume(0, fadeDuration: iduration)
        }
    }
}
