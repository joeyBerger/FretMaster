//
//  AppDelegate.swift
//  MetronomeIdea
//
//  Created by Alex Shubin on 21/06/2018.
//  Copyright © 2018 ashubin.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
//    let dataController = DataController(modelName: "ImageModel")
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        dataController.load()
        
        let navigationController = window?.rootViewController as! UINavigationController
//        let notebooksListViewController = navigationController.topViewController as! MenuViewController
//        globalDataController = self.dataController
//        notebooksListViewController.dataController = dataController
        
        return true
    }
}

