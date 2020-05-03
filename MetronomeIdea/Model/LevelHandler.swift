import UIKit

class LevelConstruct: UIViewController {
    var currentLevel: String?
    var currentLevelConstruct: [[String]] = [[]]
    var currentLevelKey: String?

    func analyzeNewLevel(itestPassed: Bool, idevelopmentMode: Int) -> [String: Bool] {
        var returnDict: [String: Bool] = [
            "SubLevelIncremented": false,
            "LevelIncremented": false,
        ]
        if !itestPassed, idevelopmentMode < 2 {
            return returnDict
        }
        var level = returnConvertedLevel(iinput: currentLevel!)
        var subLevel = returnConvertedSubLevel(iinput: currentLevel!) + 1

        if subLevel == currentLevelConstruct[level].count {
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

    func returnCurrentTask() -> String {
        let level = returnConvertedLevel(iinput: currentLevel!)
        let subLevel = returnConvertedSubLevel(iinput: currentLevel!)

        // make sure the current level/sublevel is not out of range
        if currentLevelConstruct[level].count > subLevel {
            return currentLevelConstruct[level][subLevel]
        }

        // level/sublevel is out of range, return last task in construct
        return currentLevelConstruct[level][currentLevelConstruct[level].count - 1]
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
        ["MinorPentatonic_Both_Tempo", "MajorPentatonic_Both_Tempo", "Ionian_Both_Tempo", "Aeolian_Both_Tempo"],
    ]
    let arpeggio = [
        ["MajorArp_Up", "MinorArp_Up"],
        ["MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["MajorArp_Up", "MinorArp_Up", "MajorSeventhArp_Up", "MinorSeventhArp_Up"],
        ["MajorArp_Both", "MinorArp_Both", "MajorSeventhArp_Both", "MinorSeventhArp_Both"],
        ["MajorArp_Up_Tempo", "MinorArp_Up_Tempo", "MajorSeventhArp_Up_Tempo", "MinorSeventhArp_Up_Tempo"],
        ["MajorArp_Both_Tempo", "MinorArp_Both_Tempo", "MajorSeventhArp_Both_Tempo", "MinorSeventhArp_Both_Tempo"],
//        ["DiminishedArp_Up", "AugmentedArp_Up"],
    ]
    let intervals = [
        ["Up_2,5","Up_3,5"],
        ["Up_2,5","Up_3,5"],
        ["Up_2,5","Up_3,5"],
    ]
}
