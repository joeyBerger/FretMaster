import Foundation

class UserLevelData : NSObject, NSCoding {
    
    var scaleLevel : String
    var arpeggioLevel : String
    var et_singleNotes : String
    var et_scales : String
    var et_chords : String
    var tutorialComplete : String
    var stringEquivs = ["scaleLevel","arpeggioLevel","et_singleNotes","et_scales","et_chords","tutorialComplete"]
     init(scaleLevel:String,arpeggioLevel:String,et_singleNotes:String,et_scales:String,et_chords:String,tutorialComplete:String) {
        self.scaleLevel = scaleLevel
        self.arpeggioLevel = arpeggioLevel
        self.et_singleNotes = et_singleNotes
        self.et_scales = et_scales
        self.et_chords = et_chords
        self.tutorialComplete = tutorialComplete
     }
     
     func encode(with aCoder: NSCoder) {
        aCoder.encode(scaleLevel, forKey: "scaleLevel")
        aCoder.encode(arpeggioLevel, forKey: "arpeggioLevel")
        aCoder.encode(et_singleNotes, forKey: "et_singleNotes")
        aCoder.encode(et_scales, forKey: "et_scales")
        aCoder.encode(et_chords, forKey: "et_chords")
     }

    func setDefaultValues () {
        self.scaleLevel = "0.0"
        self.arpeggioLevel = "0.0"
        self.et_singleNotes = "0.0"
        self.et_scales = "0.0"
        self.et_chords = "0.0"
        self.tutorialComplete = "0.0"
    }
    
 
    
     convenience required init?(coder aDecoder: NSCoder) {
         guard let scaleLevel = aDecoder.decodeObject(forKey: "scaleLevel") as? String,
         let arpeggioLevel = aDecoder.decodeObject(forKey: "arpeggioLevel") as? String,
         let et_singleNotes = aDecoder.decodeObject(forKey: "et_singleNotes") as? String,
         let et_scales = aDecoder.decodeObject(forKey: "et_scales") as? String,
         let et_chords = aDecoder.decodeObject(forKey: "et_chords") as? String,
         let tutorialComplete = aDecoder.decodeObject(forKey: "tutorialComplete") as? String
             else {
                 return nil
         }
        self.init(scaleLevel: scaleLevel,arpeggioLevel: arpeggioLevel,et_singleNotes: et_singleNotes,et_scales: et_scales,et_chords: et_chords,tutorialComplete: tutorialComplete)
     }
}

