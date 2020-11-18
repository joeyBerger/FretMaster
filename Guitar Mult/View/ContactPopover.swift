import Foundation
import UIKit
import MessageUI

class ContactPopover: UIViewController, MFMailComposeViewControllerDelegate {
    var vc: SettingsViewController?
    var background = SpringImageView()
    var mainButton = SpringButton()
    var buttonText = SpringLabel()
    var titleText = SpringLabel()
    var subText = [SpringLabel()]
    var xButton = SpringButton()
    
    var popoverVisible = false
    var mainPopoverState = ""
    
    var DimOverlay = UIImageView();
    
    func setupPopover(_ inavigationController: UINavigationController, _ ivc: SettingsViewController) {
        
        vc = ivc
        
        let overlay = UIImageView()
        let frame = inavigationController.navigationBar.frame
        overlay.frame = CGRect(x: (frame.minX), y: (frame.minY) + (frame.height), width:  vc!.view.frame.width, height:  vc!.view.frame.height)
        overlay.alpha = 0.0
        DimOverlay = overlay
        DimOverlay.backgroundColor = UIColor.black
        DimOverlay.layer.zPosition = 400
        vc!.view.addSubview(DimOverlay)

        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        let width = screenWidth*0.95
        let height:CGFloat = 330
        
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
        
        buttonText.frame = mainButton.frame
        buttonText.text = "CONTACT"
        buttonText.layer.zPosition = 502
        buttonText.textAlignment = .center
        buttonText.font = buttonText.font.withSize(25)
        buttonText.textColor = defaultColor.MenuButtonTextColor
        vc!.styler!.addStandardLabelShadow(buttonText)
        
        titleText.frame = CGRect(x: background.frame.minX,y: background.frame.minY+20,width: background.frame.width, height: 65)
        titleText.text = "Guitar Mult"
        titleText.layer.zPosition = 502
        titleText.textAlignment = .center
        titleText.font = UIFont(name:"Arizonia-Regular",size:50)
        titleText.textColor = defaultColor.FretMarkerStandard
        titleText.layer.shadowColor = UIColor.black.cgColor
        titleText.layer.shadowRadius = 3.0
        titleText.layer.shadowOpacity = 1.0
        titleText.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleText.layer.masksToBounds = false
        
        let subTextHeight:CGFloat = 50, subTextWidth:CGFloat = width * 0.95, subTextBuffer:CGFloat = 50
        
        let subTextText = ["Questions?","Issues?"]
        
        for i in 0..<2 {
            subText.append(SpringLabel())
            subText[i].frame = CGRect(x: (screenWidth-subTextWidth)/2, y: (titleText.frame.maxY+25+CGFloat(i)*subTextBuffer), width: subTextWidth, height: subTextHeight)
            subText[i].adjustsFontSizeToFitWidth = true
            subText[i].text = subTextText[i]
            subText[i].layer.zPosition = 502
            subText[i].textAlignment = .center
            subText[i].font = subText[i].font.withSize(20+7)
            subText[i].textColor = defaultColor.MenuButtonTextColor
            vc!.styler!.addStandardLabelShadow(subText[i])
        }

        let buttonSize:CGFloat = 30
        xButton.frame = CGRect(x: background.frame.maxX-buttonSize*1.5, y: background.frame.minY+buttonSize/2, width: buttonSize, height: buttonSize)
        xButton.layer.zPosition = 502
        let image = UIImage(named: "icons8-multiply-50")
        xButton.setImage(image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        xButton.imageView?.tintColor = defaultColor.MenuButtonTextColor
        xButton.imageView?.alpha = 1.0
        xButton.addTarget(self, action: #selector(handleXButtonPress), for: .touchDown)
        vc!.view.addSubview(xButton)
        
        removeFromView()
    }
    
    @objc func handleButtonPress() {
        DimOverlay.alpha = 0.0
        removeFromView()
        sendEmail()
    }
    
     @objc func handleXButtonPress() {
        DimOverlay.alpha = 0.0
        removeFromView()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["joeybergermusic@gmail.com"])
            mail.setSubject("Guitar Mult Question/Issue")
            var id = "noID"
            if UserDefaults.standard.object(forKey: "id") != nil {
                  id = UserDefaults.standard.object(forKey: "id") as! String
              } 
            mail.setMessageBody("<br><br><br><br><br><br><br><br><br><br><br><br><p>------------------------------------------------------------</p><p>ID :</p><p> \(id)</p>", isHTML: true)
            present(mail, animated: true)
            UIApplication.shared.keyWindow?.rootViewController?.present(mail, animated: true)
        } else {
            print("Application is not able to send an email")
        }
    }

    //MARK: MFMail Compose ViewController Delegate method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func removeFromView() {
        background.removeFromSuperview()
        mainButton.removeFromSuperview()
        buttonText.removeFromSuperview()
        titleText.removeFromSuperview()
//        subTitleText.removeFromSuperview()
        xButton.removeFromSuperview()
        for text in subText {
            text.removeFromSuperview()
        }
        for button in vc!.buttonArr {
            button.isEnabled = true
        }
    }
    
    func addToView() {
        popoverVisible = true
        vc!.view.addSubview(background)
        vc!.view.addSubview(mainButton)
        vc!.view.addSubview(buttonText)
        vc!.view.addSubview(titleText)
        vc!.view.addSubview(xButton)
        for text in subText {
            vc!.view.addSubview(text)
        }
        DimOverlay.alpha = 0.85
        
        vc!.Button0.isEnabled = false
        
        for button in vc!.buttonArr {
            button.isEnabled = false
        }
    }
    
    @objc func animationWaitThen(_ timer: Timer) {
        let parametersObj = timer.userInfo as! [String: AnyObject]
        switch parametersObj["arg1"] as! String {
        case "mainButton":
            mainButton.isHidden = false
            mainButton.setAndPlayAnim()
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
    }
    
    func setupPopoverText(isubtitle: String, isubText: [String]) {
        for text in subText {
            text.text = ""
        }
        for (i,subtext) in isubText.enumerated() {
            subText[i].text = subtext
        }
    }
}
