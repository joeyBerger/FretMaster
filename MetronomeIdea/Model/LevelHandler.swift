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
            "Intro",
            "Major Pentatonic",
            "Major/Minor Modes",
            "Pentatonic And Major/Minor",
            "Previous Up/Down",
            "Previous - Random",
            "Previous Up/Down At 120 BPM",
            "","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",
        ],
        "arpeggios": [
            "Major/Minor",
            "Major/Minor Seventh",
            "Previous Up",
            "Previous Up/Down",
            "Previous Up At 120 BPM",
            "Previous Up/Down At 120 BPM"
        ],
        "intervals": [
            "Intervals: M2, M3, P5",
            "M2, M3, P5, Level 2 Got",
            "3",
            "4"
        ]
    ]

    let scale = [
        ["MinorPentatonic_Up"],
        ["MajorPentatonic_Up"],
        ["Ionian_Up", "Aeolian_Up"],
//        ["MinorPentatonic_Up", "MajorPentatonic_Up", "Ionian_Up", "Aeolian_Up"],
        ["MinorPentatonic_Both", "MajorPentatonic_Both", "Ionian_Both", "Aeolian_Both"],
        ["Ionian_Both", "MajorPentatonic_Both", "Aeolian_Both", "MinorPentatonic_Both"],
//        ["Ionian_Both", "MajorPentatonic_Both", "MinorPentatonic_Both", "Aeolian_Both"],
        ["MinorPentatonic_Both_Tempo:120", "MajorPentatonic_Both_Tempo:120", "Ionian_Both_Tempo:120", "Aeolian_Both_Tempo:120"],
        ["PentatonicModeIII_Up","PentatonicModeIV_Up","PentatonicModeV_Up"],
        ["MinorPentatonic_Both", "MajorPentatonic_Both","PentatonicModeIII_Both","PentatonicModeIV_Both","PentatonicModeV_Both"],
        ["PentatonicModeIV_Both", "PentatonicModeIII_Both","MinorPentatonic_Both","PentatonicModeV_Both","MajorPentatonic_Both"], //random
//        ["PentatonicModeV_Both", "MajorPentatonic_Both","PentatonicModeIV_Both","MinorPentatonic_Both","PentatonicModeIII_Both"], //random
        ["MinorPentatonic_Both_Tempo:120", "MajorPentatonic_Both_Tempo:120","PentatonicModeIII_Both_Tempo:120","PentatonicModeIV_Both_Tempo:120","PentatonicModeV_Both_Tempo:120"],
        ["PentatonicModeIV_Both_Tempo:120", "PentatonicModeIII_Both_Tempo:120","MajorPentatonic_Both_Tempo:120","PentatonicModeV_Both_Tempo:120","MinorPentatonic_Both_Tempo:120"], //random
        ["Ionian_Up", "Dorian_Up", "Phyrgian_Up", "Lydian_Up", "Mixolydian_Up", "Aeolian_Up", "Locrian_Up"],
        ["Ionian_Both", "Dorian_Both", "Phyrgian_Both", "Lydian_Both", "Mixolydian_Both", "Aeolian_Both", "Locrian_Both"],
        ["Phyrgian_Both", "Locrian_Both", "Lydian_Both", "Aeolian_Both", "Dorian_Both", "Ionian_Both", "Mixolydian_Both"], //random
        ["Dorian_Both", "Mixolydian_Both", "Ionian_Both", "Phyrgian_Both", "Locrian_Both", "Aeolian_Both", "Lydian_Both"], //random
        ["Mixolydian_Both", "Ionian_Both", "Aeolian_Both", "Dorian_Both", "Locrian_Both", "Lydian_Both", "Phyrgian_Both"], //random
        ["Ionian_Both_Tempo:120", "Dorian_Both_Tempo:120", "Phyrgian_Both_Tempo:120", "Lydian_Both_Tempo:120", "Mixolydian_Both_Tempo:120", "Aeolian_Both_Tempo:120", "Locrian_Both_Tempo:120"],
        ["Lydian_Both_Tempo:120", "Aeolian_Both_Tempo:120", "Phyrgian_Both_Tempo:120", "Ionian_Both_Tempo:120", "Mixolydian_Both_Tempo:120", "Locrian_Both_Tempo:120", "Dorian_Both_Tempo:120"], //random
        ["Locrian_Both_Tempo:120", "Mixolydian_Both_Tempo:120", "Aeolian_Both_Tempo:120", "Dorian_Both_Tempo:120", "Phyrgian_Both_Tempo:120", "Lydian_Both_Tempo:120", "Ionian_Both_Tempo:120"], //random
        ["Locrian_Both_Tempo:150", "Mixolydian_Both_Tempo:150", "Aeolian_Both_Tempo:150", "Dorian_Both_Tempo:150", "Phyrgian_Both_Tempo:150", "Lydian_Both_Tempo:150", "Ionian_Both_Tempo:150"], //random
        ["Mixolydian_Both_Tempo:150", "Dorian_Both_Tempo:150", "Locrian_Both_Tempo:150", "Ionian_Both_Tempo:150", "Aeolian_Both_Tempo:150", "Phyrgian_Both_Tempo:150", "Lydian_Both_Tempo:150"], //random
        ["Dorian_Both_Tempo:180", "Aeolian_Both_Tempo:180", "Lydian_Both_Tempo:180", "Ionian_Both_Tempo:180", "Phyrgian_Both_Tempo:180", "Locrian_Both_Tempo:180", "Mixolydian_Both_Tempo:180"], //random
        
        ["PentatonicModeV_Both", "Locrian_Both", "PentatonicModeIII_Both", "MajorPentatonic_Both", "Dorian_Both", "Ionian_Both", "Lydian_Both", "PentatonicModeIV_Both", "Aeolian_Both", "MinorPentatonic_Both", "Phyrgian_Both", "Mixolydian_Both"], //random
        ["MajorPentatonic_Both", "Mixolydian_Both", "PentatonicModeIII_Both", "PentatonicModeIV_Both", "Phyrgian_Both", "Locrian_Both", "Lydian_Both", "PentatonicModeV_Both", "MinorPentatonic_Both", "Ionian_Both", "Aeolian_Both", "Dorian_Both"], //random
        
        ["Mixolydian_Both_Tempo:120", "Ionian_Both_Tempo:120", "Lydian_Both_Tempo:120", "PentatonicModeV_Both_Tempo:120", "Aeolian_Both_Tempo:120", "MajorPentatonic_Both_Tempo:120", "PentatonicModeIII_Both_Tempo:120", "Phyrgian_Both_Tempo:120", "PentatonicModeIV_Both_Tempo:120", "Locrian_Both_Tempo:120", "Dorian_Both_Tempo:120", "MinorPentatonic_Both_Tempo:120"],   //random
        ["Lydian_Both_Tempo:150", "Phyrgian_Both_Tempo:150", "Aeolian_Both_Tempo:150", "Ionian_Both_Tempo:150", "PentatonicModeIII_Both_Tempo:150", "MinorPentatonic_Both_Tempo:150", "Mixolydian_Both_Tempo:150", "MajorPentatonic_Both_Tempo:150", "PentatonicModeV_Both_Tempo:150", "Dorian_Both_Tempo:150", "PentatonicModeIV_Both_Tempo:150", "Locrian_Both_Tempo:150"],    //random
        ["MinorPentatonic_Both_Tempo:180", "PentatonicModeIV_Both_Tempo:180", "Mixolydian_Both_Tempo:180", "PentatonicModeIII_Both_Tempo:180", "MajorPentatonic_Both_Tempo:180", "Phyrgian_Both_Tempo:180", "Lydian_Both_Tempo:180", "Dorian_Both_Tempo:180", "Ionian_Both_Tempo:180", "PentatonicModeV_Both_Tempo:180", "Locrian_Both_Tempo:180", "Aeolian_Both_Tempo:180"],  //random
                

        ["Ionian_Up_Sequence:Thirds","Aeolian_Up_Sequence:Thirds"],
        ["Ionian_Up_Sequence:Thirds","Aeolian_Up_Sequence:Thirds","Dorian_Up_Sequence:Thirds","Mixolydian_Up_Sequence:Thirds"],
        ["Dorian_Up_Sequence:Thirds","Mixolydian_Up_Sequence:Thirds","Lydian_Up_Sequence:Thirds","Phyrgian_Up_Sequence:Thirds","Locrian_Up_Sequence:Thirds"],
        ["Ionian_Up_Sequence:Thirds","Dorian_Up_Sequence:Thirds","Phyrgian_Up_Sequence:Thirds","Lydian_Up_Sequence:Thirds","Mixolydian_Up_Sequence:Thirds","Aeolian_Up_Sequence:Thirds","Locrian_Up_Sequence:Thirds"],

        ["Lydian_Both_Sequence:Thirds", "Phyrgian_Both_Sequence:Thirds", "Mixolydian_Both_Sequence:Thirds", "Ionian_Both_Sequence:Thirds", "Dorian_Both_Sequence:Thirds", "Aeolian_Both_Sequence:Thirds", "Locrian_Both_Sequence:Thirds"],  //random
        ["Ionian_Both_Sequence:Thirds", "Locrian_Both_Sequence:Thirds", "Mixolydian_Both_Sequence:Thirds", "Dorian_Both_Sequence:Thirds", "Aeolian_Both_Sequence:Thirds", "Lydian_Both_Sequence:Thirds", "Phyrgian_Both_Sequence:Thirds"],  //random
        
        ["Dorian_Up_Tempo:120_Sequence:Thirds", "Aeolian_Up_Tempo:120_Sequence:Thirds", "Locrian_Up_Tempo:120_Sequence:Thirds", "Phyrgian_Up_Tempo:120_Sequence:Thirds", "Ionian_Up_Tempo:120_Sequence:Thirds", "Lydian_Up_Tempo:120_Sequence:Thirds", "Mixolydian_Up_Tempo:120_Sequence:Thirds"],  //random
        ["Phyrgian_Up_Tempo:120_Sequence:Thirds", "Ionian_Up_Tempo:120_Sequence:Thirds", "Mixolydian_Up_Tempo:120_Sequence:Thirds", "Dorian_Up_Tempo:120_Sequence:Thirds", "Locrian_Up_Tempo:120_Sequence:Thirds", "Aeolian_Up_Tempo:120_Sequence:Thirds", "Lydian_Up_Tempo:120_Sequence:Thirds"],  //random
        
        ["Ionian_Up_Tempo:150:Sequence:Thirds", "Locrian_Up_Tempo:150:Sequence:Thirds", "Phyrgian_Up_Tempo:150:Sequence:Thirds", "Mixolydian_Up_Tempo:150:Sequence:Thirds", "Lydian_Up_Tempo:150:Sequence:Thirds", "Aeolian_Up_Tempo:150:Sequence:Thirds", "Dorian_Up_Tempo:150:Sequence:Thirds"],  //random
        ["Dorian_Up_Tempo:150:Sequence:Thirds", "Aeolian_Up_Tempo:150:Sequence:Thirds", "Ionian_Up_Tempo:150:Sequence:Thirds", "Phyrgian_Up_Tempo:150:Sequence:Thirds", "Mixolydian_Up_Tempo:150:Sequence:Thirds", "Locrian_Up_Tempo:150:Sequence:Thirds", "Lydian_Up_Tempo:150:Sequence:Thirds"],  //random
        
        ["Mixolydian_Up_Tempo:180:Sequence:Thirds", "Lydian_Up_Tempo:180:Sequence:Thirds", "Locrian_Up_Tempo:180:Sequence:Thirds", "Dorian_Up_Tempo:180:Sequence:Thirds", "Aeolian_Up_Tempo:180:Sequence:Thirds", "Phyrgian_Up_Tempo:180:Sequence:Thirds", "Ionian_Up_Tempo:180:Sequence:Thirds"],  //random
        ["Phyrgian_Up_Tempo:180:Sequence:Thirds", "Aeolian_Up_Tempo:180:Sequence:Thirds", "Lydian_Up_Tempo:180:Sequence:Thirds", "Dorian_Up_Tempo:180:Sequence:Thirds", "Locrian_Up_Tempo:180:Sequence:Thirds", "Ionian_Up_Tempo:180:Sequence:Thirds", "Mixolydian_Up_Tempo:180:Sequence:Thirds"],  //random
        
        ["HarmonicMinor_Up","MelodicMinor_Up"],
        ["HarmonicMinor_Both","MelodicMinor_Both"],
        ["MelodicMinor_Both_Tempo:120","HarmonicMinor_Both_Tempo:120"],
        ["Aeolian_Both", "Phyrgian_Both", "HarmonicMinor_Both", "MelodicMinor_Both", "Locrian_Both"],   //random
        ["HarmonicMinor_Both", "Phyrgian_Both", "Locrian_Both", "Aeolian_Both", "MelodicMinor_Both"],   //random
        ["Aeolian_Both", "Phyrgian_Both", "HarmonicMinor_Both", "MelodicMinor_Both", "Locrian_Both"],   //random
        ["HarmonicMinor_Both", "Phyrgian_Both", "Locrian_Both", "Aeolian_Both", "MelodicMinor_Both"],   //random
        ["MelodicMinor_Both_Tempo:120", "Aeolian_Both_Tempo:120", "Phyrgian_Both_Tempo:120", "Locrian_Both_Tempo:120", "HarmonicMinor_Both_Tempo:120"], //random
        ["Phyrgian_Both_Tempo:150", "Locrian_Both_Tempo:150", "HarmonicMinor_Both_Tempo:150", "MelodicMinor_Both_Tempo:150", "Aeolian_Both_Tempo:150"], //random
        ["Locrian_Both_Tempo:180", "Phyrgian_Both_Tempo:180", "Aeolian_Both_Tempo:180", "HarmonicMinor_Both_Tempo:180", "MelodicMinor_Both_Tempo:180"], //random
        
        ["DiminishedWholeHalf_Up","DiminishedHalfWhole_Up"],
        ["DiminishedWholeHalf_Both","DiminishedHalfWhole_Both"],
        ["DiminishedHalfWhole_Both_Tempo:120","DiminishedWholeHalf_Both_Tempo:120"],   //random
        ["DiminishedHalfWhole_Both_Tempo:150","DiminishedWholeHalf_Both_Tempo:150"],   //random
        ["DiminishedWholeHalf_Both_Tempo:180","DiminishedHalfWhole_Both_Tempo:180"],   //random
    ]
    let arpeggio = [
//        ["Ionian_Up_Tempo:120_Sequence:Thirds"],
        ["MajorArp_Up", "MinorArp_Up"],
        ["MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["MajorArp_Up", "MinorArp_Up", "MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["MajorArp_Both", "MinorArp_Both", "MajorSeventhArp_Both", "MinorSeventhArp_Both"],
        ["MajorArp_Up_Tempo:120", "MinorArp_Up_Tempo:120", "MajorSeventhArp_Up_Tempo:120", "MinorSeventhArp_Up_Tempo:120"],
        ["MajorArp_Both_Tempo:120", "MinorArp_Both_Tempo:120", "MajorSeventhArp_Both_Tempo:120", "MinorSeventhArp_Both_Tempo:120"],
//        ["DiminishedArp_Up", "AugmentedArp_Up"],
    ]
    let interval = [
//        ["!Direction:Up_2,5!Total:3!StartingNote:A2!Tempo:120",
         ["!Direction:Up_2,5!Total:30!StartingNote:Random!Tempo:120",
//         ["!Direction:Up_2,b5!Total:3!StartingNote:A2!Tempo:120",
         "!Direction:Up_2,3!Total:3!StartingNote:A2!Tempo:120",
         "!Direction:Up_2,3,5!Total:3!StartingNote:A2!Tempo:120",],
        
        ["!Direction:Up_2,4,3,5!Total:3!StartingNote:A2!Tempo:150",
         "!Direction:Up_2,b3,3!Total:3!StartingNote:A2!Tempo:150",
         "!Direction:Up_2,3,5!Total:3!StartingNote:A2!Tempo:150",],
        
        ["!Direction:Up_2,4,3,5!Total:3!StartingNote:A2!Tempo:150",
         "!Direction:Up_2,b3,3!Total:3!StartingNote:A2!Tempo:150",
         "!Direction:Up_2,3,5!Total:3!StartingNote:A2!Tempo:150",],
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
