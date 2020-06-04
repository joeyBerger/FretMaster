import Foundation

class ScaleCollection {
    var vc: MainViewController?

    init(ivc: MainViewController) {
        vc = ivc
    }

    let refScale: [String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    let scaleDegreeDict: [String: Int] = [
        "1": 0,
        "b2": 1,
        "2": 2,
        "b3": 3,
        "3": 4,
        "4": 5,
        "#4": 6,
        "b5": 6,
        "5": 7,
        "#5": 8,
        "b6": 8,
        "6": 9,
        "b7": 10,
        "7": 11,
    ]
    
    let intervals: [String] = [
        "Unison",
        "b2",
        "2",
        "b3",
        "3",
        "4",
        "b5",
        "5",
        "b6",
        "6",
        "b7",
        "7",
        "Octave",
        "b9",
        "9",
        "b10",
        "10",
        "11",
        "b12",
        "12",
        "b13",
        "13",
        "b14",
        "14",
        "Octave",
        "b16",
        "16",
        "b17",
        "17",
    ]

    let scaleNameDict: [String: String] = [
        "MinorPentatonic": "Minor Pentatonic",
        "MajorPentatonic": "Major Pentatonic",
        "Ionian": "Ionian",
        "Dorian": "Dorian",
        "Phyrgian": "Phyrgian",
        "Lydian": "Lydian",
        "Mixolydian": "Mixolydian",
        "Aeolian": "Aeolian",
        "Locrian": "Locrian",
        "Chromatic": "Chromatic",
        "MajorArp": "Major Arpeggio",
        "MinorArp": "Minor Arpeggio",
        "MajorSeventhArp": "Major7th Arpeggio",
        "MinorSeventhArp": "Minor7th Arpeggio",
        "DiminishedArp": "Diminished Arpeggio",
        "AugmentedArp": "Augmented Arpeggio",
    ]

    let availableScales: [String: [String]] = [
        "Ionian": ["1", "2", "3", "4", "5", "6", "7"],
        "Dorian": ["1", "2", "b3", "4", "5", "6", "b7"],
        "Phyrgian": ["1", "b2", "b3", "4", "5", "b6", "b7"],
        "Lydian": ["1", "2", "3", "#4", "5", "6", "7"],
        "Mixolydian": ["1", "2", "3", "4", "5", "6", "b7"],
        "Aeolian": ["1", "2", "b3", "4", "5", "b6", "b7"],
        "Locrian": ["1", "b2", "b3", "4", "b5", "b6", "b7"],
        "MinorPentatonic": ["1", "b3", "4", "5", "b7"],
        "MajorPentatonic": ["1", "2", "3", "5", "6"],

        "MajorArp": ["1", "3", "5"],
        "MinorArp": ["1", "b3", "5"],
        "DiminishedArp": ["1", "b3", "b5"],
        "AugmentedArp": ["1", "3", "#5"],

        "MajorSeventhArp": ["1", "3", "5", "7"],
        "MinorSeventhArp": ["1", "b3", "5", "b7"],

        "Chromatic": ["1", "b2", "2", "b3", "3", "4", "#4", "5", "#5", "6", "b7", "7"],
    ]

    var startingOctave = 0
    var scaleOctaves = 2
    
    func parseIntervalNotes(_ istartingNote: String,_ istartingOctave: Int,_ iavailableNotes: [String]) -> [String] {
        var returnArr : [String] = []
        returnArr.append(istartingNote+String(istartingOctave))
        if let inputIndex = refScale.firstIndex(of: istartingNote) {
            for noteInfo in iavailableNotes {
                let distance = noteInfo.replacingOccurrences(of: "Up_", with: "").replacingOccurrences(of: "Down_", with: "")
                var newNoteIdx = noteInfo.contains("Up") ? inputIndex + scaleDegreeDict[distance]! : inputIndex - scaleDegreeDict[distance]!
                let octave = newNoteIdx >= refScale.count ? istartingOctave + 1 : newNoteIdx < 0 ? istartingOctave - 1 : istartingOctave
                if newNoteIdx < 0 {
                    newNoteIdx = refScale.count + newNoteIdx                    
                    print("newNoteIdx \(newNoteIdx) \(startingOctave)")
                }
                returnArr.append(refScale[newNoteIdx%refScale.count]+String(octave))
            }
        }
        return returnArr
    }
    
    func returnInterval(_ note0: String, _ note1: String, _ includeLinguisticNumberEquivalent: Bool = true) -> String {
        
        let cleanNote0 = note0.replacingOccurrences(of: "_0", with: "").replacingOccurrences(of: "_1", with: "")
        let cleanNote1 = note1.replacingOccurrences(of: "_0", with: "").replacingOccurrences(of: "_1", with: "")
        
        let coreNote0 = parseCoreNote(cleanNote0)
        let coreOctaveNote0 = parseNoteOctave(cleanNote0)
        let coreNote1 = parseCoreNote(cleanNote1)
        let coreOctaveNote1 = parseNoteOctave(cleanNote1)
        
        var interval = ""
        let note0Idx = refScale.firstIndex(of: coreNote0)
        let note1Idx = refScale.firstIndex(of: coreNote1)
        
        let convertedNote0 = note0Idx!+12*coreOctaveNote0
        let convertedNote1 = note1Idx!+12*coreOctaveNote1
        let distance = abs(convertedNote0 - convertedNote1)
        //let distance = abs(note0Idx!+12*coreOctaveNote0 - note1Idx!+12*coreOctaveNote1)
        
        interval = intervals[distance]
        if includeLinguisticNumberEquivalent {interval += returnLinguisticNumberEquivalent(interval)}
        if coreOctaveNote0 > coreOctaveNote1 {
            interval += " Down"
        } else if coreOctaveNote0 == coreOctaveNote1 {
            if note0Idx! > note1Idx! {
                interval += " Down"
            } else {
                interval += " Up"
            }
        } else {
            interval += " Up"
        }
        return interval
    }

    func setupSpecifiedNoteCollection(iinput: String, idirection: String, istartingNote: String = "A", itype: String = "standard", idata: [String:Any] = [:]) -> [String] {
        let startingNote = istartingNote.rangeOfCharacter(from: .decimalDigits) == nil ? istartingNote : parseCoreNote(istartingNote)
        var noteIndex = 0
        var notePos = 1

//        vc!.specifiedNoteCollection.removeAll()
        var newNoteCollection: [String] = []

        for (i, item) in refScale.enumerated() {
            if startingNote == item {
                noteIndex = i
                break
            }
        }
        
        if itype == "interval" {
            newNoteCollection = parseIntervalNotes(startingNote, parseNoteOctave(istartingNote), idata["intervalsToTest"] as! [String])
            print("final specified notes \(newNoteCollection)")
        }
        
        // find note index
        else if itype == "standard" {
            let desiredNoteCollection = availableScales[iinput]
            
            for (i, _) in desiredNoteCollection!.enumerated() {
                let note = scaleDegreeDict[desiredNoteCollection![i]]
                if (noteIndex + note!) >= refScale.count * notePos {
                    notePos = notePos + 1
                }
                newNoteCollection.append(refScale[(noteIndex + note!) % refScale.count] + String(notePos + startingOctave))
            }

            if scaleOctaves > 1 {
                for item in newNoteCollection {
                    let noteName = item.count == 2 ? item.prefix(1) : item.prefix(2)
                    let pitch = Int(item.suffix(1))! + 1
                    let newNote = noteName + String(pitch)
                    newNoteCollection.append(String(newNote))
                }
            } else if startingOctave > 0 {
                let tempArr = newNoteCollection
                newNoteCollection.removeAll()
                for item in tempArr {
                    let noteName = item.count == 2 ? item.prefix(1) : item.prefix(2)
                    let pitch = Int(item.suffix(1))! + 1
                    let newNote = noteName + String(pitch)
                    newNoteCollection.append(String(newNote))
                }
            }

            // add last octave
            let noteName = newNoteCollection[0].count == 2 ? newNoteCollection[0].prefix(1) : newNoteCollection[0].prefix(2)
            let pitch = Int(newNoteCollection[0].suffix(1))! + scaleOctaves
            let newNote = noteName + String(pitch)
            newNoteCollection.append(String(newNote))

            if idirection == "Down" {
                newNoteCollection = newNoteCollection.reversed()
            } else if idirection == "Both" {
                var i = 0
                for item in newNoteCollection.reversed() {
                    if i > 0 {
                        newNoteCollection.append(item)
                    }
                    i = i + 1
                }
            }
        }
        return newNoteCollection
    }

    func returnNoteDistance(iinput: String, icomparedNote: String) -> String {
        if let inputIndex = refScale.firstIndex(of: iinput) {
            if let comparedNoteIndex = refScale.firstIndex(of: icomparedNote) {
                let dist = inputIndex < comparedNoteIndex ? (12 + inputIndex) - comparedNoteIndex : inputIndex - comparedNoteIndex
                return scaleDegreeDict.filter { $1 == dist }.map { $0.0 }[0]
            }
        }
        return ""
    }

    func returnReadableScaleName(iinput: String) -> String {
        return scaleNameDict[iinput]!
    }

    func analyzeNotes(iscaleTestData: [MainViewController.InputData]) -> Bool {
        if iscaleTestData.count != vc!.specifiedNoteCollection.count {
            return false
        }
        for (i, item) in iscaleTestData.enumerated() {
            if item.note != vc!.specifiedNoteCollection[i] {
                return false
            }
        }
        return true
    }
    
    func returnLinguisticNumberEquivalent(_ iinput:String) -> String {
        if iinput.contains("2") {
            return "nd"
        } else if iinput.contains("3") {
            return "rd"
        } else if iinput.contains("Unison") || iinput.contains("Octave") {
            return ""
        }
        return "th"
    }
    
    func parseCoreNote(_ iinput: String ) -> String {
        return String(iinput.dropLast())
    }
    
    func parseNoteOctave(_ iinput: String) -> Int {
        return Int(iinput.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!
    }
}

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
