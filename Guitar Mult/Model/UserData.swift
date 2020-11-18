import Foundation

class UserLevelData: NSObject, NSCoding {
    var scaleLevel: String
    var arpeggioLevel: String
    var intervalLevel: String
    var et_scales: String
    var et_chords: String
    var tutorialComplete: String
    var stringEquivs = ["scaleLevel", "arpeggioLevel", "intervalLevel", "et_scales", "et_chords", "tutorialComplete"]

    init(scaleLevel: String, arpeggioLevel: String, intervalLevel: String, et_scales: String, et_chords: String, tutorialComplete: String) {
        self.scaleLevel = scaleLevel
        self.arpeggioLevel = arpeggioLevel
        self.intervalLevel = intervalLevel
        self.et_scales = et_scales
        self.et_chords = et_chords
        self.tutorialComplete = tutorialComplete
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(scaleLevel, forKey: "scaleLevel")
        aCoder.encode(arpeggioLevel, forKey: "arpeggioLevel")
        aCoder.encode(intervalLevel, forKey: "intervalLevel")
        aCoder.encode(et_scales, forKey: "et_scales")
        aCoder.encode(et_chords, forKey: "et_chords")
    }

    func setDefaultValues() {
        scaleLevel = "0.0"
        arpeggioLevel = "0.0"
        intervalLevel = "0.0"
        et_scales = "0.0"
        et_chords = "0.0"
        tutorialComplete = "0.0"
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let scaleLevel = aDecoder.decodeObject(forKey: "scaleLevel") as? String,
            let arpeggioLevel = aDecoder.decodeObject(forKey: "arpeggioLevel") as? String,
            let intervalLevel = aDecoder.decodeObject(forKey: "intervalLevel") as? String,
            let et_scales = aDecoder.decodeObject(forKey: "et_scales") as? String,
            let et_chords = aDecoder.decodeObject(forKey: "et_chords") as? String,
            let tutorialComplete = aDecoder.decodeObject(forKey: "tutorialComplete") as? String
        else {
            return nil
        }
        self.init(scaleLevel: scaleLevel, arpeggioLevel: arpeggioLevel, intervalLevel: intervalLevel, et_scales: et_scales, et_chords: et_chords, tutorialComplete: tutorialComplete)
    }
    
    func updateValueOnAPIRequest(_ id : String, _ val : String ) {
        print(id,val)
        switch id {
            case "scaleLevel":
                scaleLevel = val
                break
            case "arpeggioLevel":
                arpeggioLevel = val
                break
            case "intervalLevel":
                intervalLevel = val
                break
            case "et_scales":
                et_scales = val
                break
            case "et_chords":
                et_chords = val
                break
            case "tutorialComplete":
                tutorialComplete = val
                break
            case "appUnlocked":
                appUnlocked = val
                break
            case "currentAppVersion":
                currentAppVersion = val
                break
            default:
                break
        }
        UserDefaults.standard.set(val, forKey: id)
    }
}
