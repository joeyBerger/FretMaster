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
        
        "PentatonicModeIII": "Pent. Mode III",
        "PentatonicModeIV": "Pent. Mode IV",
        "PentatonicModeV": "Pent. Mode V",
        "DiminishedWholeHalf": "Dim. Whole Half",
        "DiminishedHalfWhole": "Dim. Half Whole",
        "WholeTone": "Whole Tone",
        "HarmonicMinor": "Harmonic Minor",
        "Locrian6": "Locrian 6",
        "Ionian#5": "Ionian #5",
        "Dorian#4": "Dorian #4",
        "PhrygianDominant": "Phrygian Dominant",
        "Lydian#2": "Lydian #2",
        "SuperLocrianbb7": "Super Locrian bb7",
        "MelodicMinor": "Melodic Minor",
        "Dorianb2": "Dorian b2",
        "LydianAugmented": "Lydian Augmented",
        "LydianDominant": "Lydian Dominant",
        "Mixoldianb6": "Mixoldian b6",
        "SuperLocrian": "Super Locrian",
        "DiminishedWholeTone": "Dim. Whole Tone",
        "Arabian": "Arabian",
        "Persian": "Persian",
        "Byzantine": "Byzantine",
        "Japanese": "Japanese",
        "Hirajoshi": "Hirajoshi",
        "RagaAsavari": "Raga Asavari",
        "Hungarian": "Hungarian",
        "Romanian": "Romanian",
        "Hijaz": "Hijaz",
        
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
        "PentatonicModeIII": ["1","2","4","5","b7"],
        "PentatonicModeIV": ["1","b3","4","b6","b7"],
        "PentatonicModeV": ["1","2","4","5","6"],
        
        "DiminishedWholeHalf" : ["1","2","b3","4","b5","b6","6","7"],
        "DiminishedHalfWhole" : ["1","b2","b3","3","b5","5","6","b7"],
        "WholeTone" : ["1","2","3","b5","b6","b7"],
        
        "HarmonicMinor" : ["1","2","b3","4","5","b6","7"],
        "Locrian6" : ["1","b2","b3","4","b5","6","b7"],
        "Ionian#5" : ["1","2","3","4","b6","6","7"],
        "Dorian#4" : ["1","2","b3","#4","5","6","b7"],
        "PhrygianDominant" : ["1","b2","3","4","5","b6","b7"],
        "Lydian#2" : ["1","b3","3","#4","5","6","7"],
        "SuperLocrianbb7" : ["1","b2","b3","b4","b5","b6","6"],

        "MelodicMinor" : ["1","2","b3","4","5","6","7"],
        "Dorianb2" : ["1","b2","b3","4","5","6","b7"],
        "LydianAugmented" : ["1","2","3","#4","b6","6","7"],
        "LydianDominant" : ["1","2","3","#4","5","6","b7"],
        "Mixoldianb6" : ["1","2","3","4","5","b6","b7"],
        "SuperLocrian" : ["1","2","b3","4","b5","b6","b7"],
        "DiminishedWholeTone" : ["1","b2","b3","3","b5","b6","b7"],

        "Arabian" : ["1","2","b3","4","#4","#5","6","7"],
        "Persian" : ["1","b2","3","4","b5","b6","7"],
        "Byzantine" : ["1","b2","3","4","5","b6","7"],
        "Japanese" : ["1","2","4","5","b6"],
        "Hirajoshi" : ["1","2","b3","5","b6"],
        "RagaAsavari" : ["1","b2","4","5","b6"],
        "Hungarian" : ["1","2","b3","#4","5","b6","7"],
        "Romanian" : ["1","2","b3","#4","5","6","b7"],
        "Hijaz" : ["1","b2","3","4","5","b6","b7"],

        "MajorArp": ["1", "3", "5"],
        "MinorArp": ["1", "b3", "5"],
        "DiminishedArp": ["1", "b3", "b5"],
        "AugmentedArp": ["1", "3", "#5"],

        "MajorSeventhArp": ["1", "3", "5", "7"],
        "DominantSeventh": ["1", "3", "5", "b7"],
        "MinorSeventhArp": ["1", "b3", "5", "b7"],
        "MinorMajorSeventhArp": ["1", "b3", "5", "7"],
        "HalfDiminishedArp": ["1", "b3", "b5", "b7"],
        "FullyDiminishedArp": ["1", "b3", "b5", "6"],

        "Chromatic": ["1", "b2", "2", "b3", "3", "4", "#4", "5", "#5", "6", "b7", "7"],
    ]
    
    let fretOffsetToImage : [String] = [
        "FretBoardNut",
        "FretBoardOffDot",
        "FretBoardOnDot",
        "FretBoardOffDot",
        "FretBoardOnDot",
        "FretBoardOffDot",
        "FretBoardOnDot",
        "FretBoard8thPos",
        "FretBoard9thPos",
        "FretBoard10thPos",
        "FretBoard11thPos",
        "FretBoard12thPos",
    ]
    
    let fretPositionAccidentalInheritence: [PositionType] = [
        PositionType.Sharp,
        PositionType.Flat,
        PositionType.Sharp,
        PositionType.Flat,
        PositionType.Flat,
        PositionType.Sharp,
        PositionType.Flat,
        PositionType.Sharp,
        PositionType.Sharp,
        PositionType.Sharp,
        PositionType.Sharp,
        PositionType.Flat,
        PositionType.Sharp,
    ]
    
    let flatEquivalent: [String:String] = [
        "C" : "C", "C#" : "Db", "D" : "D", "D#" : "Eb", "E" : "E", "F" : "F", "F#" : "Gb", "G" : "G", "G#" : "Ab", "A" : "A", "A#" : "Bb", "B" : "B"
    ]
    
    enum PositionType: String {
        case Sharp
        case Flat
    }

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
        let parsedInput = iinput.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789:"))
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
            let desiredNoteCollection = availableScales[parsedInput]
            
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
        
        if idata["sequence"] != nil {
            var sequenceArr: [String] = []
            for (i,_) in newNoteCollection.enumerated() {
                sequenceArr.append(newNoteCollection[i])
                if newNoteCollection.indices.contains(i+2) {
                    sequenceArr.append(newNoteCollection[i+2])
                } else if (scaleDegreeDict[availableScales[parsedInput]![1]]! < 4) {
                    
                    let note = refScale[(refScale.index(of: "A")!+scaleDegreeDict[availableScales[parsedInput]![1]]!) % refScale.count]
                    let octave = note == "C" ? "4" : "3"
                    sequenceArr.append(note+octave)
                    if (idata["sequence"] as! String).contains("Thirds") {
                        sequenceArr.append("A3")
                    }
                    break
                }
            }
            newNoteCollection = sequenceArr
        }
        
        newNoteCollection = covertDSharpThreeToValidNote(newNoteCollection, parsedInput)
        
        newNoteCollection = tryToAddNoteAboveRoot(newNoteCollection,parsedInput,idirection)
        
        return newNoteCollection
    }
    
    func tryToAddNoteAboveRoot(_ inoteCollection: [String], _ inoteCollectionHeader : String, _ idirection: String) -> [String] {
        var newNotes : [String] = []
        let extensions = ["b2","2","b3"]
        
        for (i,degree) in availableScales[inoteCollectionHeader]!.enumerated() {
            for (j,_) in extensions.enumerated() {
                if degree == extensions[j] {
                    var note = refScale[(9+scaleDegreeDict[degree]!)%refScale.count]
                    note += note == "C" ? "4" : "3"
                    print("note",note)
                    newNotes.append(note)
                }
            }
        }
        if newNotes.count == 0 {
            return inoteCollection
        }
        var modifiedArr = inoteCollection
        var lastModifiedIdx = 0
        for (i,_) in inoteCollection.enumerated() {
            if (inoteCollection[i] == "A3") {
                for (j,additionalNote) in newNotes.enumerated() {
                    lastModifiedIdx = i+1+j
                    modifiedArr.insert(additionalNote, at: i+1+j)
                }
            }
        }
        if idirection == "Both" {
            if newNotes.count > 1 {
                newNotes.remove(at: newNotes.count-1)
                newNotes.reverse()
                for (i,note) in newNotes.enumerated() {
                    lastModifiedIdx = lastModifiedIdx+1+i
                    modifiedArr.insert(note, at: lastModifiedIdx)
                }
            }
            modifiedArr.insert("A3", at: lastModifiedIdx+1)
        }
        return modifiedArr
    }
    
    func covertDSharpThreeToValidNote(_ inoteCollection: [String], _ inoteCollectionHeader : String) -> [String] {
        var modifiedArr = inoteCollection
        let convertToSharpFourCollections = ["DiminishedWholeHalf"]
        for (i,note) in modifiedArr.enumerated() {
            if note == "D#3" {
                modifiedArr[i] = (availableScales[inoteCollectionHeader]?.contains("b5"))! ? "D#3_0" : "D#3_1"
                for noteCollection in convertToSharpFourCollections {
                    if inoteCollectionHeader == noteCollection {
                        modifiedArr[i] = "D#3_1"
                    }
                }
            }
        }
        return modifiedArr
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
        let parsedInput = iinput.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789:"))
        return scaleNameDict[parsedInput]!
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
        if iinput == "1" {
            return "st"
        } else if iinput == "2" {
            return "nd"
        } else if iinput == "3" {
            return "rd"
        } else if iinput.contains("Unison") || iinput.contains("Octave") {
            return ""
        }
        return "th"
    }
    
    func stripNoteQualifier(_ iinput: String) -> String {
        return iinput.replacingOccurrences(of: "_0", with: "").replacingOccurrences(of: "_1", with: "")
    }
    
    func returnOffsetFretNote(_ iinput: String, _ ifretOffest: Int) -> String {
        if ifretOffest == 0 {
            return iinput
        }
        var octave = parseNoteOctave(stripNoteQualifier(iinput))
        let convertedNote = parseCoreNote(stripNoteQualifier(iinput))
        var idx = refScale.firstIndex(of: convertedNote)
        let qualifier = iinput.contains("_") ? iinput.contains("0") ? "_0" : "_1" : ""
        idx = (idx! + ifretOffest)
        if idx! < 0 {
            idx = refScale.count + idx!
            octave -= 1
        } else if idx! >= refScale.count {
            idx = idx!%refScale.count
            octave += 1
        }
        if idx == 12 {
            print("")
        }
        return "\(refScale[idx!])\(octave)\(qualifier)"
    }
    
    func parseCoreNote(_ iinput: String ) -> String {
        return String(iinput.dropLast())
    }
    
    func parseNoteOctave(_ iinput: String) -> Int {
        let strippedNote = stripNoteQualifier(iinput)
        return Int(strippedNote.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!
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
