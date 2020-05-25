import UIKit

class VolumeSettingsViewController: UIViewController {
    @IBOutlet var masterVolSlider: UISlider!
    @IBOutlet var guitarVolSlider: UISlider!
    @IBOutlet var clickVolSlider: UISlider!
    @IBOutlet weak var masterVolumeText: UILabel!
    @IBOutlet weak var guitarVolumeText: UILabel!
    @IBOutlet weak var clickVolumeText: UILabel!
    
    let volumeTypes = ["masterVol", "guitarVol", "clickVol"]
    var backgroundImageID = 0

    @IBAction func onSliderChange(_ sender: UISlider) {
        print("onSliderChange =",sender.value)
        volume.volumeTypes[volumeTypes[sender.tag]] = sender.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let sliders = [masterVolSlider, guitarVolSlider, clickVolSlider]
        let text = [masterVolumeText,guitarVolumeText,clickVolumeText]
//        let topBuffer:CGFloat = 70

//        for (i, slider) in sliders.enumerated() {
//            slider?.setValue(volume.volumeTypes[volumeTypes[i]]!, animated: true)
//            //main color
//            slider?.thumbTintColor = defaultColor.ProgressTrackColor
//            slider?.minimumTrackTintColor = defaultColor.ProgressTrackColor
//            //other color
//            slider?.maximumTrackTintColor = defaultColor.ProgressBarColor
//
//
//            let screenRect = UIScreen.main.bounds
//            let screenWidth = screenRect.size.width
////            let screenHeight = screenRect.size.height
//
//            let startY = (navigationController?.navigationBar.frame.maxY)! + topBuffer
//            let containerBuffer:CGFloat = 130
//            let sliderHeightBuffer:CGFloat = 40
//            text[i]?.frame = CGRect(x: (screenWidth-screenWidth*0.8)/2, y: startY + CGFloat(i) * containerBuffer, width: screenWidth*0.8, height: 100)
//            slider?.frame = CGRect(x: (screenWidth-screenWidth*0.9)/2, y: (text[i]?.frame.minY)!+sliderHeightBuffer, width: screenWidth*0.9, height: (100))
//
//            text[i]?.font = UIFont(name: (text[i]?.font.fontName)!, size: 23)
//            text[i]?.text = text[i]?.text!.uppercased()
//            text[i]?.textColor = defaultColor.MenuButtonTextColor
//
//
//            text[i]?.layer.shadowColor = UIColor.black.cgColor
//            text[i]?.layer.shadowRadius = 3.0
//            text[i]?.layer.shadowOpacity = 1.0
//            text[i]?.layer.shadowOffset = CGSize(width: 4, height: 10)
//            text[i]?.layer.masksToBounds = false
//        }
        
        var styler: ViewStyler?
        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "SettingsImage\(backgroundImageID).jpg")
        styler!.setupVolumeControls(sliders, text, volumeTypes, navigationController!)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if navigationController?.viewControllers.index(of: self) == nil {
            for volStr in volumeTypes {
                UserDefaults.standard.set(volume.volumeTypes[volStr], forKey: volStr)
            }
        }
        super.viewWillDisappear(animated)
    }
}
