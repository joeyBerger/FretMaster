import Foundation
import UIKit

class ViewStyler: UIViewController {
    var currentVC: UIViewController?

    convenience init() {
        self.init(ivc: nil)
    }

    init(ivc: UIViewController?) {
        currentVC = ivc!
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
        let width = screenRect.size.width * 0.25
        backButtonAnnotation.frame = CGRect(x: 0, y: 0, width: width, height: iNavBar.frame.height)
        return backButtonAnnotation
    }

    func setupSettingsButtonAnnotation(iNavBar: UINavigationBar) -> UIButton {
        let settingsButtonAnnotation = UIButton()
        settingsButtonAnnotation.frame = CGRect(x: iNavBar.frame.width - 100, y: iNavBar.frame.minY, width: 100, height: iNavBar.frame.height)
        return settingsButtonAnnotation
    }

    func setupMenuButton(ibutton: UIButton, isubText: UILabel, iprogressBar: UIProgressView? = nil) {
        ibutton.layer.shadowColor = UIColor.black.cgColor
        ibutton.layer.shadowOffset = CGSize(width: 2, height: 5)
        ibutton.layer.shadowRadius = 2
        ibutton.layer.shadowOpacity = 0.6
        ibutton.layer.cornerRadius = 8
        
        ibutton.contentHorizontalAlignment = .center
        ibutton.contentVerticalAlignment = .top
        ibutton.titleEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0.0, right: 0.0)

        let width = ibutton.frame.width * 0.94
        let x = (ibutton.frame.width - width) / 2
        isubText.frame = CGRect(x: x, y: 0+8, width: width, height: ibutton.frame.height + 30)
        isubText.textAlignment = NSTextAlignment.center
        isubText.adjustsFontSizeToFitWidth = true

        isubText.layer.zPosition = 1
        ibutton.addSubview(isubText)

        if let progressBar = iprogressBar {
            progressBar.frame = CGRect(x: (width - (width * 0.85)) / 2.0, y: 75+15, width: width * 0.85, height: 62)
            ibutton.addSubview(progressBar)
        }
    }
    
    func setupVolumeControls(_ isliders: [UISlider?],_ itext: [UILabel?], _ volumeTypes: [String],_ inavigationController: UINavigationController) {
            let topBuffer:CGFloat = 70
            let startY = (inavigationController.navigationBar.frame.maxY) + topBuffer
            let screenRect = UIScreen.main.bounds
            let screenWidth = screenRect.size.width
            let containerBuffer:CGFloat = 130
            let sliderHeightBuffer:CGFloat = 40
        
            for (i, slider) in isliders.enumerated() {
                slider?.setValue(volume.volumeTypes[volumeTypes[i]]!, animated: true)
                //main color
                slider?.thumbTintColor = defaultColor.ProgressTrackColor
                slider?.minimumTrackTintColor = defaultColor.ProgressTrackColor
                //other color
                slider?.maximumTrackTintColor = defaultColor.ProgressBarColor

                itext[i]?.frame = CGRect(x: (screenWidth-screenWidth*0.8)/2, y: startY + CGFloat(i) * containerBuffer, width: screenWidth*0.8, height: 100)
                slider?.frame = CGRect(x: (screenWidth-screenWidth*0.9)/2, y: (itext[i]?.frame.minY)!+sliderHeightBuffer, width: screenWidth*0.9, height: (100))
                
                itext[i]?.font = UIFont(name: "System - System", size: 85)
                itext[i]?.font = itext[i]?.font.withSize(30)
                itext[i]?.text = itext[i]?.text!.uppercased()
                itext[i]?.textColor = defaultColor.FretMarkerStandard
                
                itext[i]?.layer.shadowColor = UIColor.black.cgColor
                itext[i]?.layer.shadowRadius = 3.0
                itext[i]?.layer.shadowOpacity = 0.5
                itext[i]?.layer.shadowOffset = CGSize(width: 4, height: 5)
                itext[i]?.layer.masksToBounds = false
            }
    }
    
    func displayTitle(_ iview: UIViewController,_ inavigationConroller: UINavigationController,_ itext: String) {
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let fontSize: CGFloat = 21
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: defaultColor.NavBarTitleColor, NSAttributedString.Key.font: UIFont(name: "System - System", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),NSAttributedString.Key.paragraphStyle : paragraphStyle]
        
        inavigationConroller.navigationBar.titleTextAttributes = textAttributes
        inavigationConroller.navigationBar.tintColor = .white
        
        iview.title = itext
    }
    
    func displayStyledTitle(_ inavigationConroller: UINavigationController,_ ifontSize: CGFloat) {
        
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
//        let textAttributes = [NSAttributedString.Key.foregroundColor: defaultColor.NavBarTitleColor, NSAttributedString.Key.font: UIFont(name: "MrsSheppards-Regular", size: ifontSize) ?? UIFont.systemFont(ofSize: ifontSize),NSAttributedString.Key.paragraphStyle : paragraphStyle]
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: defaultColor.NavBarTitleColor, NSAttributedString.Key.font: UIFont(name: "Arizonia-Regular", size: ifontSize) ?? UIFont.systemFont(ofSize: ifontSize),NSAttributedString.Key.paragraphStyle : paragraphStyle]
        
        
        
//        let textAttributes = [NSAttributedString.Key.foregroundColor: defaultColor.NavBarTitleColor, NSAttributedString.Key.font: UIFont(name: "System-System", size: 25) ?? UIFont.systemFont(ofSize: 25),NSAttributedString.Key.paragraphStyle : paragraphStyle]
        
        inavigationConroller.navigationBar.titleTextAttributes = textAttributes
        inavigationConroller.navigationBar.tintColor = .white
    }
    
    func spaceButtons(_ ibuttonArr: [UIButton],_ inavigationConroller: UINavigationController) {
         let screenRect = UIScreen.main.bounds
         let screenWidth = screenRect.size.width
         let screenHeight = screenRect.size.height
        
         let navigationHeight = inavigationConroller.navigationBar.frame.maxY
        
         let buffer:CGFloat = returnButtonBuffer(screenHeight - navigationHeight)
         let availableScreenHeight = screenHeight - (inavigationConroller.navigationBar.frame.maxY) - (buffer*2)
         
         let spacing:CGFloat = availableScreenHeight/5

         for (i,button) in ibuttonArr.enumerated() {
              let y = (buffer + button.frame.height) + (spacing) * CGFloat(i)
             button.frame = CGRect(x: screenWidth/2-button.frame.width/2, y: y, width: button.frame.width, height: button.frame.height)
         }
    }
    
    func addStandardLabelShadow(_ iUILabel: UILabel) {
        iUILabel.layer.shadowColor = UIColor.black.cgColor
        iUILabel.layer.shadowRadius = 1.0
        iUILabel.layer.shadowOpacity = 1.0
        iUILabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        iUILabel.layer.masksToBounds = false
    }
    
    func returnButtonBuffer(_ iscreenSpace: CGFloat) -> CGFloat {
        print("iscreenSpace",iscreenSpace)
        if iscreenSpace > 650 {
            if iscreenSpace == 692 {return 50.0}
            if iscreenSpace == 768 {return 85.0}
            return 110.0
        } else if iscreenSpace > 600 {
            return 30.0
        }
        return 15.0
    }

    func setupMenuButtonAttributes(ibutton: UIButton, isubText: UILabel, iprogressBar: UIProgressView? = nil, ibuttonActive: Bool, ibuttonStr: String, isubTextStr: String, iprogressAmount: Float) {
        var buttonColor: UIColor
        var textColor: UIColor

        if !ibuttonActive {
            buttonColor = defaultColor.InactiveButton
            textColor = defaultColor.InactiveInlay
        } else {
            buttonColor = defaultColor.MenuButtonColor
            textColor = defaultColor.MenuButtonTextColor
        }

        ibutton.backgroundColor = buttonColor
        ibutton.setTitleColor(textColor, for: .normal)
        ibutton.setTitle(ibuttonStr, for: .normal)

        isubText.text = isubTextStr
        isubText.textColor = textColor

        if iprogressAmount >= 0.0 {
            let progressAmount = iprogressAmount == 0.0 ? 0.05 : iprogressAmount
            iprogressBar!.setProgress(progressAmount, animated: true)
            iprogressBar!.progressTintColor = defaultColor.ProgressBarColor
            iprogressBar!.trackTintColor = defaultColor.ProgressTrackColor
        }
    }
}
