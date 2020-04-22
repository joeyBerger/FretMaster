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
    var buttonArr: [UIButton] = []
    
    @IBOutlet weak var Stack: UIStackView!
//    @IBOutlet weak var DevScreenPrint: UILabel!
    
    var menuButtonSubtext:[UILabel] = []
    var menuButtonProgress:[UIProgressView] = []
    
    var developmentMode = 1

    var tutorialCompleteStatus = true
    var levelArr: [Int] = []
    var buttonId = 0
    
    var devToggleButton = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = defaultColor.MenuButtonColor
        setupDevButton()
        
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
        
        //update button info
        let lc = LevelConstruct()
        let styler = ViewStyler(ivc: self)

        struct buttonText {
            var header: String
            var subtext: String
            var progress: Float
            var active: Bool
            init(iheader: String, isubtext: String, iprogress: Float, iactive: Bool) {
                header = iheader
                subtext = isubtext
                progress = iprogress
                active = iactive
            }
        }

        tutorialCompleteStatus = userLevelData.tutorialComplete == "1.0"

        var buttonTextInfo: [buttonText] = []
        
        var level = lc.returnConvertedLevel(iinput: userLevelData.scaleLevel)
        var subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.scaleLevel)
        var progress = lc.returnTotalProgress (
            ilevel:lc.returnConvertedLevel(iinput: userLevelData.scaleLevel),
            isubLevel: lc.returnConvertedSubLevel(iinput: userLevelData.scaleLevel),
            ilevelConstruct: lc.scale
        )
        var key = "scales"
        buttonTextInfo.append(buttonText(iheader: key.uppercased(), isubtext: returnLevelStr(ilc: lc, ikey: key, ilevel: level), iprogress: progress, iactive: true))


        key = "arpeggios"
        level = lc.returnConvertedLevel(iinput: userLevelData.arpeggioLevel)
        subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.arpeggioLevel)
        progress = lc.returnTotalProgress(ilevel: level, isubLevel: subLevel, ilevelConstruct: lc.arpeggio)
        buttonTextInfo.append(buttonText(iheader: key.uppercased(), isubtext: returnLevelStr(ilc: lc, ikey: key, ilevel: level), iprogress: progress, iactive: tutorialCompleteStatus))
        
        level = lc.returnConvertedLevel(iinput: userLevelData.et_singleNotes)
        subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.et_singleNotes)
        buttonTextInfo.append(buttonText(iheader: "EAR TRAINING: NOTES", isubtext: "Coming Soon", iprogress: 0.0, iactive: false))
        
        level = lc.returnConvertedLevel(iinput: userLevelData.et_scales)
        subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.et_scales)
        buttonTextInfo.append(buttonText(iheader: "EAR TRAINING: SCALES", isubtext: "Coming Soon", iprogress: 0.0, iactive: false))
        
        level = lc.returnConvertedLevel(iinput: userLevelData.et_chords)
        subLevel = lc.returnConvertedSubLevel(iinput: userLevelData.et_chords)
        buttonTextInfo.append(buttonText(iheader: "EAR TRAINING: CHORDS", isubtext: "Coming Soon", iprogress: 0.0, iactive: false))
        
        for (i,textAtt) in buttonTextInfo.enumerated() {
            styler.setupMenuButtonAttributes(
                ibutton: buttonArr[i],
                isubText: menuButtonSubtext[i],
                iprogressBar: menuButtonProgress[i],
                ibuttonActive: textAtt.active,
                ibuttonStr: textAtt.header,
                isubTextStr: textAtt.subtext,
                iprogressAmount: textAtt.progress
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        resetData()
        buttonArr = [Button0,Button1,Button2,Button3,Button4]

        let bgImage = UIImageView(image: UIImage(named: "AcousticMain.png"))
        bgImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        bgImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(bgImage, at: 0)
        
//        self.DevScreenPrint.alpha = 0.0
        
        let styler = ViewStyler(ivc: self)
        for (i,Button) in buttonArr.enumerated() {
            menuButtonSubtext.append(UILabel())
            menuButtonProgress.append(UIProgressView())
            styler.setupMenuButton(ibutton: Button, isubText: menuButtonSubtext[i], iprogressBar: menuButtonProgress[i])
        }
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:defaultColor.NavBarTitleColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .white
        
        
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
        if (!tutorialCompleteStatus && sender.tag > 0 || sender.tag > 1) {
            return
        }
        buttonId = sender.tag
        UIView.setAnimationsEnabled(false)
        self.performSegue(withIdentifier: "FretPlayground", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MainViewController
        let lc = LevelConstruct()
        
        vc.developmentMode = developmentMode
        
        //Scale Test No Tempo
        if (buttonId == 0) {
            vc.setStateProperties(icurrentLevel: userLevelData.scaleLevel, ilevelConstruct: lc.scale, ilevelKey: "scaleLevel", itutorialComplete: userLevelData.tutorialComplete)
        }
                
        //Arpeggio Test No Tempo
        if (buttonId == 1) {
            vc.setStateProperties(icurrentLevel: userLevelData.arpeggioLevel, ilevelConstruct: lc.arpeggio, ilevelKey: "arpeggioLevel")
        }
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
//        setDevScreenPrintText(itext: "Resetting Data")
        for (_,str) in userLevelData.stringEquivs.enumerated() {
            UserDefaults.standard.removeObject(forKey: str)
        }
    }
    
    @objc func toggleDevMode() {
        developmentMode = (developmentMode + 1) % 3
        let devStr = "Dev Mode: \(developmentMode)"
        print("developmentMode \(developmentMode)")                
        setDevScreenPrintText(itext: devStr)
    }
    
    func setDevScreenPrintText(itext: String) {
//        DevScreenPrint.text = itext
        devToggleButton.setTitle(itext,for: .normal)
        devToggleButton.alpha = 1.0
        UIView.animate(withDuration: 3.5, animations: {
         self.devToggleButton.alpha = 0.0
        })
    }
    
    func returnLevelStr(ilc: LevelConstruct, ikey: String, ilevel: Int) -> String {
        return "L\(ilevel+1) - \(ilc.currentLevelName[ikey]![ilevel].uppercased())"
    }
    
    func setupDevButton() {
        devToggleButton = UIButton()
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        let height:CGFloat = screenHeight*0.1
        devToggleButton.frame = CGRect(x: 0, y: screenHeight-height, width: screenWidth*0.5, height: height)
        view.addSubview(devToggleButton)
        devToggleButton.addTarget(self, action: #selector(toggleDevMode), for: .touchDown)
    }
}
