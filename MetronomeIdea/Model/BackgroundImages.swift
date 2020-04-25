//
//  BackgroundImages.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 4/24/20.
//  Copyright © 2020 ashubin.com. All rights reserved.
//

import Foundation
import UIKit
class BackgroundImage {

    var images: [String:UIImage?] = [
        "Menu" : nil,
        "Scales" : nil,
        "Arpeggios" : nil
    ]
    
    var defaultImages = [
        "Menu" : "AcousticMain.png",
        "Scales" : "RockCrowd.png",
        "Arpeggios" : "RockCrowd2.jpg"
    ]
    
    var searchTypes = [
        "guitar",
        "metronome",
        "rockmusic",
        "concert",
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
