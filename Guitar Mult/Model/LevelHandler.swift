import UIKit

class LevelConstruct: UIViewController {
    var currentLevel: String?
    var currentLevelConstruct: [[String]] = [[]]
    var currentLevelKey: String?

    func analyzeNewLevel(itestPassed: Bool, idevelopmentMode: Int) -> [String: Bool] {
        var returnDict: [String: Bool] = [
            "SubLevelIncremented": false,
            "LevelIncremented": false,
            "SubLevelMaxReached" : false,
            "LevelComplete" : false
        ]
        
        if !itestPassed, idevelopmentMode < 2 {
            return returnDict
        }
        var level = returnConvertedLevel(iinput: currentLevel!)
        var subLevel = returnConvertedSubLevel(iinput: currentLevel!) + 1
        
        var subLevelMax = 0
        if (currentLevelKey!.contains("interval")) {
            subLevelMax = returnEarTrainingLevelTotalSubLevelAmount(level)
            if returnCurrentEarTrainingIndex()+1 == Int(parseEarTrainingData(returnCurrentTask())["Total"] as! String)! {
                returnDict["SubLevelMaxReached"] = true
            }
        } else {
            subLevelMax = currentLevelConstruct[level].count
        }

        if subLevel == subLevelMax {
            returnDict["LevelIncremented"] = true
            // upgrade level
            let levelLength = currentLevelKey!.contains("scale") ? scale.count : currentLevelKey!.contains("interval") ? interval.count :  arpeggio.count
            if level < levelLength - 1 {
                level = level + 1
                subLevel = 0
            } else {
                returnDict["LevelComplete"] = true
                returnDict["LevelIncremented"] = false
            }
        }
        
        if currentLevelKey!.contains("interval") && level == interval.count {
            print("here")
        }

        currentLevel = "\(level).\(subLevel)"
        print("currentLevel",currentLevel)
        UserDefaults.standard.set(currentLevel, forKey: currentLevelKey!)
        returnDict["SubLevelIncremented"] = true
        return returnDict
    }

    func setLevelVars(icurrentLevel: String, icurrentLevelConstruct: [[String]], icurrentLevelKey: String) {
        currentLevel = icurrentLevel
        currentLevelConstruct = icurrentLevelConstruct
        currentLevelKey = icurrentLevelKey
    }

    func returnEarTrainingLevelTotalSubLevelAmount(_ ilevel: Int) -> Int {
        var maxSubLevels = 0;
        for (i,_) in currentLevelConstruct[ilevel].enumerated() {
            maxSubLevels += Int(parseEarTrainingData(currentLevelConstruct[ilevel][i])["Total"] as! String)!
        }
        return maxSubLevels
    }
    
    func resetOnEarTrainingTestFail() {
        let level = returnConvertedLevel(iinput: currentLevel!)
        let sublevel = returnConvertedSubLevel(iinput: currentLevel!)
        var total = 0
        if sublevel > 0 {
            for i in 0 ..< interval[level].count-1 {
                let currentSubLevelTotal =  Int(parseEarTrainingData(interval[level][i])["Total"] as! String)!
                let subLevelTotal = total + currentSubLevelTotal
                if subLevelTotal > sublevel {
                    break
                } else {
                    if total < sublevel {
                        total += currentSubLevelTotal
                    }
                }
            }
        }
        currentLevel = "\(level).\(total)"
        print("\(level).\(total)")
        UserDefaults.standard.set(currentLevel, forKey: currentLevelKey!)
    }
    
    func setEarTrainingLevelHelper() {
        currentLevel = "\(2).\(8)"
        UserDefaults.standard.set(currentLevel, forKey: currentLevelKey!)
    }
    
    func returnCurrentTask() -> String {
        let level = returnConvertedLevel(iinput: currentLevel!)
        var subLevel = returnConvertedSubLevel(iinput: currentLevel!)

        if (currentLevelKey!.contains("interval")) {
            for (i,_) in currentLevelConstruct[level].enumerated() {
                let maxSubLevels = Int(parseEarTrainingData(currentLevelConstruct[level][i])["Total"] as! String)!
                if subLevel < maxSubLevels {
                    subLevel = i
                    break;
               }
               subLevel = subLevel - maxSubLevels
            }
            return currentLevelConstruct[level][subLevel]
        }
        
        // make sure the current level/sublevel is not out of range
        if currentLevelConstruct[level].count > subLevel {
            return currentLevelConstruct[level][subLevel]
        }

        // level/sublevel is out of range, return last task in construct
        return currentLevelConstruct[level][currentLevelConstruct[level].count - 1]
    }
    
    func returnCurrentEarTrainingIndex() -> Int {
        let level = returnConvertedLevel(iinput: currentLevel!)
        var subLevel = returnConvertedSubLevel(iinput: currentLevel!)
        
        for (i,_) in currentLevelConstruct[level].enumerated() {
            let maxSubLevels = Int(parseEarTrainingData(currentLevelConstruct[level][i])["Total"] as! String)!
            if subLevel < maxSubLevels {
                return subLevel
           }
           subLevel = subLevel - maxSubLevels
        }
        return 0
    }

    func returnConvertedLevel(iinput: String) -> Int {
        let numb = Int(iinput.split(separator: ".")[0])
        return numb!
    }

    func returnConvertedSubLevel(iinput: String) -> Int {
        let numb = Int(iinput.split(separator: ".")[1])
        return numb!
    }

    func returnTotalProgress(ilevel: Int, isubLevel: Int, ilevelConstruct: [[String]]) -> Float {
        var subLevels = 0
        var totalLevels = 0
        for (i, item) in ilevelConstruct.enumerated() {
            for (j, _) in item.enumerated() {
                if ilevel >= i && isubLevel > j || ilevel > i, ilevel > 0 || isubLevel > 0 {
                    subLevels += 1
                }
                totalLevels += 1
            }
        }
        return Float(subLevels) / Float(totalLevels)
    }
    
    func parseEarTrainingData(_ input:String) -> [String:Any] {
        var returnDict: [String:Any] = [:]
        let outsideSplitChar = "!", insideSplitChar = ":"
        let splitArr = input.components(separatedBy: outsideSplitChar)
        let ids = ["Direction","Total","StartingNote","Tempo"]
        for info in splitArr {
            for id in ids {
                if info.contains(id) {
                    let splitInfo = info.components(separatedBy: insideSplitChar)
                    returnDict[id] = splitInfo[1]
                }
            }
        }
        return returnDict
    }
    
    func parseIntervalDirection(_ input:String) -> [String] {
        var returnArr:[String] = []
        let collectionSplitChar = ","
        let directions = ["Up_","Down_","Both_"]
        
        for direction in directions {
            if input.contains(direction) {
                let collection = input.replacingOccurrences(of: direction, with: "")
                let collectionArr = collection.components(separatedBy: collectionSplitChar)
                for item in collectionArr {
                    if direction.contains("Both_") {
                        returnArr.append("Up_" + item)
                        returnArr.append("Down_" + item)
                    } else {
                        returnArr.append(direction + item)
                    }
                }
            }
        }
        return returnArr
    }

    let currentLevelName: [String: [String]] = [
        "scales": [
            "Tutorial",
            "Maj Pentatonic",
            "Maj/Min Scale",
            "Pentatonic And Maj/Min",
            "Previous Up/Down",
            "Previous Up/Down, 120 BPM",
            "Pentatonic Modes Up",
            "Pent Modes Up/Down",
            "Pent Modes Up/Down, 120 BPM",
            "Previous Random, 120 BPM",
            "All Modes Up/Down",
            "All Modes Random",
            "All Modes Random, 120 BPM",
            "All Modes Random, 150 BPM",
            "All Modes Random, 180 BPM",
            "Maj/Min Scales In 3rds",
            "All Modes In 3rds",
            "All Modes In 3rds Random",
            "All Modes In 3rds Random",
            "Previous 120 BPM Random",
            "Previous 150 BPM Random",
            "Previous 180 BPM Random",
            "HarmonicM/Melodic Min Up",
            "HarmonicM/Melodic Min Up/Down",
            "Previous, 120 BPM",
            "Minor Scales Up/Down Random",
            "Minor Scales Up/Down 150 BPM Random",
            "Minor Scales Up/Down 180 BPM Random",
            "Dim And Whole Tone Up",
            "Previous, Up/Down",
            "Dim And Whole Tone, 150 BPM Random",
            "Dim And Whole Tone, 180 BPM Random",
            "Melodic Minor Modes Up",
            "Melodic Minor Modes Up/Down",
            "Melodic Minor Modes, 160 BPM",
            "Melodic Minor Modes, 180 BPM Random",
            "Harmonic Minor Modes Up",
            "Harmonic Minor Modes Up/Down",
            "Harmonic Minor Modes, 160 BPM",
            "Harmonic Minor Modes, 180 BPM Random",
            "World Music Scales Up",
            "World Music Scales Up/Down",
            "All Scales Up/Down",
            "All Scales, 180 BPM",
            "All Scales, 230 BPM",
        ],
        "arpeggios": [ //41
            "Maj/Min",
            "Maj/Min-7th",
            "Previous Up",
            "Previous Up/Down",
            "Previous Up/Down, 120 BPM",
            "Dom,MinMaj7th Up",
            "Previous Up/Down",
            "Previous Up, 120 BPM",
            "Previous Up/Down, 120 BPM",
            "Maj,Min,Dom,MinMaj-7th Up/Down",
            "Previous Up/Down, 120 BPM",
            "Previous Up/Down, 160 BPM",
            "HalfDim,FullDim-7th",
            "Previous Up/Down",
            "Previous Up, 120 BPM",
            "Previous Up/Down, 120 BPM",
            "Dom,MinMaj,HalfDim,FullDim-7th Up/Down",
            "Previous Up/Down, 160 BPM",
            "All 7th Arpeggios Up/Down, 180 BPM",
            "Maj Inversions Up",
            "Min Inversions Up",
            "Maj Inversions Up/Down",
            "Min Inversions Up/Down",
            "Maj/Min Inversions Up/Down, 120 BPM",
            "Maj-7th Inversions Up",
            "Min-7th Inversions Up",
            "Maj-7th Inversions Up/Down",
            "Min-7th Inversions Up/Down",
            "Maj/Min-7th Inversions Up/Down, 120 BPM",
            "Dom-7th Inversions Up",
            "MajMin-7th Inversions Up",
            "Dom-7th Inversions Up/Down",
            "MajMin-7th Inversions Up/Down",
            "Dom/MajMin-7th Inversions Up/Down, 120 BPM",
            "HalfDim-7th Inversions Up",
            "HalfDim-7th Inversions Up/Down",
            "HalfDim-7th Inversions Up/Down 120 BPM",
            "All Arpeggios Up/Down, 160 BPM",
            "All Arpexggios Up/Down, 200 BPM",
        ],
        "intervals": [
            "Intervals: 2, 3, 5 Up",
            "2, 3, 5 Down",
            "2, 3, 5 Up/Down",
            "b2, 2, b3, 3 Up/Down",
            "4, 5 Up/Down",
            "b2,2,b3,3,4,5 Up/Down",
            "b6,6,b7,7 Up/Down",
            "b5, 5 Up/Down",
            "b5,5,b6,b7,7 Up/Down",
            "2,3,4,5,6,7 Up/Down",
            "2,b3,4,5,b6,b7 Up/Down",
            "4,5,Octave Up/Down",
            "All Intervals Up/Down",
            "All Intervals Random Start",
        ]
    ]

    let scale = [
         ["MinorPentatonic_Up"],
         ["MajorPentatonic_Up"],
         ["Ionian_Up", "Aeolian_Up"],
         ["MinorPentatonic_Both", "MajorPentatonic_Both", "Ionian_Both", "Aeolian_Both"],
         ["Ionian_Both", "MajorPentatonic_Both", "Aeolian_Both", "MinorPentatonic_Both"],
         ["MinorPentatonic_Both_Tempo:120", "MajorPentatonic_Both_Tempo:120", "Ionian_Both_Tempo:120", "Aeolian_Both_Tempo:120"],
         ["PentatonicModeIII_Up","PentatonicModeIV_Up","PentatonicModeV_Up"],
         ["MinorPentatonic_Both", "MajorPentatonic_Both","PentatonicModeIII_Both","PentatonicModeIV_Both","PentatonicModeV_Both"],
         ["MinorPentatonic_Both_Tempo:120", "MajorPentatonic_Both_Tempo:120","PentatonicModeIII_Both_Tempo:120","PentatonicModeIV_Both_Tempo:120","PentatonicModeV_Both_Tempo:120"],
         ["PentatonicModeIV_Both_Tempo:120", "PentatonicModeIII_Both_Tempo:120","MajorPentatonic_Both_Tempo:120","PentatonicModeV_Both_Tempo:120","MinorPentatonic_Both_Tempo:120"], //random
         ["Ionian_Both", "Dorian_Both", "Phyrgian_Both", "Lydian_Both", "Mixolydian_Both", "Aeolian_Both", "Locrian_Both"],
         ["Dorian_Both", "Mixolydian_Both", "Ionian_Both", "Phyrgian_Both", "Locrian_Both", "Aeolian_Both", "Lydian_Both"], //random
         ["Lydian_Both_Tempo:120", "Aeolian_Both_Tempo:120", "Phyrgian_Both_Tempo:120", "Ionian_Both_Tempo:120", "Mixolydian_Both_Tempo:120", "Locrian_Both_Tempo:120", "Dorian_Both_Tempo:120"], //random
        ["Ionian_Both_Tempo:150", "Phyrgian_Both_Tempo:150", "Mixolydian_Both_Tempo:150",   "Dorian_Both_Tempo:150", "Aeolian_Both_Tempo:150", "Locrian_Both_Tempo:150", "Lydian_Both_Tempo:150"], //random
         ["Dorian_Both_Tempo:180", "Aeolian_Both_Tempo:180", "Lydian_Both_Tempo:180", "Ionian_Both_Tempo:180", "Phyrgian_Both_Tempo:180", "Locrian_Both_Tempo:180", "Mixolydian_Both_Tempo:180"], //random
         ["Ionian_Up_Sequence:Thirds","Aeolian_Up_Sequence:Thirds"],
         ["Ionian_Up_Sequence:Thirds","Dorian_Up_Sequence:Thirds","Phyrgian_Up_Sequence:Thirds","Lydian_Up_Sequence:Thirds","Mixolydian_Up_Sequence:Thirds","Aeolian_Up_Sequence:Thirds","Locrian_Up_Sequence:Thirds"],
         ["Lydian_Up_Sequence:Thirds", "Phyrgian_Up_Sequence:Thirds", "Mixolydian_Up_Sequence:Thirds", "Ionian_Up_Sequence:Thirds", "Dorian_Up_Sequence:Thirds", "Aeolian_Up_Sequence:Thirds", "Locrian_Up_Sequence:Thirds"],  //random
        ["Ionian_Up_Sequence:Thirds", "Locrian_Up_Sequence:Thirds", "Mixolydian_Up_Sequence:Thirds", "Dorian_Up_Sequence:Thirds", "Aeolian_Up_Sequence:Thirds", "Lydian_Up_Sequence:Thirds", "Phyrgian_Up_Sequence:Thirds"],  //random
        ["Phyrgian_Up_Tempo:120_Sequence:Thirds", "Ionian_Up_Tempo:120_Sequence:Thirds", "Mixolydian_Up_Tempo:120_Sequence:Thirds", "Dorian_Up_Tempo:120_Sequence:Thirds", "Locrian_Up_Tempo:120_Sequence:Thirds", "Aeolian_Up_Tempo:120_Sequence:Thirds", "Lydian_Up_Tempo:120_Sequence:Thirds"],  //random
        ["Dorian_Up_Tempo:150_Sequence:Thirds", "Aeolian_Up_Tempo:150_Sequence:Thirds", "Ionian_Up_Tempo:150_Sequence:Thirds", "Phyrgian_Up_Tempo:150_Sequence:Thirds", "Mixolydian_Up_Tempo:150_Sequence:Thirds", "Locrian_Up_Tempo:150_Sequence:Thirds", "Lydian_Up_Tempo:150_Sequence:Thirds"],  //random
        ["Phyrgian_Up_Tempo:180_Sequence:Thirds", "Aeolian_Up_Tempo:180_Sequence:Thirds", "Lydian_Up_Tempo:180_Sequence:Thirds", "Dorian_Up_Tempo:180_Sequence:Thirds", "Locrian_Up_Tempo:180_Sequence:Thirds", "Ionian_Up_Tempo:180_Sequence:Thirds", "Mixolydian_Up_Tempo:180_Sequence:Thirds"],  //random
         ["HarmonicMinor_Up","MelodicMinor_Up"],
         ["HarmonicMinor_Both","MelodicMinor_Both"],
         ["MelodicMinor_Both_Tempo:120","HarmonicMinor_Both_Tempo:120"],
         ["HarmonicMinor_Both", "Phyrgian_Both", "Locrian_Both", "Aeolian_Both", "MelodicMinor_Both"],   //random
         ["Phyrgian_Both_Tempo:150", "Locrian_Both_Tempo:150", "HarmonicMinor_Both_Tempo:150", "MelodicMinor_Both_Tempo:150", "Aeolian_Both_Tempo:150"], //random
         ["Locrian_Both_Tempo:180", "Phyrgian_Both_Tempo:180", "Aeolian_Both_Tempo:180", "HarmonicMinor_Both_Tempo:180", "MelodicMinor_Both_Tempo:180"], //random
         ["DiminishedWholeHalf_Up","DiminishedHalfWhole_Up","WholeTone_Up"],
         ["DiminishedWholeHalf_Both","DiminishedHalfWhole_Both","WholeTone_Both"],
         ["WholeTone_Both_Tempo:180","DiminishedHalfWhole_Both_Tempo:150","DiminishedWholeHalf_Both_Tempo:150"],   //random
        ["DiminishedWholeHalf_Both_Tempo:180","DiminishedHalfWhole_Both_Tempo:180","WholeTone_Both_Tempo:180"],   //random
         ["MelodicMinor_Up","DorianbTwo_Up","LydianAugmented_Up","LydianDominant_Up","MixoldianbSix_Up","SuperLocrian_Up","DiminishedWholeTone_Up"],
         ["MelodicMinor_Both","DorianbTwo_Both","LydianAugmented_Both","LydianDominant_Both","MixoldianbSix_Both","SuperLocrian_Both","DiminishedWholeTone_Both"],
         ["MelodicMinor_Both_Tempo:160","DorianbTwo_Both_Tempo:160","LydianAugmented_Both_Tempo:160","LydianDominant_Both_Tempo:160","MixoldianbSix_Both_Tempo:160","SuperLocrian_Both_Tempo:160","DiminishedWholeTone_Both_Tempo:160"],
         ["SuperLocrian_Both_Tempo:180", "DiminishedWholeTone_Both_Tempo:180", "MelodicMinor_Both_Tempo:180", "LydianAugmented_Both_Tempo:180", "DorianbTwo_Both_Tempo:180", "MixoldianbSix_Both_Tempo:180", "LydianDominant_Both_Tempo:180"],   //random
         ["HarmonicMinor_Up","LocrianSix_Up","Ionian#Five_Up","Dorian#Four_Up","PhrygianDominant_Up","Lydian#Two_Up","SuperLocrianbbSeven_Up"],
         ["HarmonicMinor_Both","LocrianSix_Both","Ionian#Five_Both","Dorian#Four_Both","PhrygianDominant_Both","Lydian#Two_Both","SuperLocrianbbSeven_Both"],
         ["HarmonicMinor_Both_Tempo:160","LocrianSix_Both_Tempo:160","Ionian#Five_Both_Tempo:160","Dorian#Four_Both_Tempo:160","PhrygianDominant_Both_Tempo:160","Lydian#Two_Both_Tempo:160","SuperLocrianbbSeven_Both_Tempo:160"],
         ["LocrianSix_Both_Tempo:180", "Ionian#Five_Both_Tempo:180", "Lydian#Two_Both_Tempo:180", "SuperLocrianbbSeven_Both_Tempo:180", "Dorian#Four_Both_Tempo:180", "HarmonicMinor_Both_Tempo:180", "PhrygianDominant_Both_Tempo:180"],   //random
         ["Arabian_Up","Persian_Up","Byzantine_Up","Japanese_Up","Hirajoshi_Up","RagaAsavari_Up","Hungarian_Up","Romanian_Up","Hijaz_Up"],
         ["Arabian_Both","Persian_Both","Byzantine_Both","Japanese_Both","Hirajoshi_Both","RagaAsavari_Both","Hungarian_Both","Romanian_Both","Hijaz_Both"],
         ["LydianDominant_Both", "DiminishedHalfWhole_Both", "PhrygianDominant_Both", "DiminishedWholeTone_Both", "Ionian_Both", "PentatonicModeV_Both", "Dorian#Four_Both", "LydianAugmented_Both", "MinorPentatonic_Both", "MelodicMinor_Both", "PentatonicModeIII_Both", "DorianbTwo_Both", "Dorian_Both", "Aeolian_Both", "LocrianSix_Both", "WholeTone_Both", "Locrian_Both", "Phyrgian_Both", "Ionian#Five_Both", "Mixolydian_Both", "Lydian#Two_Both", "MajorPentatonic_Both", "Lydian_Both", "DiminishedWholeHalf_Both", "MixoldianbSix_Both", "SuperLocrianbbSeven_Both", "HarmonicMinor_Both", "SuperLocrian_Both", "PentatonicModeIV_Both"],
         ["MinorPentatonic_Both_Tempo:180", "Aeolian_Both_Tempo:180", "Mixolydian_Both_Tempo:180", "Locrian_Both_Tempo:180", "LocrianSix_Both_Tempo:180", "PhrygianDominant_Both_Tempo:180", "MixoldianbSix_Both_Tempo:180", "DiminishedWholeTone_Both_Tempo:180", "LydianAugmented_Both_Tempo:180", "DiminishedWholeHalf_Both_Tempo:180", "PentatonicModeV_Both_Tempo:180", "Dorian#Four_Both_Tempo:180", "Lydian_Both_Tempo:180", "Lydian#Two_Both_Tempo:180", "HarmonicMinor_Both_Tempo:180", "Dorian_Both_Tempo:180", "MelodicMinor_Both_Tempo:180", "WholeTone_Both_Tempo:180", "SuperLocrianbbSeven_Both_Tempo:180", "DiminishedHalfWhole_Both_Tempo:180", "MajorPentatonic_Both_Tempo:180", "Phyrgian_Both_Tempo:180", "PentatonicModeIII_Both_Tempo:180", "Ionian_Both_Tempo:180", "PentatonicModeIV_Both_Tempo:180", "DorianbTwo_Both_Tempo:180", "Ionian#Five_Both_Tempo:180", "LydianDominant_Both_Tempo:180", "SuperLocrian_Both_Tempo:180"],
         ["Aeolian_Both_Tempo:230", "HarmonicMinor_Both_Tempo:230", "Lydian_Both_Tempo:230", "Dorian#Four_Both_Tempo:230", "Ionian_Both_Tempo:230", "Mixolydian_Both_Tempo:230", "MinorPentatonic_Both_Tempo:230", "PhrygianDominant_Both_Tempo:230", "SuperLocrian_Both_Tempo:230", "DiminishedWholeHalf_Both_Tempo:230", "MelodicMinor_Both_Tempo:230", "DiminishedWholeTone_Both_Tempo:230", "SuperLocrianbbSeven_Both_Tempo:230", "MixoldianbSix_Both_Tempo:230", "Ionian#Five_Both_Tempo:230", "PentatonicModeIV_Both_Tempo:230", "Lydian#Two_Both_Tempo:230", "LydianAugmented_Both_Tempo:230", "PentatonicModeV_Both_Tempo:230", "DorianbTwo_Both_Tempo:230", "DiminishedHalfWhole_Both_Tempo:230", "MajorPentatonic_Both_Tempo:230", "Dorian_Both_Tempo:230", "WholeTone_Both_Tempo:230", "Phyrgian_Both_Tempo:230", "LydianDominant_Both_Tempo:230", "LocrianSix_Both_Tempo:230", "Locrian_Both_Tempo:230", "PentatonicModeIII_Both_Tempo:230"]

    ]
    let arpeggio = [
        ["MajorArp_Up", "MinorArp_Up"],
        ["MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["MajorArp_Up", "MinorArp_Up", "MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["MajorArp_Both", "MinorArp_Both", "MajorSeventhArp_Both", "MinorSeventhArp_Both"],

        ["MajorArp_Both_Tempo:120", "MinorArp_Both_Tempo:120", "MajorSeventhArp_Both_Tempo:120", "MinorSeventhArp_Both_Tempo:120"],
        
        ["DominantSeventhArp_Up","MinorMajorSeventhArp_Up"],
        ["DominantSeventhArp_Both","MinorMajorSeventhArp_Both"],
        ["DominantSeventhArp_Up_Tempo:120", "MinorMajorSeventhArp_Up_Tempo:120"],
        ["DominantSeventhArp_Both_Tempo:120", "MinorMajorSeventhArp_Both_Tempo:120"],
        
        ["MajorSeventhArp_Both", "MinorSeventhArp_Both","DominantSeventhArp_Both","MinorMajorSeventhArp_Both"],
        
        ["MajorSeventhArp_Both_Tempo:120", "MinorSeventhArp_Both_Tempo:120","DominantSeventhArp_Both_Tempo:120","MinorMajorSeventhArp_Both_Tempo:120"],
        
        ["MinorMajorSeventhArp_Both_Tempo:160", "MinorSeventhArp_Both_Tempo:160", "MajorSeventhArp_Both_Tempo:160", "DominantSeventhArp_Both_Tempo:160"], //random
        
        ["HalfDiminishedArp_Up","FullDiminishedArp_Up"],
        ["HalfDiminishedArp_Both","FullDiminishedArp_Both"],
        ["HalfDiminishedArp_Up_Tempo:120", "FullDiminishedArp_Up_Tempo:120"],
        ["HalfDiminishedArp_Both_Tempo:120", "FullDiminishedArp_Both_Tempo:120"],
        
        ["DominantSeventhArp_Both","MinorMajorSeventhArp_Both","HalfDiminishedArp_Both","FullDiminishedArp_Both"],
        
        ["DominantSeventhArp_Both_Tempo:160","MinorMajorSeventhArp_Both_Tempo:160","HalfDiminishedArp_Both_Tempo:160","FullDiminishedArp_Both_Tempo:160",],
        
        ["MajorSeventhArp_Both_Tempo:180", "MinorSeventhArp_Both_Tempo:180","DominantSeventhArp_Both_Tempo:180","MinorMajorSeventhArp_Both_Tempo:180","HalfDiminishedArp_Both_Tempo:180","FullDiminishedArp_Both_Tempo:180",],
        
//        ["DominantSeventhArp_Both_Tempo:120", "MajorSeventhArp_Both_Tempo:120", "MinorMajorSeventhArp_Both_Tempo:120", "FullDiminishedArp_Both_Tempo:120", "HalfDiminishedArp_Both_Tempo:120", "MinorSeventhArp_Both_Tempo:120"], //random
        
        ["MajorArp_Up","MajorArp^InversionnOne_Up","MajorArp^InversionnTwo_Up"],
        ["MinorArp_Up","MinorArp^InversionnOne_Up","MinorArp^InversionnTwo_Up"],
        
        ["MajorArp_Both","MajorArp^InversionnOne_Both","MajorArp^InversionnTwo_Both"],
        ["MinorArp_Both","MinorArp^InversionnOne_Both","MinorArp^InversionnTwo_Both"],
        
        ["MinorArp^InversionnTwo_Both_Tempo:120", "MinorArp^InversionnOne_Both_Tempo:120", "MinorArp_Both_Tempo:120", "MajorArp^InversionnOne_Both_Tempo:120", "MajorArp^InversionnTwo_Both_Tempo:120", "MajorArp_Both_Tempo:120",], //random
        
        
        ["MajorSeventhArp_Up","MajorSeventhArp^InversionnOne_Up","MajorSeventhArp^InversionnTwo_Up","MajorSeventhArp^InversionnThree_Up"],
        ["MinorSeventhArp_Up","MinorSeventhArp^InversionnOne_Up","MinorSeventhArp^InversionnTwo_Up","MinorSeventhArp^InversionnThree_Up"],

        ["MajorSeventhArp_Both","MajorSeventhArp^InversionnOne_Both","MajorSeventhArp^InversionnTwo_Both","MajorSeventhArp^InversionnThree_Both"],
        ["MinorSeventhArp_Both","MinorSeventhArp^InversionnOne_Both","MinorSeventhArp^InversionnTwo_Both","MinorSeventhArp^InversionnThree_Both"],

        ["MinorSeventhArp^InversionnTwo_Both_Tempo:120", "MajorSeventhArp_Both_Tempo:120", "MinorSeventhArp^InversionnThree_Both_Tempo:120", "MinorSeventhArp_Both_Tempo:120", "MajorSeventhArp^InversionnThree_Both_Tempo:120", "MajorSeventhArp^InversionnTwo_Both_Tempo:120", "MinorSeventhArp^InversionnOne_Both_Tempo:120", "MajorSeventhArp^InversionnOne_Both_Tempo:120"], //random
        
        ["DominantSeventhArp_Up","DominantSeventhArp^InversionnOne_Up","DominantSeventhArp^InversionnTwo_Up","DominantSeventhArp^InversionnThree_Up"],
        ["MinorMajorSeventhArp_Up","MinorMajorSeventhArp^InversionnOne_Up","MinorMajorSeventhArp^InversionnTwo_Up","MinorMajorSeventhArp^InversionnThree_Up"],

        ["DominantSeventhArp_Both","DominantSeventhArp^InversionnOne_Both","DominantSeventhArp^InversionnTwo_Both","DominantSeventhArp^InversionnThree_Both"],
        ["MinorMajorSeventhArp_Both","MinorMajorSeventhArp^InversionnOne_Both","MinorMajorSeventhArp^InversionnTwo_Both","MinorMajorSeventhArp^InversionnThree_Both"],
        
        ["MinorMajorSeventhArp^InversionnTwo_Both_Tempo:120", "DominantSeventhArp^InversionnThree_Both_Tempo:120", "DominantSeventhArp^InversionnOne_Both_Tempo:120", "MinorMajorSeventhArp^InversionnOne_Both_Tempo:120", "MinorMajorSeventhArp_Both_Tempo:120", "MinorMajorSeventhArp^InversionnThree_Both_Tempo:120", "DominantSeventhArp^InversionnTwo_Both_Tempo:120", "DominantSeventhArp_Both_Tempo:120"], //random
        
        ["HalfDiminishedArp_Up","HalfDiminishedArp^InversionnOne_Up","HalfDiminishedArp^InversionnTwo_Up","HalfDiminishedArp^InversionnThree_Up"],
        ["HalfDiminishedArp_Both","HalfDiminishedArp^InversionnOne_Both","HalfDiminishedArp^InversionnTwo_Both","HalfDiminishedArp^InversionnThree_Both"],
        ["HalfDiminishedArp^InversionnTwo_Both_Tempo:120", "HalfDiminishedArp_Both_Tempo:120", "HalfDiminishedArp^InversionnThree_Both_Tempo:120", "HalfDiminishedArp^InversionnOne_Both_Tempo:120"], //random
        
        ["MajorSeventhArp_Both_Tempo:160", "MajorSeventhArp^InversionnOne_Both_Tempo:160", "MajorArp_Both_Tempo:160", "MinorArp_Both_Tempo:160", "MinorMajorSeventhArp_Both_Tempo:160", "MajorArp^InversionnTwo_Both_Tempo:160", "HalfDiminishedArp^InversionnOne_Both_Tempo:160", "DominantSeventhArp^InversionnOne_Both_Tempo:160", "DominantSeventhArp^InversionnTwo_Both_Tempo:160", "MinorArp^InversionnOne_Both_Tempo:160", "MinorArp_Both_Tempo:160", "MajorArp^InversionnOne_Both_Tempo:160", "MinorMajorSeventhArp^InversionnOne_Both_Tempo:160", "MinorArp^InversionnTwo_Both_Tempo:160", "MinorSeventhArp^InversionnOne_Both_Tempo:160", "MinorMajorSeventhArp^InversionnTwo_Both_Tempo:160", "HalfDiminishedArp_Both_Tempo:160", "MinorArp^InversionnTwo_Both_Tempo:160", "MinorSeventhArp^InversionnTwo_Both_Tempo:160", "DominantSeventhArp_Both_Tempo:160", "MajorSeventhArp^InversionnTwo_Both_Tempo:160", "MajorArp^InversionnTwo_Both_Tempo:160", "MinorArp^InversionnOne_Both_Tempo:160", "MajorArp_Both_Tempo:160", "MinorSeventhArp_Both_Tempo:160", "MajorArp^InversionnOne_Both_Tempo:160", "HalfDiminishedArp^InversionnTwo_Both_Tempo:160"],
        
        
        ["MinorArp^InversionnOne_Both_Tempo:200", "MinorArp^InversionnTwo_Both_Tempo:200", "MinorArp_Both_Tempo:200", "HalfDiminishedArp^InversionnTwo_Both_Tempo:200", "MinorArp^InversionnTwo_Both_Tempo:200", "MajorArp^InversionnTwo_Both_Tempo:200", "MinorArp^InversionnOne_Both_Tempo:200", "HalfDiminishedArp^InversionnOne_Both_Tempo:200", "MajorArp^InversionnOne_Both_Tempo:200", "DominantSeventhArp^InversionnOne_Both_Tempo:200", "MajorSeventhArp_Both_Tempo:200", "MajorArp_Both_Tempo:200", "DominantSeventhArp^InversionnTwo_Both_Tempo:200", "MajorArp^InversionnOne_Both_Tempo:200", "HalfDiminishedArp_Both_Tempo:200", "MajorSeventhArp^InversionnTwo_Both_Tempo:200", "MinorMajorSeventhArp^InversionnTwo_Both_Tempo:200", "MinorSeventhArp^InversionnOne_Both_Tempo:200", "MinorMajorSeventhArp^InversionnOne_Both_Tempo:200", "MajorSeventhArp^InversionnOne_Both_Tempo:200", "MajorArp^InversionnTwo_Both_Tempo:200", "MinorSeventhArp_Both_Tempo:200", "MinorMajorSeventhArp_Both_Tempo:200", "MinorArp_Both_Tempo:200", "MinorSeventhArp^InversionnTwo_Both_Tempo:200", "DominantSeventhArp_Both_Tempo:200", "MajorArp_Both_Tempo:200"],
    ]
    let interval = [

        ["!Direction:Up_2,5!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Up_2,3!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Up_2,3,5!Total:10!StartingNote:A2!Tempo:120",],
        
        ["!Direction:Down_2,5!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Down_2,3!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Down_2,3,5!Total:10!StartingNote:A2!Tempo:120",],
        
        ["!Direction:Both_2,5!Total:10!StartingNote:A2!Tempo:160",
         "!Direction:Both_2,3!Total:10!StartingNote:A2!Tempo:160",
         "!Direction:Both_2,3,5!Total:10!StartingNote:A2!Tempo:160",],
        
        [
        "!Direction:Up_b3,3!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Down_b3,3!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Up_b2,2!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Down_b2,2!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Up_b2,2,b3,3!Total:10!StartingNote:A2!Tempo:120",
//        "!Direction:Down_b2,2,b3,3!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Both_b2,2,b3,3!Total:10!StartingNote:Random!Tempo:120",],
        
        ["!Direction:Up_4,5!Total:10!StartingNote:A1!Tempo:120",
         "!Direction:Down_4,5!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Both_4,5!Total:10!StartingNote:Random!Tempo:160",
         "!Direction:Both_4,5!Total:10!StartingNote:Random!Tempo:200",],
        
        ["!Direction:Up_b2,2,b3,3,4,5!Total:10!StartingNote:A2!Tempo:160",
        "!Direction:Down_b2,2,b3,3,4,5!Total:10!StartingNote:C3!Tempo:160",
        "!Direction:Both_b2,2,b3,3,4,5!Total:10!StartingNote:Random!Tempo:160",
        "!Direction:Both_b2,2,b3,3,4,5!Total:10!StartingNote:Random!Tempo:160",
        "!Direction:Both_b2,2,b3,3,4,5!Total:10!StartingNote:Random!Tempo:160",
        ],
        
        [
        "!Direction:Up_b6,6!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Down_b6,6!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Up_b7,7!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Down_b7,7!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Up_b6,6,b7,7!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Down_b6,6,b7,7!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Both_b6,6,b7,7!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Both_b6,6,b7,7!Total:10!StartingNote:Random!Tempo:120",],
        
        [
        "!Direction:Up_b5,5!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Down_b5,5!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Both_b5,5!Total:10!StartingNote:A2!Tempo:120",
        "!Direction:Both_b5,5!Total:10!StartingNote:Random!Tempo:160",],
        
        ["!Direction:Up_5,b6!Total:10!StartingNote:A1!Tempo:120",
         "!Direction:Up_5,b7!Total:10!StartingNote:A1!Tempo:120",
         "!Direction:Up_5,7!Total:10!StartingNote:A1!Tempo:120",
         "!Direction:Up_5,b5!Total:10!StartingNote:A1!Tempo:120",
         "!Direction:Down_5,b6!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Down_5,b7!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Down_5,7!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Down_5,b5!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Both_5,b7!Total:10!StartingNote:A2!Tempo:160",
         "!Direction:Both_5,b7!Total:10!StartingNote:A2!Tempo:200",
         "!Direction:Both_5,7!Total:10!StartingNote:A2!Tempo:200",
         "!Direction:Both_5,b5!Total:10!StartingNote:A2!Tempo:200",
         "!Direction:Both_b5,5,b6,b7,7!Total:10!StartingNote:A2!Tempo:160",
         "!Direction:Both_b5,5,b7,7!Total:10!StartingNote:C3!Tempo:200",
         "!Direction:Both_b5,5,b7,7!Total:10!StartingNote:Random!Tempo:200",],
        
        ["!Direction:Up_2,3,4,5,6,7!Total:10!StartingNote:A2!Tempo:160",
        "!Direction:Up_2,3,4,5,6,7!Total:10!StartingNote:A#2!Tempo:160",
        "!Direction:Down_2,3,4,5,6,7!Total:10!StartingNote:B2!Tempo:200",
        "!Direction:Down_2,3,4,5,6,7!Total:10!StartingNote:C3!Tempo:200",
        "!Direction:Both_2,3,4,5,6,7!Total:20!StartingNote:Random!Tempo:250",],
                        
        ["!Direction:Up_2,b3,4,5,b6,b7!Total:10!StartingNote:A2!Tempo:160",
        "!Direction:Up_2,b3,4,5,b6,b7!Total:10!StartingNote:A#2!Tempo:160",
        "!Direction:Down_2,b3,4,5,b6,b7!Total:10!StartingNote:B2!Tempo:200",
        "!Direction:Down_2,b3,4,5,b6,b7!Total:10!StartingNote:C3!Tempo:200",
        "!Direction:Both_2,b3,4,5,b6,b7!Total:20!StartingNote:Random!Tempo:250",],
                
        ["!Direction:Up_4,5,8!Total:10!StartingNote:A1!Tempo:120",
         "!Direction:Down_4,5,8!Total:10!StartingNote:A2!Tempo:120",
         "!Direction:Down_4,5,8!Total:10!StartingNote:C4!Tempo:120",
         "!Direction:Both_4,5,8!Total:10!StartingNote:A2!Tempo:160",
         "!Direction:Both_4,5,8!Total:10!StartingNote:A2!Tempo:200",
         "!Direction:Both_4,5,8!Total:10!StartingNote:C3!Tempo:200",],
        
        ["!Direction:Up_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:10!StartingNote:A2!Tempo:160",
        "!Direction:Up_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:10!StartingNote:A2!Tempo:160",
        "!Direction:Down_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:10!StartingNote:A2!Tempo:160",
        "!Direction:Down_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:10!StartingNote:A2!Tempo:160",
        "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:A2!Tempo:160",
        "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:A2!Tempo:200",
        "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:A2!Tempo:250",],
        
        ["!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:160",
         "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:200",
         "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:250",
         "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:250",
         "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:300",
         "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:300",
         "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:350",
         "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:350",
         "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:400",
         "!Direction:Both_b2,2,b3,3,4,b5,5,b6,6,b7,7,8!Total:20!StartingNote:Random!Tempo:400",],
    ]
    
    func returnRandomizedArray(_ ilength: Int,_ iArray: [String]) -> [String] {
        var returnArr: [String] = []
        var parityTracker = 1.0
        
        for _ in 0..<100 {
            var inputTracker: [Int] = []
            var strArr: [String] = []
            
            for _ in 0 ..< iArray.count {
                inputTracker.append(0)
            }
            
            for _ in 0 ..< ilength {
                let rand = Int.random(in: 0 ..< iArray.count)
                strArr.append(iArray[rand])
                inputTracker[rand] += 1
            }

            inputTracker = inputTracker.sorted(by: >)
            
            var parity = Double(inputTracker[0])/Double(ilength)
            for i in 1 ..< inputTracker.count {
               parity -= Double(inputTracker[i])/Double(ilength)
            }
            
            if parity < parityTracker {
                parityTracker = parity
                returnArr = strArr
            }
        }
        return returnArr
    }
}
