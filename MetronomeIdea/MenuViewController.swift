//
//  MainMenuViewController.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 11/23/19.
//  Copyright © 2019 ashubin.com. All rights reserved.
//

import UIKit

extension UIButton {
open override var isHighlighted: Bool {
    didSet {
        super.isHighlighted = false
    }
}}

var userLevelData = UserLevelData(scaleLevel: "0.0",arpeggioLevel: "0.0",et_singleNotes: "0.0",et_scales: "0.0",et_chords: "0.0",tutorialComplete: "0.0")
let defaultColor = DefaultColor()

class MenuViewController: UIViewController {

    @IBOutlet weak var Button0: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var NavBar: UINavigationBar!
//    @IBOutlet weak var NavBarFiller: UIImageView!
    @IBOutlet weak var NavSettingsButton: UIBarButtonItem!
    
    @IBOutlet weak var Stack: UIStackView!
    @IBOutlet weak var DevScreenPrint: UILabel!
    
    var developmentMode = false

    var tutorialCompleteStatus = true
    var levelArr: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        resetData()

        let bgImage = UIImageView(image: UIImage(named: "AcousticMain.png"))
        bgImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        bgImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(bgImage, at: 0)
        
        let newFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: NavBar.frame.minY)
        let navBarFillerReal = UIImageView()
        navBarFillerReal.frame = newFrame
        navBarFillerReal.backgroundColor = defaultColor.MenuButtonColor
        self.view.insertSubview(navBarFillerReal, at: 1)
        
        self.DevScreenPrint.alpha = 0.0
        
        let scaleLevel = UserDefaults.standard.object(forKey: "scaleLevel")
        if scaleLevel != nil {
            print ("restoring data")
            let scaleLevel = UserDefaults.standard.object(forKey: "scaleLevel")
            if let scaleLevel = scaleLevel {
                let arpeggioLevel = UserDefaults.standard.object(forKey: "arpeggioLevel")
                let et_singleNotes = UserDefaults.standard.object(forKey: "et_singleNotes")
                let et_scales = UserDefaults.standard.object(forKey: "et_scales")
                let et_chords = UserDefaults.standard.object(forKey: "et_chords")
                let tutorialComplete = UserDefaults.standard.object(forKey: "tutorialComplete")
                userLevelData.scaleLevel = scaleLevel as! String
                userLevelData.arpeggioLevel = arpeggioLevel as! String
                userLevelData.et_singleNotes = et_singleNotes as! String
                userLevelData.et_scales = et_scales as! String
                userLevelData.et_chords = et_chords as! String
                
                if (tutorialComplete != nil) {
                    userLevelData.tutorialComplete = tutorialComplete as! String
                } else {
                    print("bad data, ressetting")
                    resetData()
                }
            }
        } else {
             print ("brand new data")
             userLevelData.setDefaultValues()
             for (_,str) in userLevelData.stringEquivs.enumerated() {
                 UserDefaults.standard.removeObject(forKey: str)
                 UserDefaults.standard.set("0.0", forKey: str)
            }
        }
                
        let lc = LevelConstruct()
        let styler = ViewStyler(ivc: self)
        
        struct buttonText {
            var header: String
            var subtext: String
            var id: String
            init(iheader: String, isubtext: String, iid: String) {
                header = iheader
                subtext = isubtext
                id = iid
            }
        }
        
        tutorialCompleteStatus = userLevelData.tutorialComplete == "1.0"
        
        var level = lc.returnConvertedLevel(iinput: userLevelData.scaleLevel)
        var subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.scaleLevel)
        
        var progress = lc.returnTotalProgress (
            ilevel:lc.returnConvertedLevel(iinput: userLevelData.scaleLevel),
            isubLevel: lc.returnConvertedSubLevel(iinput: userLevelData.scaleLevel),
            ilevelConstruct: lc.scale
        )

        
        
        var key = "scales"
        
        
        let buttonArr = [Button0,Button1,Button2,Button3,Button4]
        
        
        
        for (i,button) in buttonArr.enumerated() {
            
            if (i == 0) {
//                styler!.setupMenuButton(ibutton: button!, ititle: buttonInfo[i].header, isubtext: buttonInfo[i].subtext, iprogressAmount: -1.0)
            }
            

        }
        
        var tempThing = buttonText(
            iheader: key.uppercased(),
            isubtext: returnLevelStr(ilc: lc, ikey: key, ilevel: level),
            iid: key
        )
        
        styler.setupMenuButton(ibutton: Button0, ititle: key.uppercased(), isubtext: returnLevelStr(ilc: lc, ikey: key, ilevel: level), iprogressAmount: progress)
        
        
        
        
        level = lc.returnConvertedLevel(iinput: userLevelData.arpeggioLevel)
        subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.arpeggioLevel)
        progress = lc.returnTotalProgress(ilevel: level, isubLevel: subLevel, ilevelConstruct: lc.arpeggio)
        levelArr.append(level)
        key = "arpeggios"
        styler.setupMenuButton(ibutton: Button1, ititle: key.uppercased(), isubtext: returnLevelStr(ilc: lc, ikey: key, ilevel: level), iprogressAmount: progress, itutorialComplete : tutorialCompleteStatus)
        level = lc.returnConvertedLevel(iinput: userLevelData.et_singleNotes)
        
        levelArr.append(level)
        styler.setupMenuButton(ibutton: Button2, ititle: "EAR TRAINING: SINGLE NOTES", isubtext: "LEVEL \(level+1)", iprogressAmount: progress, itutorialComplete : tutorialCompleteStatus)
        level = lc.returnConvertedLevel(iinput: userLevelData.et_scales)
        levelArr.append(level)
        styler.setupMenuButton(ibutton: Button3, ititle: "EAR TRAINING: SCALES", isubtext: "LEVEL \(level+1)", iprogressAmount: progress, itutorialComplete : tutorialCompleteStatus)
        level = lc.returnConvertedLevel(iinput: userLevelData.et_chords)
        levelArr.append(level)
        styler.setupMenuButton(ibutton: Button4, ititle: "EAR TRAINING: CHORDS", isubtext: "LEVEL \(level+1)", iprogressAmount: progress, itutorialComplete : tutorialCompleteStatus)
        
        NavBar.barTintColor = defaultColor.MenuButtonColor
//        NavBarFiller.backgroundColor = defaultColor.MenuButtonColor
        NavBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:defaultColor.NavBarTitleColor]
        NavSettingsButton.tintColor = defaultColor.MenuButtonTextColor
        //periphButtonArr[i].imageView?.tintColor = defaultColor.AlternateButtonInlayColor
        

        
        
        let button4frame = view.convert(Button4.frame, from:Stack)
        
        //look to see if menu buttons are off the screen
        if (button4frame.maxY + button4frame.height > view.frame.height) {
            //conversion for iPhone8
            //(667-85-145-(4*65))/5
            let bottomBuffer: CGFloat = 10.0 //was 20.0
            let numbButtons: CGFloat = 5.0
            let button0frame = view.convert(Button0.frame, from:Stack)
            let sP = (view.frame.height - (bottomBuffer+button0frame.height)-button0frame.minY - (numbButtons-1)*button0frame.height)/numbButtons
            print("adapting stack to fit all buttons with new spacing of \(sP)")
            Stack.spacing = CGFloat(sP)
        }
    }
    
  
    @IBAction func MainMenuButton(_ sender: UIButton) {
               
        if (!tutorialCompleteStatus && sender.tag > 0) {
            return
        }
        
        let vc = setViewController(iviewControllerStr: "Playground2")  //TODO: get rid of playground2
        let lc = LevelConstruct()

        vc.developmentMode = developmentMode
        
        //Scale Test No Tempo
        if (sender.tag == 0) {
            vc.setStateProperties(icurrentLevel: userLevelData.scaleLevel, ilevelConstruct: lc.scale, ilevelKey: "scaleLevel", itutorialComplete: userLevelData.tutorialComplete)
        }
                
        //Arpeggio Test No Tempo
        if (sender.tag == 1) {
            vc.setStateProperties(icurrentLevel: userLevelData.arpeggioLevel, ilevelConstruct: lc.arpeggio, ilevelKey: "arpeggioLevel")
        }
        
        presentViewController(iviewController: vc)
    }
        
    func setViewController(iviewControllerStr: String) -> MainViewController {
        var controller: MainViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: iviewControllerStr) as! MainViewController
        
        return controller
    }
    
    func presentViewController(iviewController: MainViewController) {
        iviewController.modalPresentationStyle = .fullScreen
        present(iviewController, animated: false, completion: nil)
    }
    
    @IBAction func resetData() {
        setDevScreenPrintText(itext: "Resetting Data")
        for (_,str) in userLevelData.stringEquivs.enumerated() {
            UserDefaults.standard.removeObject(forKey: str)
        }
    }
    
    @IBAction func toggleDevMode(_ sender: Any) {
        developmentMode = !developmentMode
        let devStr = "Development Mode:"
        let status = developmentMode == true ? "Enabled" : "Disabled"
        setDevScreenPrintText(itext: devStr + status)
    }
    
    func returnLevelStr(ilc: LevelConstruct, ikey: String, ilevel: Int) -> String {
        return "L\(ilevel+1) - \(ilc.currentLevelName[ikey]![ilevel].uppercased())"
    }
    
    func setDevScreenPrintText(itext: String) {
        DevScreenPrint.text = itext
        self.DevScreenPrint.alpha = 1.0
        UIView.animate(withDuration: 3.5, animations: {
         self.DevScreenPrint.alpha = 0.0
        })
    }
}
