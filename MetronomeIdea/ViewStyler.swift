import Foundation
import UIKit

class ViewStyler: UIViewController {
    
    var currentVC: UIViewController?
    
    convenience init() {
        self.init(ivc: nil)
    }
    
    init(ivc: UIViewController?) {
        self.currentVC = ivc!
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupBackgroundImage(ibackgroundPic: String) {
        let bgImage = UIImageView(image: UIImage(named: ibackgroundPic))
        bgImage.frame = CGRect(x: 0, y: 0, width: (currentVC?.view.bounds.size.width)!, height: currentVC!.view.bounds.size.height)
         bgImage.contentMode = UIView.ContentMode.scaleAspectFill
        currentVC!.view.insertSubview(bgImage, at: 0)
    }
    
    func navBarFillerInit(iNavBar: UINavigationBar) -> UIImageView {
        let NavBarFiller = UIImageView()
        let newFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: iNavBar.frame.minY)
        NavBarFiller.frame = newFrame
        NavBarFiller.backgroundColor = defaultColor.MenuButtonColor
        return NavBarFiller
    }
    
    func setupNavBar(iNavBar: UINavigationBar) {
        iNavBar.barTintColor = defaultColor.MenuButtonColor
        iNavBar.isTranslucent = false
        iNavBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: defaultColor.NavBarTitleColor]
    }
    
    func setupNavBarComponents(iNavBackButton: UIBarButtonItem, iNavSettingsButton: UIBarButtonItem? = nil) {
        iNavBackButton.tintColor = defaultColor.MenuButtonTextColor
        if let iNavSettingsButton = iNavSettingsButton {
            iNavSettingsButton.tintColor = defaultColor.MenuButtonTextColor
        }
    }
    
    func setupBackButtonAnnotation(iNavBar: UINavigationBar) -> UIButton {
        let backButtonAnnotation = UIButton()
        let screenRect = UIScreen.main.bounds
        let width = screenRect.size.width*0.25
        backButtonAnnotation.frame = CGRect(x: 0, y: 0, width: width, height: iNavBar.frame.height)
        return backButtonAnnotation
    }
    
    func setupSettingsButtonAnnotation(iNavBar: UINavigationBar) -> UIButton {
        let settingsButtonAnnotation = UIButton()
        settingsButtonAnnotation.frame = CGRect(x: iNavBar.frame.width-100, y: iNavBar.frame.minY, width: 100, height: iNavBar.frame.height)
        return settingsButtonAnnotation
    }
    
    func setupMenuButton (ibutton : UIButton, ititle: String, isubtext : String, iprogressAmount: Float, itutorialComplete : Bool = true) {
            var buttonColor: UIColor
            var textColor: UIColor
            
            if (!itutorialComplete) {
                buttonColor = defaultColor.InactiveButton;
                textColor = defaultColor.InactiveInlay
            } else {
                buttonColor = defaultColor.MenuButtonColor;
                textColor = defaultColor.MenuButtonTextColor
            }

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
            
            if (iprogressAmount >= 0.0) {
                let progressSlider = UIProgressView()
                progressSlider.frame = CGRect(x: (width-(width * 0.85))/2.0 ,y: 75,width: (width * 0.85),height: 62)
                let progressAmount = iprogressAmount == 0.0 ? 0.05 : iprogressAmount
                progressSlider.setProgress(progressAmount, animated: true)
                progressSlider.progressTintColor = defaultColor.ProgressBarColor
                progressSlider.trackTintColor = defaultColor.ProgressTrackColor
                ibutton.addSubview(progressSlider)
            }
        }
}
