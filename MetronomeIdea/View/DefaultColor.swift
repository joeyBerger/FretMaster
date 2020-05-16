import UIKit

struct DefaultColor {
    
    let MenuButtonColor = UIColor(red: 53 / 255, green: 0 / 255, blue: 211 / 255, alpha: 1.0)
    let BackgroundColor = UIColor(red: 12 / 255, green: 0 / 255, blue: 50 / 255, alpha: 1.0)
    let MenuButtonTextColor = UIColor.white
    let AlternateButtonInlayColor = UIColor.white
    let InactiveButton = UIColor(red: 40 / 255, green: 40 / 255, blue: 40 / 255, alpha: 0.8)
    let InactiveInlay = UIColor(red: 147 / 255, green: 154 / 255, blue: 184 / 255, alpha: 1.0)
    let ResultsButtonColor = UIColor(red: 25 / 255, green: 0 / 255, blue: 97 / 255, alpha: 1.0)
    let NavBarTitleColor = UIColor.white
    let ProgressBarColor = UIColor(red: 13 / 255, green: 255 / 255, blue: 0 / 255, alpha: 1.0)
    let ProgressTrackColor = UIColor(red: 53 / 255, green: 0 / 255, blue: 211 / 255, alpha: 1.0)
    let TableViewBackground = UIColor(red: 221 / 255, green: 160 / 255, blue: 221 / 255, alpha: 1.0)
    let AcceptColor = UIColor(red: 42 / 255, green: 181 / 255, blue: 118 / 255, alpha: 1.0)
    
    
//    let FretMarkerSuccess = convertRGBToUIColor().convert(75,181,67)
    let FretMarkerStandard = convertRGBToUIColor().convert(256,0,0)
    let FretMarkerSuccess = convertRGBToUIColor().convert(80,180,74)
}

class convertRGBToUIColor {
    func convert(_ r:Double, _ g:Double, _ b:Double, _ a:Double = 1.0) -> UIColor {
        return UIColor(red: CGFloat(r / 255), green: CGFloat(g / 255), blue: CGFloat(b / 255), alpha: 1.0)
    }
}
