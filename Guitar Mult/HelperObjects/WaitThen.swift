import Foundation
class waitThen {
    var activeWT: [Timer?] = []
    var selfDestroyingWT: [Timer?] = []
    var infoStruct: [waitThenInfo?] = []
    var activeWTIndex: Int = 0
    struct waitThenInfo {
        var args = [String: AnyObject]()
        let target: AnyObject
        let method: Selector
        let repeats: Bool
    }

    public func waitThen(itime: Double, itarget: AnyObject, imethod: Selector, irepeats: Bool, idict: [String: AnyObject]) {
        print("imethod",imethod)
        activeWT.append(Timer.scheduledTimer(timeInterval: itime, target: itarget, selector: imethod, userInfo: idict, repeats: irepeats))
        if !irepeats {
            selfDestroyingWT.append(Timer.scheduledTimer(timeInterval: itime, target: self, selector: #selector(nullifyNonRepeatWaitThen) as Selector, userInfo: ["index": activeWTIndex], repeats: irepeats))
        } else {
            selfDestroyingWT.append(nil)
        }

        let nStruct = waitThenInfo(args: idict, target: itarget, method: imethod, repeats: irepeats)
        infoStruct.append(nStruct)
    }

    @objc public func nullifyNonRepeatWaitThen(itimer: Timer?) {
        if itimer != nil {
            let argDict = itimer?.userInfo as! [String: AnyObject]
            let i = argDict["index"] as! Int
            nullifyWaitThenAtIndex(iindex: i)
        }
    }

    @objc public func stopWaitThenOfType(iselector: Selector) {
        print("stopping wait then",iselector)
        for (i, _) in infoStruct.enumerated() {
            if infoStruct[i]?.method == iselector {
                nullifyWaitThenAtIndex(iindex: i)
            }
        }
    }

    func nullifyWaitThenAtIndex(iindex: Int) {
        if activeWT[iindex] != nil {
            infoStruct[iindex] = nil
            activeWT[iindex]!.invalidate()
            activeWT[iindex] = nil
            selfDestroyingWT[iindex]?.invalidate()
            selfDestroyingWT[iindex]?.invalidate()
        }
    }
}
