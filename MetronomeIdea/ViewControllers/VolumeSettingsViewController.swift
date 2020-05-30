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
        volume.volumeTypes[volumeTypes[sender.tag]] = sender.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        var styler: ViewStyler?
        styler = ViewStyler(ivc: self)
        styler!.setupBackgroundImage(ibackgroundPic: "SettingsImage\(backgroundImageID).jpg")
        let sliders = [masterVolSlider, guitarVolSlider, clickVolSlider]
        let text = [masterVolumeText,guitarVolumeText,clickVolumeText]
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
