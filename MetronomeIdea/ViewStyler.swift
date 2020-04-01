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
        print(ibackgroundPic)
        let bgImage = UIImageView(image: UIImage(named: ibackgroundPic))
        bgImage.frame = CGRect(x: 0, y: 0, width: (currentVC?.view.bounds.size.width)!, height: currentVC!.view.bounds.size.height)
         bgImage.contentMode = UIView.ContentMode.scaleAspectFill
        currentVC!.view.insertSubview(bgImage, at: 0)
    }
    
}
