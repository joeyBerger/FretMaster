//
//  WaitThen.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 12/16/19.
//  Copyright © 2019 ashubin.com. All rights reserved.
//

import Foundation
class waitThen
{
    var activeWT : [Timer?] = []
    var selfDestroyingWT : [Timer?] = []
    var infoStruct: [waitThenInfo?] = []
    var activeWTIndex : Int = 0
    struct waitThenInfo
    {
        var args = [String: AnyObject]()
        let target: AnyObject
        let method: Selector
        let repeats: Bool
    }
    
    public func waitThen(itime: Double, itarget: AnyObject, imethod: Selector, irepeats: Bool, idict: Dictionary<String, AnyObject>)
    {
        activeWT.append(Timer.scheduledTimer(timeInterval: itime, target: itarget, selector: imethod, userInfo: idict, repeats: irepeats))
        
        if (!irepeats)
        {
            selfDestroyingWT.append(Timer.scheduledTimer(timeInterval: itime, target: self, selector: #selector(self.nullifyNonRepeatWaitThen) as Selector, userInfo: ["index":activeWTIndex], repeats: irepeats))
        }
        
        else
        {
            selfDestroyingWT.append(nil)
        }
        
        let nStruct = waitThenInfo(args: idict, target: itarget, method: imethod, repeats: irepeats)
        infoStruct.append(nStruct)
    }
    
    @objc public func nullifyNonRepeatWaitThen(itimer : Timer?)
    {
        if (itimer != nil)
        {
            let argDict = itimer?.userInfo as! Dictionary<String, AnyObject>
            print(argDict)
            let i  = argDict["index"] as! Int
            nullifyWaitThenAtIndex(iindex: i)
        }
    }
    
    @objc public func stopWaitThenOfType(iselector: Selector)
    {
        for (i,_) in infoStruct.enumerated()
        {
            // Unexpectedly found nil while unwrapping an Optional value
            if (infoStruct[i]?.method == iselector)
            {
                nullifyWaitThenAtIndex(iindex: i)
            }
        }
    }
    
    func nullifyWaitThenAtIndex(iindex : Int)
    {
        if self.activeWT[iindex] != nil
        {
            self.infoStruct[iindex] = nil
            self.activeWT[iindex]!.invalidate()
            self.activeWT[iindex] = nil
            self.selfDestroyingWT[iindex]?.invalidate()
            self.selfDestroyingWT[iindex]?.invalidate()
        }
    }
}
