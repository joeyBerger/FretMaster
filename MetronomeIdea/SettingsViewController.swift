import Foundation
import UIKit

class SettingsViewController: UIViewController {
    var vc : MainViewController?

    convenience init() {
        self.init(ivc: nil)
    }
    
    init(ivc: MainViewController?) {
        self.vc = ivc
        super.init(nibName: nil, bundle: nil)        //https://stackoverflow.com/questions/26923003/how-do-i-make-a-custom-initializer-for-a-uiviewcontroller-subclass-in-swift
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var Stack: UIStackView!
//    @IBOutlet weak var NavBar: UINavigationBar!
//    @IBOutlet weak var NavBackButton: UIBarButtonItem!
//    var NavBarFiller: UIImageView!
    
    @IBOutlet weak var Button0: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    
    var buttonId = 0
    
    struct buttonText {
        var header: String
        var subtext: String
        var id: String
        var availableSettings: [String]
        var settingsType: String
        
        init(iheader: String, isubtext: String, iid: String, iavailableSettings: [String], isettingsType: String) {
            header = iheader
            subtext = isubtext
            id = iid
            availableSettings = iavailableSettings
            settingsType = isettingsType
        }
    }
    
    var buttonInfo: [buttonText] = [
        buttonText(iheader: "Guitar Sound".uppercased(),
                   isubtext: "Explore Sonic Options",
                   iid: "guitarTone",
                   iavailableSettings: ["Acoustic","Jazz","Rock"],
                   isettingsType: "guitarTone"
                   ),
        buttonText(iheader: "Fret Board Dot".uppercased(), isubtext: "Manage Your Dot Display", iid: "fretDot",iavailableSettings: [], isettingsType: "dotValue"),
        buttonText(iheader: "Click Sound".uppercased(), isubtext: "Pick Your Click Sound", iid: "clickTone", iavailableSettings: [], isettingsType: "clickTone"),
    ]
    
    var styler: ViewStyler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "RecordingBoard.jpg")
        let buttonArr = [Button0,Button1,Button2]
        for (i,button) in buttonArr.enumerated() {
//            styler!.setupMenuButton(ibutton: button!, ititle: buttonInfo[i].header, isubtext: buttonInfo[i].subtext, iprogressAmount: -1.0)
        }
        
//        styler!.setupNavBar(iNavBar: NavBar)
//        styler!.setupNavBarComponents(iNavBackButton: NavBackButton, iNavSettingsButton: nil)
//
//        NavBarFiller = styler!.navBarFillerInit(iNavBar: NavBar)
//        self.view.insertSubview(NavBarFiller, at: 1)
        
//        let backButtonAnnotation = styler!.setupBackButtonAnnotation(iNavBar: NavBar)
//        backButtonAnnotation.backgroundColor! = UIColor.green
//        backButtonAnnotation.addTarget(self, action: #selector(onBackButtonDown), for: .touchUpInside)
//        view.addSubview(backButtonAnnotation)  //TODO: buttonlayer is behind text, sometimes?
//        self.view.insertSubview(backButtonAnnotation, at: 100)
    }
    
    @objc func temp() {
        print("asdfadsf dfadsfas")
    }
    
    @IBAction func onBackButtonDown(_ sender: Any) {
        var controller: MainViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "Playground2") as! MainViewController  //TODO: get rid of playground2
        controller.setStateProperties(icurrentLevel: vc!.lc.currentLevel!, ilevelConstruct: vc!.lc.currentLevelConstruct, ilevelKey: vc!.lc.currentLevelKey!)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    @IBAction func settingsCategoryButtonDown(_ sender: UIButton) {
        buttonId = sender.tag
        UIView.setAnimationsEnabled(false)
        self.performSegue(withIdentifier: "SettingsItem", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("in prepare \(buttonId)")
        
        var sItem = segue.destination as! SettingsItemViewController
        sItem.setupSettingsCellData(isettingStrings: buttonInfo[buttonId].availableSettings)
//        let lc = LevelConstruct()
//        print(newVC.layerArr)
//        newVC.setStateProperties(icurrentLevel: userLevelData.scaleLevel, ilevelConstruct: lc.scale, ilevelKey: "scaleLevel", itutorialComplete: userLevelData.tutorialComplete)

    }
}
