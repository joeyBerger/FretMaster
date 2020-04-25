import UIKit

class VolumeSettingsViewController : UIViewController {
    
    @IBOutlet weak var masterVolLabel: UILabel!
    
    @IBOutlet weak var masterVolSlider: UISlider!
    @IBOutlet weak var guitarVolSlider: UISlider!
    @IBOutlet weak var clickVolSlider: UISlider!
    
    let volumeTypes = ["masterVol","guitarVol","clickVol"]
    
    @IBAction func onSliderChange(_ sender: UISlider) {
        volume.volumeTypes[volumeTypes[sender.tag]] = sender.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sliders = [masterVolSlider,guitarVolSlider,clickVolSlider]
        for (i,slider) in sliders.enumerated() {
            slider?.setValue(volume.volumeTypes[volumeTypes[i]]!,animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.navigationController?.viewControllers.index(of: self) == nil {
            for volStr in volumeTypes {
                //write to data
                UserDefaults.standard.set(volume.volumeTypes[volStr], forKey: volStr)
            }
        }
        super.viewWillDisappear(animated)
    }
}
