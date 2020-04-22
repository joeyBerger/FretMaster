//
//  ScaleClass.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 11/17/19.
//  Copyright © 2019 ashubin.com. All rights reserved.
//

import Foundation

class ScaleCollection {
    
    var vc : MainViewController?
    
    init (ivc:MainViewController) {
        vc = ivc;
    }
    
    let refScale : [String] = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    let scaleDegreeDict : [String:Int] = [
        "1" : 0,
        "b2" : 1,
        "2" : 2,
        "b3" : 3,
        "3" : 4,
        "4" : 5,
        "#4" : 6,
        "b5" : 6,
        "5" : 7,
        "#5" : 8,
        "b6" : 8,
        "6" : 9,
        "b7" : 10,
        "7" : 11
    ]
    
//    let distanceToScaleDegreeDict : [Int:String] = [:]
//    let distanceToScaleDegreeDict : [Int:String] = [:]
    
    let scaleNameDic : [String:String] = [
        "MinorPentatonic" : "Minor Pentatonic",
        "MajorPentatonic" : "Major Pentatonic",
        "Ionian" : "Ionian",
        "Dorian" : "Dorian",
        "Phyrgian" : "Phyrgian",
        "Lydian" : "Lydian",
        "Mixolydian" : "Mixolydian",
        "Aeolian" : "Aeolian",
        "Locrian" : "Locrian",
        "Chromatic" : "Chromatic",
        "MajorArp" : "Major Arpeggio",
        "MinorArp" : "Minor Arpeggio",
        "MajorSeventhArp" : "Major7th Arpeggio",
        "MinorSeventhArp" : "Minor7th Arpeggio",
        "DiminishedArp" : "Diminished Arpeggio",
        "AugmentedArp" : "Augmented Arpeggio",
    ]
    
    let availableScales : [String:[String]] = [
        "Ionian" : ["1","2","3","4","5","6","7"],
        "Dorian" : ["1","2","b3","4","5","6","b7"],
        "Phyrgian" : ["1","b2","b3","4","5","b6","b7"],
        "Lydian" : ["1","2","3","#4","5","6","7"],
        "Mixolydian" : ["1","2","3","4","5","6","b7"],
        "Aeolian" : ["1","2","b3","4","5","b6","b7"],
        "Locrian" : ["1","b2","b3","4","b5","b6","b7"],
        "MinorPentatonic" : ["1","b3","4","5","b7"],
        "MajorPentatonic" : ["1","2","3","5","6"],
        
        "MajorArp" : ["1","3","5"],
        "MinorArp" : ["1","b3","5"],
        "DiminishedArp" : ["1","b3","b5"],
        "AugmentedArp" : ["1","3","#5"],
        
        "MajorSeventhArp" : ["1","3","5","7"],
        "MinorSeventhArp" : ["1","b3","5","b7"],
        
        "Chromatic" : ["1","b2","2","b3","3","4","#4","5","#5","6","b7","7"],
    ]
    
    var startingOctave = 0
    var scaleOctaves = 2
    
    func setupSpecifiedScale (iinput : String, idirection : String)
    {
        let startingNote = "A"
        var noteIndex = 0
        var notePos = 1
        
        let desiredScale = availableScales[iinput]

        vc!.specifiedNoteCollection.removeAll()
        
        //find note index
        if (vc!.specifiedNoteCollection.isEmpty)
        {
            for (i, item) in refScale.enumerated() {
                if (startingNote == item)
                {
                    noteIndex = i
                    break
                }
            }
            
            for (i, _) in desiredScale!.enumerated() {
                let note = scaleDegreeDict[desiredScale![i]]
                if ((noteIndex+note!) >= refScale.count*notePos)
                {
                    notePos = notePos + 1
                }
                 vc!.specifiedNoteCollection.append(refScale[(noteIndex+note!)%refScale.count] + String(notePos+startingOctave))
            }
            
            if (scaleOctaves > 1) {
                for item in vc!.specifiedNoteCollection {
                    let noteName = item.count == 2 ? item.prefix(1) : item.prefix(2)
                    let pitch = Int(item.suffix(1))! + 1
                    let newNote = noteName + String(pitch)
                    vc!.specifiedNoteCollection.append(String(newNote))
                }
            }
            else if (startingOctave > 0) {
                let tempArr = vc!.specifiedNoteCollection
                vc!.specifiedNoteCollection.removeAll()
                for item in tempArr
                {
                    let noteName = item.count == 2 ? item.prefix(1) : item.prefix(2)
                    let pitch = Int(item.suffix(1))! + 1
                    let newNote = noteName + String(pitch)
                    vc!.specifiedNoteCollection.append(String(newNote))
                }
            }
            
            //add last octave
            let noteName = vc!.specifiedNoteCollection[0].count == 2 ? vc!.specifiedNoteCollection[0].prefix(1) : vc!.specifiedNoteCollection[0].prefix(2)
            let pitch = Int(vc!.specifiedNoteCollection[0].suffix(1))! + scaleOctaves;
            let newNote = noteName + String(pitch)
            vc!.specifiedNoteCollection.append(String(newNote))
            
            if (idirection == "Down") {
                vc!.specifiedNoteCollection = vc!.specifiedNoteCollection.reversed()
            } else if (idirection == "Both") {
                var i = 0
                for (item) in vc!.specifiedNoteCollection.reversed() {
                    if (i > 0)
                    {
                        vc!.specifiedNoteCollection.append(item)
                    }
                    i = i +  1
                }
            }
        }
    }
    
    func returnNoteDistance (iinput: String, icomparedNote: String) -> String {
        if let inputIndex = refScale.firstIndex(of: iinput) {
//            print("inputIndex \(inputIndex)  ")
//            print("iinput \(iinput)  ")
            if let comparedNoteIndex = refScale.firstIndex(of: icomparedNote) {
//                print("comparedNoteIndex \(comparedNoteIndex)")
                let dist = inputIndex < comparedNoteIndex ? (12 + inputIndex) - comparedNoteIndex : inputIndex - comparedNoteIndex
                return scaleDegreeDict.filter{$1 == dist}.map{$0.0}[0]
            }
        }
        return ""
    }
    
    func returnReadableScaleName (iinput: String) -> String {
        return scaleNameDic[iinput]!
    }
    
    func analyzeNotes (iscaleTestData : [MainViewController.InputData]) -> Bool {
        if (iscaleTestData.count != vc!.specifiedNoteCollection.count) {
            return false
        }
        for (i,item) in iscaleTestData.enumerated() {
            if (item.note != vc!.specifiedNoteCollection[i]) {
                return false
            }
        }
        return true
    }
}
