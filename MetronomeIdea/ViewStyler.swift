//
//  ViewStyler.swift
//  MetronomeIdea
//
//  Created by Joey Berger on 3/31/20.
//  Copyright © 2020 ashubin.com. All rights reserved.
//

import Foundation
import UIKit

class ViewStyler: UIViewController {
    
    var currentVC: UIViewController?
    
    convenience init() {
        self.init(ivc: nil)
    }
    
    init(ivc: UIViewController?) {
        self.currentVC = ivc!
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupBackgroundImage(ibackgroundPic: String) {
        let bgImage = UIImageView(image: UIImage(named: ibackgroundPic))
        bgImage.frame = CGRect(x: 0, y: 0, width: (currentVC?.view.bounds.size.width)!, height: currentVC!.view.bounds.size.height)
         bgImage.contentMode = UIView.ContentMode.scaleAspectFill
        currentVC!.view.insertSubview(bgImage, at: 0)
    }
    
    func navBarFillerInit(iNavBar: UINavigationBar) -> UIImageView {
        let NavBarFiller = UIImageView()
        let newFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: iNavBar.frame.minY)
        NavBarFiller.frame = newFrame
        NavBarFiller.backgroundColor = defaultColor.MenuButtonColor
        return NavBarFiller
    }
    
    func setupNavBar(iNavBar: UINavigationBar) {
        iNavBar.barTintColor = defaultColor.MenuButtonColor
        iNavBar.isTranslucent = false
        iNavBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: defaultColor.NavBarTitleColor]
    }
    
    func setupNavBarComponents(iNavBackButton: UIBarButtonItem, iNavSettingsButton: UIBarButtonItem? = nil) {
        iNavBackButton.tintColor = defaultColor.MenuButtonTextColor
        if let iNavSettingsButton = iNavSettingsButton {
            iNavSettingsButton.tintColor = defaultColor.MenuButtonTextColor
        }
    }
    
    func setupBackButtonAnnotation(iNavBar: UINavigationBar) -> UIButton {
        let backButtonAnnotation = UIButton()
       backButtonAnnotation.frame = CGRect(x: 0, y: iNavBar.frame.minY, width: 100, height: iNavBar.frame.height)
        return backButtonAnnotation
    }
    
    func setupSettingsButtonAnnotation(iNavBar: UINavigationBar) -> UIButton {
        let settingsButtonAnnotation = UIButton()
        settingsButtonAnnotation.frame = CGRect(x: iNavBar.frame.width-100, y: iNavBar.frame.minY, width: 100, height: iNavBar.frame.height)
        return settingsButtonAnnotation
    }
}
