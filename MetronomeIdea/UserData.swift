//
//  UserData.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 11/24/19.
//  Copyright © 2019 ashubin.com. All rights reserved.
//

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
    
    
//    init(name:String,lastName:String,scaleLevel:Double) {
//
//        self.name = name
//        self.lastName = lastName
//        self.scaleLevel = scaleLevel
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(lastName, forKey: "lastName")
//    }
//
//    convenience required init?(coder aDecoder: NSCoder) {
//
//        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
//        let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
//            else {
//                return nil
//        }
//        self.init(name: name, lastName: lastName, scaleLevel: 1.0)
//    }
}

class LevelConstruct {
    let scale = [
        
        
        ["MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo"],
        
                ["MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo"],
                        ["MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo"],
                                ["MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo","MinorPentatonic_Up_Tempo", "MinorPentatonic_Up_Tempo"],
        
        
        
        ["MinorPentatonic_Both_Tempo", "MajorPentatonic_Both_Tempo","Ionian_Both_Tempo", "Aeolian_Both_Tempo"],
        ["MinorPentatonic_Up", "MajorPentatonic_Up"],
        ["Ionian_Up", "Aeolian_Up"],
        ["MinorPentatonic_Up", "MajorPentatonic_Up","Ionian_Up", "Aeolian_Up"],
        ["MinorPentatonic_Both", "MajorPentatonic_Both","Ionian_Both", "Aeolian_Both"],
    ]
    let arpeggio = [
        ["MajorArp_Up", "MinorArp_Up"],
        ["MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["MajorArp_Up", "MinorArp_Up","MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["DiminishedArp_Up", "AugmentedArp_Up"],
    ]
    
//    let scale = [
//        ["MinorPentatonic", "MajorPentatonic"],
//        ["Ionian", "Aeolian"],
//        ["MinorPentatonic", "MajorPentatonic","Ionian", "Aeolian"],
//    ]
//    let arpeggio = [
//        ["MajorArp", "MinorArp"],
//        ["MajorSeventhArp", "MinorSeventhArp"],
//        ["MajorArp", "MinorArp","MajorSeventhArp", "MinorSeventhArp"],
//        ["DiminishedArp", "AugmentedArp"],
//    ]
}
