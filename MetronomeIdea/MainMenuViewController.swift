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

var userLevelData = UserLevelData(scaleLevel: "0.0",arpeggioLevel: "0.0",et_singleNotes: "0.0",et_scales: "0.0",et_chords: "0.0")
let defaultColor = DefaultColor()

class MainMenuViewController: UIViewController {

    @IBOutlet weak var Button0: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var NavBar: UINavigationBar!
    @IBOutlet weak var NavBarFiller: UIImageView!
    @IBOutlet weak var NavSettingsButton: UIBarButtonItem!
    
    var levelArr: [Int] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = defaultColor.BackgroundColor
        
        let scaleLevel = UserDefaults.standard.object(forKey: "scaleLevel")
        
        if scaleLevel != nil {
            print ("restoring data")
            let scaleLevel = UserDefaults.standard.object(forKey: "scaleLevel")
            if let scaleLevel = scaleLevel {
                print ("scaleLevel \(scaleLevel)")
                let arpeggioLevel = UserDefaults.standard.object(forKey: "arpeggioLevel")
                let et_singleNotes = UserDefaults.standard.object(forKey: "et_singleNotes")
                let et_scales = UserDefaults.standard.object(forKey: "et_scales")
                let et_chords = UserDefaults.standard.object(forKey: "et_chords")
                userLevelData.scaleLevel = scaleLevel as! String
                userLevelData.arpeggioLevel = arpeggioLevel as! String
                userLevelData.et_singleNotes = et_singleNotes as! String
                userLevelData.et_scales = et_scales as! String
                userLevelData.et_chords = et_chords as! String
            }
        } else {
            print ("brand new data")
            userLevelData.setDefaultValues()
            for (_,str) in userLevelData.stringEquivs.enumerated() {
             UserDefaults.standard.removeObject(forKey: str)
             UserDefaults.standard.set("0.0", forKey: str)
            }
        }
                
        var level = returnConvertedLevel(iinput: userLevelData.scaleLevel)
        levelArr.append(level)
        setupMainMenuButton(ibutton: Button0, ititle: "SCALES", isubtext: "LEVEL \(level+1)")
        level = returnConvertedLevel(iinput: userLevelData.arpeggioLevel)
        levelArr.append(level)
        setupMainMenuButton(ibutton: Button1, ititle: "ARPEGGIOS", isubtext: "LEVEL \(level+1)")
        level = returnConvertedLevel(iinput: userLevelData.et_singleNotes)
        levelArr.append(level)
        setupMainMenuButton(ibutton: Button2, ititle: "SINGLE NOTES", isubtext: "LEVEL \(level+1)")
        level = returnConvertedLevel(iinput: userLevelData.et_scales)
        levelArr.append(level)
        setupMainMenuButton(ibutton: Button3, ititle: "SCALES", isubtext: "LEVEL \(level+1)")
        level = returnConvertedLevel(iinput: userLevelData.et_chords)
        levelArr.append(level)
        setupMainMenuButton(ibutton: Button4, ititle: "CHORDS", isubtext: "LEVEL \(level+1)")
        
        NavBar.barTintColor = defaultColor.MenuButtonColor
        NavBarFiller.backgroundColor = defaultColor.MenuButtonColor
        NavBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:defaultColor.NavBarTitleColor]
        NavSettingsButton.tintColor = defaultColor.MenuButtonTextColor
        //periphButtonArr[i].imageView?.tintColor = defaultColor.AlternateButtonInlayColor
        
        print(userLevelData.scaleLevel)
    }
    
    func setupMainMenuButton (ibutton : UIButton, ititle: String, isubtext : String) {
        ibutton.backgroundColor = defaultColor.MenuButtonColor
        ibutton.setTitleColor(defaultColor.MenuButtonTextColor, for: .normal)
        ibutton.setTitle(ititle, for: .normal)
        ibutton.layer.shadowColor = UIColor.black.cgColor
        ibutton.layer.shadowOffset = CGSize(width: 2, height: 2)
        ibutton.layer.shadowRadius = 2
        ibutton.layer.shadowOpacity = 0.6
       
        let buttonSubtext = UILabel()
        buttonSubtext.frame = CGRect(x: 0,y: 15,width: 273,height: 62)
        buttonSubtext.textAlignment = NSTextAlignment.center
        buttonSubtext.text = isubtext;
        buttonSubtext.layer.zPosition = 1;
        buttonSubtext.textColor = defaultColor.MenuButtonTextColor
        
        ibutton.addSubview(buttonSubtext)
    }
    
    func returnConvertedLevel (iinput : String) -> Int {
        
        let numb = Int(iinput.split(separator: ".")[0])
        return numb!
    }
    
    @IBAction func MainMenuButton(_ sender: UIButton) {
               
        let vc = setViewController(iviewControllerStr: "ViewController")

        let lc = LevelConstruct()
//        let levelIndex = levelArr[sender.tag]
        
        //Scale Test No Tempo
        if (sender.tag == 0) {
            
            vc.setStateProperties(icurrentState: ViewController.State.ScaleTestIdle_NoTempo, itempoButtonsActive: false, icurrentLevel: userLevelData.scaleLevel, ilevelConstruct: lc.scale, ilevelKey: "scaleLevel")
            //RENAME
        }
        
        presentViewController(iviewController: vc)
    }
    
    @IBAction func testNav2(_ sender: Any) {
        
        let vc = setViewController(iviewControllerStr: "ViewController")
        
        vc.currentState = ViewController.State.RecordingIdle
        
        presentViewController(iviewController: vc)
    }
    
    func setViewController(iviewControllerStr: String) -> ViewController {
        var controller: ViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: iviewControllerStr) as! ViewController
        
        return controller
    }
    
    func presentViewController(iviewController: ViewController) {
        
        iviewController.modalPresentationStyle = .fullScreen
        present(iviewController, animated: false, completion: nil)
    }
    
    @IBAction func resetData(_ sender: Any) {
        print("resetting data")
        for (_,str) in userLevelData.stringEquivs.enumerated() {
            UserDefaults.standard.removeObject(forKey: str)
        }
    }
}
