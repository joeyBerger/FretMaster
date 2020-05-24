import UIKit

class VolumeSettingsViewController: UIViewController {
    @IBOutlet var masterVolSlider: UISlider!
    @IBOutlet var guitarVolSlider: UISlider!
    @IBOutlet var clickVolSlider: UISlider!

    let volumeTypes = ["masterVol", "guitarVol", "clickVol"]
    var backgroundImageID = 0

    @IBAction func onSliderChange(_ sender: UISlider) {
        volume.volumeTypes[volumeTypes[sender.tag]] = sender.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let sliders = [masterVolSlider, guitarVolSlider, clickVolSlider]
        for (i, slider) in sliders.enumerated() {
            slider?.setValue(volume.volumeTypes[volumeTypes[i]]!, animated: true)            
            //main color
            slider?.thumbTintColor = defaultColor.ProgressTrackColor
            slider?.minimumTrackTintColor = defaultColor.ProgressTrackColor
            //other color
            slider?.maximumTrackTintColor = defaultColor.ProgressBarColor
        }
        
        var styler: ViewStyler?
        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "SettingsImage\(backgroundImageID).jpg")
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
