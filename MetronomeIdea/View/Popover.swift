//
//  Popover.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 5/26/20.
//  Copyright © 2020 ashubin.com. All rights reserved.
//

import Foundation
import UIKit

class Popover: UIViewController {
    var vc: MainViewController?
    var background = SpringImageView()
    var mainButton = SpringButton()
    var buttonText = SpringLabel()
    var titleText = SpringLabel()
    var subTitleText = SpringLabel()
    var subText = [SpringLabel()]
    var xButton = SpringButton()
    
    var popoverVisible = false
    var mainPopoverState = ""
    
    convenience init() {
        self.init(ivc: nil)
    }

    init(ivc: UIViewController?) {
        vc = ivc as? MainViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupPopover(_ inavigationController: UINavigationController) {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        let width = screenWidth*0.95
        let height:CGFloat = 450
        
        background.frame = CGRect(x: (screenWidth-width)/2, y: (screenHeight - height)/2, width: width, height: height)
        background.layer.zPosition = 500
        background.backgroundColor = defaultColor.MenuButtonColor
        background.layer.cornerRadius = 20
        
        let buttonHeight:CGFloat = 65, buttonBuffer:CGFloat = 20, buttonWidth:CGFloat = background.frame.width*0.7
        mainButton.frame = CGRect(x: (background.frame.width-buttonWidth)/2, y: background.frame.maxY - buttonHeight - buttonBuffer , width: buttonWidth, height: buttonHeight)
        mainButton.layer.zPosition = 501
        mainButton.backgroundColor = defaultColor.FretMarkerSuccess
        
        mainButton.layer.shadowColor = UIColor.black.cgColor
        mainButton.layer.shadowOffset = CGSize(width: 2, height: 5)
        mainButton.layer.shadowRadius = 2
        mainButton.layer.shadowOpacity = 0.6
        mainButton.layer.cornerRadius = 8
        mainButton.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
        
//        buttonText = UILabel()
        buttonText.frame = mainButton.frame
        buttonText.text = "LET'S GO!"
        buttonText.layer.zPosition = 502
        buttonText.textAlignment = .center
        buttonText.font = buttonText.font.withSize(25)
        buttonText.textColor = defaultColor.MenuButtonTextColor
        vc!.styler!.addStandardLabelShadow(buttonText)
        
//        titleText = UILabel()
        titleText.frame = CGRect(x: background.frame.minX,y: background.frame.minY+10,width: background.frame.width, height: 65)
        titleText.text = "FRET MASTER™"
        titleText.layer.zPosition = 502
        titleText.textAlignment = .center
        titleText.font = buttonText.font.withSize(35)
        titleText.textColor = defaultColor.FretMarkerStandard
        
        
//        subTitleText = UILabel()
        subTitleText.frame = CGRect(x: background.frame.minX,y: titleText.frame.maxY,width: background.frame.width, height: 100)
        subTitleText.text = "TUTORIAL COMPLETE!"
        subTitleText.layer.zPosition = 502
        subTitleText.textAlignment = .center
        subTitleText.font = buttonText.font.withSize(30)
        subTitleText.textColor = defaultColor.MenuButtonTextColor
        vc!.styler!.addStandardLabelShadow(subTitleText)
        
        let subTextHeight:CGFloat = 50, subTextWidth:CGFloat = width * 0.95, subTextBuffer:CGFloat = 50
        for i in 0..<3 {
            subText.append(SpringLabel())
            subText[i].frame = CGRect(x: (background.frame.width-subTextWidth)/2, y: subTitleText.frame.maxY+CGFloat(i)*subTextBuffer, width: background.frame.width, height: subTextHeight)
            subText[i].adjustsFontSizeToFitWidth = true
            subText[i].text = "TUTORIAL COMPLETE! adsfdf"
            subText[i].layer.zPosition = 502
            subText[i].textAlignment = .center
            subText[i].font = subText[i].font.withSize(20)
            subText[i].textColor = defaultColor.MenuButtonTextColor
            vc!.styler!.addStandardLabelShadow(subText[i])
        }
        
//        xButton = SpringButton()
        let buttonSize:CGFloat = 30
        xButton.frame = CGRect(x: background.frame.maxX-buttonSize*1.5, y: background.frame.minY+buttonSize/2, width: buttonSize, height: buttonSize)
        xButton.layer.zPosition = 502
        let image = UIImage(named: "icons8-multiply-50")
        xButton.setImage(image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        xButton.imageView?.tintColor = defaultColor.MenuButtonTextColor
        xButton.imageView?.alpha = 1.0
        xButton.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
        vc!.view.addSubview(xButton)
        
        removeFromView()
    }
    
    @objc func handleButtonPress() {
        let t:Any = 0
        vc!.closeMainPopover(t)
    }
    
    func removeFromView() {
        background.removeFromSuperview()
        mainButton.removeFromSuperview()
        buttonText.removeFromSuperview()
        titleText.removeFromSuperview()
        subTitleText.removeFromSuperview()
        xButton.removeFromSuperview()
        for text in subText {
            text.removeFromSuperview()
        }
    }
    
    func addToView() {
        popoverVisible = true
        vc!.view.addSubview(background)
        vc!.view.addSubview(mainButton)
        mainButton.isHidden = true
        vc!.view.addSubview(buttonText)
        buttonText.isHidden = true
        vc!.view.addSubview(titleText)
        vc!.view.addSubview(subTitleText)
        subTitleText.isHidden = true
        vc!.view.addSubview(xButton)
        xButton.isHidden = true
        for text in subText {
            vc!.view.addSubview(text)
            text.isHidden = true
        }
                
        background.setAndPlayAnim("tutorialSlideIn")
        titleText.setAndPlayAnim("titleTextIntro")
        
        let subTitleTextWaitTime = 0.35
        vc!.wt.waitThen(itime: subTitleTextWaitTime, itarget: self, imethod: #selector(animationWaitThen) as Selector, irepeats: false, idict: ["arg1": "subTitleText" as AnyObject])
        
        let subTextWaitTime = 0.5
        var numbTextVisible = 0
        for (i,text) in subText.enumerated() {
            let timeIncrement = 0.2
            if text.text != "" {
                numbTextVisible += 1
                vc!.wt.waitThen(itime: subTextWaitTime + timeIncrement * Double(i), itarget: self, imethod: #selector(animationWaitThen) as Selector, irepeats: false, idict: ["arg1": "subText" as AnyObject,"arg2": i as AnyObject])
            }
        }
        
        let buttonWaitTime = subTextWaitTime + 0.2 * Double(numbTextVisible)
        vc!.wt.waitThen(itime: buttonWaitTime, itarget: self, imethod: #selector(animationWaitThen) as Selector, irepeats: false, idict: ["arg1": "mainButton" as AnyObject])
        
        let buttonTextWaitTime = buttonWaitTime + 0.3
        vc!.wt.waitThen(itime: buttonTextWaitTime, itarget: self, imethod: #selector(animationWaitThen) as Selector, irepeats: false, idict: ["arg1": "buttonText" as AnyObject])
        vc!.wt.waitThen(itime: buttonTextWaitTime, itarget: self, imethod: #selector(animationWaitThen) as Selector, irepeats: false, idict: ["arg1": "xButton" as AnyObject])        
    }
    
    @objc func animationWaitThen(_ timer: Timer) {
        let parametersObj = timer.userInfo as! [String: AnyObject]
        switch parametersObj["arg1"] as! String {
        case "mainButton":
            mainButton.isHidden = false
            mainButton.setAndPlayAnim()
        case "subTitleText":
            subTitleText.isHidden = false
            subTitleText.setAndPlayAnim("subTitleTextIntro")
        case "subText":
            subText[parametersObj["arg2"] as! Int].isHidden = false
            subText[parametersObj["arg2"] as! Int].setAndPlayAnim("subTextIntro")
        case "buttonText":
            buttonText.isHidden = false
            buttonText.setAndPlayAnim("buttonTextIntro")
        case "xButton":
            xButton.isHidden = false
            xButton.setAndPlayAnim("xButtonIntro")
        default:
            print("not playing anim")
        }
    }
    
    func fadePopver() {
        
        background.setAndPlayAnim("fadeOnPopoverDismiss")
        
//        mainButton.setAndPlayAnim()
//        subTitleText.setAndPlayAnim("subTitleTextIntro")
////        subText[parametersObj["arg2"] as! Int].setAndPlayAnim("subTextIntro")
//        buttonText.setAndPlayAnim("buttonTextIntro")
//        xButton.setAndPlayAnim("xButtonIntro")
    }
    
    func setupPopoverText(isubtitle: String, isubText: [String]) {
        subTitleText.text = isubtitle
        for text in subText {
            text.text = ""
        }
        for (i,subtext) in isubText.enumerated() {
            subText[i].text = subtext
        }
    }
    
}
