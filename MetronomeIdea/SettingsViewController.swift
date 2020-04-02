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
    @IBOutlet weak var NavBar: UINavigationBar!
    @IBOutlet weak var NavBackButton: UIBarButtonItem!
    var NavBarFiller: UIImageView!
    
    @IBOutlet weak var Button0: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    
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
    
    var buttonInfo: [buttonText] = [
        buttonText(iheader: "Guitar Sound".uppercased(), isubtext: "Explore Sonic Options", iid: "guitarTone"),
        buttonText(iheader: "Fret Board Dot".uppercased(), isubtext: "Manage Your Dot Display", iid: "fretDot"),
        buttonText(iheader: "Click Sound".uppercased(), isubtext: "Pick Your Click Sound", iid: "clickTone"),
    ]
    
    var styler: ViewStyler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "RecordingBoard.jpg")
        let buttonArr = [Button0,Button1,Button2]
        for (i,button) in buttonArr.enumerated() {
            setupMenuButton(ibutton: button!, ititle: buttonInfo[i].header, isubtext: buttonInfo[i].subtext)
        }
        
        styler!.setupNavBar(iNavBar: NavBar)
        styler!.setupNavBarComponents(iNavBackButton: NavBackButton, iNavSettingsButton: nil)
        
        NavBarFiller = styler!.navBarFillerInit(iNavBar: NavBar)
        self.view.insertSubview(NavBarFiller, at: 1)
        
        let backButtonAnnotation = styler!.setupBackButtonAnnotation(iNavBar: NavBar)
        backButtonAnnotation.addTarget(self, action: #selector(onBackButtonDown), for: .touchUpInside)
        view.addSubview(backButtonAnnotation)
    }
    
    @IBAction func onBackButtonDown(_ sender: Any) {
        var controller: MainViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "Playground2") as! MainViewController  //TODO: get rid of playground2
        controller.setStateProperties(icurrentLevel: vc!.lc.currentLevel!, ilevelConstruct: vc!.lc.currentLevelConstruct, ilevelKey: vc!.lc.currentLevelKey!)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    @IBAction func settingsCategoryButtonDown(_ sender: UIButton) {
        print("adsfa \(buttonInfo[sender.tag].id)")
    }
    
    func setupMenuButton (ibutton : UIButton, ititle: String, isubtext : String) {

        //TODO: this should be in styler
        var buttonColor: UIColor
        var textColor: UIColor
        buttonColor = defaultColor.MenuButtonColor;
        textColor = defaultColor.MenuButtonTextColor

        ibutton.backgroundColor = buttonColor
        ibutton.setTitleColor(textColor, for: .normal)
        ibutton.setTitle(ititle, for: .normal)
        ibutton.layer.shadowColor = UIColor.black.cgColor
        ibutton.layer.shadowOffset = CGSize(width: 2, height: 2)
        ibutton.layer.shadowRadius = 2
        ibutton.layer.shadowOpacity = 0.6
       
        let width = ibutton.frame.width
        let buttonSubtext = UILabel()
        buttonSubtext.frame = CGRect(x: 0,y: 0,width: width, height: ibutton.frame.height+30)

        buttonSubtext.textAlignment = NSTextAlignment.center
        buttonSubtext.text = isubtext;
        buttonSubtext.layer.zPosition = 1;
        buttonSubtext.textColor = textColor

        ibutton.addSubview(buttonSubtext)
    }
}
