//
//  AppDelegate.swift
//  SafeRide
//
//  Created by Caleb Friden on 3/30/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftDDP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Meteor Setup
        Meteor.client.allowSelfSignedSSL = false     // Connect to a server that uses a self signed ssl certificate
        Meteor.client.logLevel = .None
        let websocketURL = "wss://saferide.meteorapp.com/websocket"
        Meteor.connect(websocketURL) {
        }
        // Override point for customization after application launch.
        if let userRole = NSUserDefaults.standardUserDefaults().objectForKey("userRole") {
            let role = userRole as! String
            if (role == "rider") {
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.window?.rootViewController = storyboard.instantiateInitialViewController()
            }
            else if (role == "employee") {
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewControllerWithIdentifier("employeeNavigationController")
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
            }
        }
        else {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("homeViewController")
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
        GMSServices.provideAPIKey("AIzaSyCPHhAPneKcheJLtYeyX6yn2U7KxuN9qz4")
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

