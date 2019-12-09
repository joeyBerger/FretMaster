//
//  ScaleClass.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 11/17/19.
//  Copyright © 2019 ashubin.com. All rights reserved.
//

import Foundation

class ScaleClass {
    
    var vc : ViewController?
    
    init (ivc:ViewController) {
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
    
    var startingOctave = 0
    var scaleOctaves = 2
    
    func setupSpecifiedScale ()
    {
//        let dorian : [String] = ["1","2","b3","4","5","6","b7"]
        
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
            
            "MajArp" : ["1","3","5"],
            "MinArp" : ["1","b3","5"],
            "DimArp" : ["1","b3","b5"],
            "AugArp" : ["1","3","#5"],
            
            "Chromatic" : ["1","b2","2","b3","3","4","#4","5","#5","6","b7","7"],
            
            ]
        
        let startingNote = "A"
        var noteIndex = 0
        var notePos = 1
        
        //TODO: get rid of this
//        var randScale = availableScales.randomElement()!
//        print(availableScales.randomElement()!)
        var randScale = availableScales["MinorPentatonic"]        
        vc!.ResultsLabel0.text = "Minor Pentatonic"
        
//        var chord = [String]()
//        if (randScale.key != "Chromatic")
//        {
//            for (_,item) in randScale.value.enumerated()
//            {
//                if (item.contains("1") || item.contains("3") || item.contains("5"))
//                {
//                    chord.append(item)
//                }
//            }
//        }
        
         vc!.specifiedScale.removeAll()
        
        //find note index
        if ( vc!.specifiedScale.isEmpty)
        {
            for (i, item) in refScale.enumerated()
            {
                if (startingNote == item)
                {
                    noteIndex = i
                    break
                }
            }
            
            for (i, _) in randScale!.enumerated()
            {
                let note = scaleDegreeDict[randScale![i]]
                if ((noteIndex+note!) >= refScale.count*notePos)
                {
                    notePos = notePos + 1
                }
                 vc!.specifiedScale.append(refScale[(noteIndex+note!)%refScale.count] + String(notePos+startingOctave))
            }
            
            if (scaleOctaves > 1)
            {
                for item in vc!.specifiedScale
                {
                    let noteName = item.count == 2 ? item.prefix(1) : item.prefix(2)
                    let pitch = Int(item.suffix(1))! + 1
                    let newNote = noteName + String(pitch)
                    vc!.specifiedScale.append(String(newNote))
                }
            }
            else if (startingOctave > 0)
            {
                let tempArr = vc!.specifiedScale
                vc!.specifiedScale.removeAll()
                for item in tempArr
                {
                    let noteName = item.count == 2 ? item.prefix(1) : item.prefix(2)
                    let pitch = Int(item.suffix(1))! + 1
                    let newNote = noteName + String(pitch)
                    vc!.specifiedScale.append(String(newNote))
                }
            }
            
            //add last octave
            let noteName = vc!.specifiedScale[0].count == 2 ? vc!.specifiedScale[0].prefix(1) : vc!.specifiedScale[0].prefix(2)
            let pitch = Int(vc!.specifiedScale[0].suffix(1))! + scaleOctaves;
            let newNote = noteName + String(pitch)
            vc!.specifiedScale.append(String(newNote))
            
            var i = 0
            for (item) in vc!.specifiedScale.reversed()
            {
                if (i > 0)
                {
                    vc!.specifiedScale.append(item)
                }
                i = i +  1
            }
        }
    }
}
