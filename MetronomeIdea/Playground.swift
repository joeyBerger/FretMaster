//
//  Playground.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 12/22/19.
//  Copyright © 2019 ashubin.com. All rights reserved.
//

import Foundation
import UIKit
import AMPopTip

class Playground: UIViewController {
    
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var Button0: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    var popTip : PopTip = PopTip()
    var butt : UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate = returnStackViewButtonCoordinates(istackViewButton: Button0, istack: stackView)
        popTip.show(text: "   Hey! Masako!   ", direction: .left, maxWidth: 200, in: view, from: coordinate)
    }
    
    @IBAction func button0Down(_ sender: Any) {
        
    }
    
    func returnStackViewButtonCoordinates(istackViewButton: UIButton, istack: UIStackView) -> CGRect {

        let spacing = istack.arrangedSubviews[1].frame.minY - istack.arrangedSubviews[0].frame.minY
        let minX = istack.frame.minX
        let minY = istack.frame.minY - CGFloat(spacing) + istackViewButton.frame.height/2 + istackViewButton.frame.minY
        let width = istack.frame.width
        let height = istack.frame.height
        let view1 = UIView(frame: CGRect(x: minX, y: minY, width: width, height: height))
        return view1.frame
    }
}
