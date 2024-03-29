import Foundation
import UIKit
class BackgroundImage {
    var images: [String: UIImage?] = [
        "menu": nil,
        "scales": nil,
        "arpeggios": nil,
        "intervals": nil,
    ]

    var defaultImages = [
        "menu": "AcousticMain.png",
        "scales": "RockCrowd.png",
        "arpeggios": "RockCrowd2.jpg",
        "intervals": "RockCrowd2.jpg"
    ]

    var searchStrings = [
        "menu": ["guitar", "concert"],
        "scales": ["concert", "music", "music+venue"],
        "arpeggios": ["concert", "music", "music+venue"],
        "intervals": ["concert", "music", "music+venue"],
    ]

    func returnImage(_ imageStr: String) -> UIImage {
        if let image = images[imageStr]! {
            let newImage = UIImageView()
            newImage.image = image
            return image
        } else {
            let image = UIImage(named: defaultImages[imageStr]!)!
            return image
        }
    }
}
