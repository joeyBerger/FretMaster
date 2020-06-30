import UIKit

class LevelConstruct: UIViewController {
    var currentLevel: String?
    var currentLevelConstruct: [[String]] = [[]]
    var currentLevelKey: String?

    func analyzeNewLevel(itestPassed: Bool, idevelopmentMode: Int) -> [String: Bool] {
        var returnDict: [String: Bool] = [
            "SubLevelIncremented": false,
            "LevelIncremented": false,
            "SubLevelMaxReached" : false
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
            let levelLength = currentLevelKey!.contains("scale") ? scale.count : arpeggio.count
            if level < levelLength - 1 {
                level = level + 1
                subLevel = 0
            } else {
                // subLevel = subLevel - 1
            }
        }

        currentLevel = "\(level).\(subLevel)"
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
        "scales": ["Intro", "Major Pentatonic", "Major/Minor Modes", "Pentatonic And Major/Minor", "Previous Up/Down", "Previous Up/Down In Time"],
        "arpeggios": ["Major/Minor", "Major/Minor Seventh", "Previous Up", "Previous Up/Down", "Previous Up In Time", "Previous Up/Down In Time"],
        "intervals": ["Maj 2, Perfect 5th","2","3","4"]
    ]

    let scale = [
        ["MinorPentatonic_Up"],
        ["MajorPentatonic_Up"],
        ["Ionian_Up", "Aeolian_Up"],
        ["MinorPentatonic_Up", "MajorPentatonic_Up", "Ionian_Up", "Aeolian_Up"],
        ["MinorPentatonic_Both", "MajorPentatonic_Both", "Ionian_Both", "Aeolian_Both"],
        ["MinorPentatonic_Both_Tempo:120", "MajorPentatonic_Both_Tempo:120", "Ionian_Both_Tempo:120", "Aeolian_Both_Tempo:120"],
    ]
    let arpeggio = [
        ["MajorArp_Up", "MinorArp_Up"],
        ["MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["MajorArp_Up", "MinorArp_Up", "MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["MajorArp_Both", "MinorArp_Both", "MajorSeventhArp_Both", "MinorSeventhArp_Both"],
        ["MajorArp_Up_Tempo:120", "MinorArp_Up_Tempo:120", "MajorSeventhArp_Up_Tempo:120", "MinorSeventhArp_Up_Tempo:120"],
        ["MajorArp_Both_Tempo:120", "MinorArp_Both_Tempo:120", "MajorSeventhArp_Both_Tempo:120", "MinorSeventhArp_Both_Tempo:120"],
//        ["DiminishedArp_Up", "AugmentedArp_Up"],
    ]
    let interval = [
        ["!Direction:Up_2,5!Total:3!StartingNote:A2!Tempo:120",
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
