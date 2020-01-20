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
        
        
        
        Button2.backgroundColor = UIColor.red
        Button2.setTitleColor(UIColor.white, for: .normal)
        Button2.setTitle("Butt 2", for: .normal)
        Button2.layer.shadowColor = UIColor.black.cgColor
        Button2.layer.shadowOffset = CGSize(width: 2, height: 2)
        Button2.layer.shadowRadius = 2
        Button2.layer.shadowOpacity = 0.6
        
        print("ibutton \(Button2.frame)")
       
        let width = Button2.frame.width
        let buttonSubtext = UILabel()
        buttonSubtext.frame = CGRect(x: 0,y: 20,width: width, height: Button2.frame.height)
//        buttonSubtext.bounds = CGRect(x: 0,y: 0, width: width, height: ibutton.frame.height)
        buttonSubtext.textAlignment = NSTextAlignment.center
        buttonSubtext.text = "isubtext";
        buttonSubtext.layer.zPosition = 1;
        buttonSubtext.textColor = UIColor.white
        Button2.addSubview(buttonSubtext)
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
