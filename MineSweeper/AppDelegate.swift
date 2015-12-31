//
//  AppDelegate.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld & Logan Allen on 12/2/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Set containerVC as window's root
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let containerViewController = ContainerViewController()
        window?.rootViewController = containerViewController
        window?.makeKeyAndVisible()
        
        // Establish data for Best Times
        let kArray = ["8Easy", "10Easy", "12Easy", "8Medium", "10Medium", "12Medium", "8Hard", "10Hard", "12Hard"]
        for key in kArray {
            if NSUserDefaults.standardUserDefaults().valueForKey(key) == nil {
                NSUserDefaults.standardUserDefaults().setValue(0, forKey: key)
            }
        }
        
        // Establish data for number of failures
        let fArray = ["8EasyFails", "10EasyFails", "12EasyFails", "8MediumFails", "10MediumFails", "12MediumFails", "8HardFails", "10HardFails", "12HardFails"]
        for f in fArray{
            if NSUserDefaults.standardUserDefaults().valueForKey(f) == nil{
                NSUserDefaults.standardUserDefaults().setValue(0, forKey: f)
            }
        }
        
        // Establish data for number of wins
        let wArray = ["8EasyWins", "10EasyWins", "12EasyWins", "8MediumWins", "10MediumWins", "12MediumWins", "8HardWins", "10HardWins", "12HardWins"]
        for w in wArray{
            if NSUserDefaults.standardUserDefaults().valueForKey(w) == nil{
                NSUserDefaults.standardUserDefaults().setValue(0, forKey: w)
            }
        }
        
        // Establish data for theme (initially Day)
        if NSUserDefaults.standardUserDefaults().valueForKey("theme") ==  nil {
            NSUserDefaults.standardUserDefaults().setValue("Day", forKey: "theme")
        }
        
        Style.changeTheme()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

