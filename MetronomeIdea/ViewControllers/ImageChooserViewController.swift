//
//  ImageChooserViewController.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 4/24/20.
//  Copyright © 2020 ashubin.com. All rights reserved.
//

import UIKit

class ImageChooserViewController: UIViewController {
    
    var bgImage = UIImageView()
    var selectedBackground = "Menu"
    let flickr = Flickr()
    let changeButton = UIButton()
    let acceptButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupButtons()
    }
    
    func setupBackground() {
        if let image = backgroundImage.images[selectedBackground]! {
            bgImage.image = image
        } else {
            bgImage = UIImageView(image: UIImage(named: "AcousticMain.png"))
        }

        bgImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        bgImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(bgImage, at: 0)
    }
    
    func setupButtons() {
        
        let buttons = [changeButton,acceptButton]
        let title = ["CHANGE","ACCEPT"]
        let color = [defaultColor.MenuButtonColor,defaultColor.AcceptColor]
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        let width:CGFloat = screenWidth * 0.72
        let height:CGFloat = 70
        let yBuffer:CGFloat = 190
        let buttonBuffer = 100
        
        for (i,button) in buttons.enumerated() {
            
            button.frame = CGRect(x: screenWidth*0.5-width/2, y: screenHeight-height-yBuffer+CGFloat(buttonBuffer*i), width: width, height: height)
            button.backgroundColor = color[i]
            button.layer.cornerRadius = 10
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 0.0
            button.layer.masksToBounds = false
            button.setTitle(title[i], for: .normal)
            button.tintColor = defaultColor.MenuButtonTextColor
            button.titleLabel?.font = .systemFont(ofSize: 18)
//            button.addTarget(self, action: #selector(functions[i]), for: .touchDown)
            view.addSubview(button)
        }
        buttons[0].addTarget(self, action: #selector(onChangeButtonDown), for: .touchDown)
        buttons[1].addTarget(self, action: #selector(onAcceptButtonDown), for: .touchDown)
    }
    
    @objc func onChangeButtonDown() {
        controlButtonState(false)
        flickr.unsplashTry(for: "guitar") { imageURL in
            self.flickr.unsplashImageDownload(for: imageURL.full) { image in
                self.bgImage.image = image
                backgroundImage.images[self.selectedBackground] = image
                self.controlButtonState(true)
            }
        }
    }
    
    @objc func onAcceptButtonDown() {
        backgroundImage.images[selectedBackground] = bgImage.image

        print("backgroundImage.images[selectedBackground] \(backgroundImage.images[selectedBackground] )")
        navigationController?.popViewController(animated: false)
        
    }
    
    func controlButtonState(_ enabled: Bool) {
        changeButton.isEnabled = enabled
        acceptButton.isEnabled = enabled
    }
}
