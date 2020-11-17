import Foundation
import UIKit

class FretOffsetPickerPopover: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var vc: MainViewController?
    var background = SpringImageView()
    var mainButton = SpringButton()
    var buttonText = SpringLabel()
    var titleText = SpringLabel()
    var subTitleText = SpringLabel()
    var subText = [SpringLabel()]
    var xButton = SpringButton()
    var picker = UIPickerView()
    var mainPopoverVisible = false
    var mainPopoverState = ""
    
    var pickerList: [String] = []
    
    convenience init() {
        self.init(ivc: nil)
    }

    init(ivc: UIViewController?) {
        vc = ivc as? MainViewController
        for i in 1..<12 {
            pickerList.append("\(i+1)\(vc!.sCollection!.returnLinguisticNumberEquivalent(String(i+1))) Fret")
        }
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
        let height:CGFloat = 335
        
        background.frame = CGRect(x: (screenWidth-width)/2, y: (screenHeight - height)/2, width: width, height: height)
        background.layer.zPosition = 500
        background.backgroundColor = defaultColor.MenuButtonColor
        background.layer.cornerRadius = 20
        
        titleText.frame = CGRect(x: background.frame.minX,y: background.frame.minY+10,width: background.frame.width, height: 65)
        titleText.text = "Guitar Mult"
        titleText.layer.zPosition = 502
        titleText.textAlignment = .center
//        titleText.font = UIFont(name:"MrsSheppards-Regular",size:50)
        titleText.font = UIFont(name:"Arizonia-Regular",size:50)
        titleText.textColor = defaultColor.FretMarkerStandard
        titleText.layer.shadowColor = UIColor.black.cgColor
        titleText.layer.shadowRadius = 3.0
        titleText.layer.shadowOpacity = 1.0
        titleText.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleText.layer.masksToBounds = false
        
        subTitleText.frame = CGRect(x: background.frame.minX,y: titleText.frame.maxY-30,width: background.frame.width, height: 100)
        subTitleText.text = "CHOOSE A FRET POSITION"
        subTitleText.layer.zPosition = 502
        subTitleText.textAlignment = .center
        subTitleText.font = buttonText.font.withSize(22)
        subTitleText.textColor = defaultColor.MenuButtonTextColor
        vc!.styler!.addStandardLabelShadow(subTitleText)
        
        picker.frame = CGRect(x: (screenWidth - picker.frame.width*0.7)/2, y: subTitleText.frame.minY+65, width: picker.frame.width*0.7, height: picker.frame.height)
        picker.layer.zPosition = 501
        picker.delegate = self
        picker.dataSource = self
        
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
//        vc!.fretOffset = (picker.selectedRow(inComponent: 0)+1) - vc!.defaultFretOffset
        vc!.fretOffset = (picker.selectedRow(inComponent: 0)+2) - vc!.defaultFretOffset
        vc!.handleFretOffsetChange()
        removeFromView()
    }
    
    func removeFromView() {
        background.removeFromSuperview()
        titleText.removeFromSuperview()
        xButton.removeFromSuperview()
        subTitleText.removeFromSuperview()
        picker.removeFromSuperview()
        if vc!.DimOverlay != nil {
            vc!.swoopAlpha(iobject: vc!.DimOverlay, ialpha: 0.0, iduration: 0.3)
        }
    }
    
    func addToView() {
        mainPopoverVisible = true
        vc!.view.addSubview(background)
        vc!.view.addSubview(titleText)
        vc!.view.addSubview(xButton)
        vc!.view.addSubview(subTitleText)
        vc!.view.addSubview(picker)
//        picker.selectRow((vc!.defaultFretOffset-1) + vc!.fretOffset, inComponent: 0, animated: true)
        picker.selectRow((vc!.defaultFretOffset-2) + vc!.fretOffset, inComponent: 0, animated: true)
        vc!.swoopAlpha(iobject: vc!.DimOverlay, ialpha: 0.8, iduration: 0.3)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerList.count
        } else {
            return 100
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "First \(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerList[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
}
