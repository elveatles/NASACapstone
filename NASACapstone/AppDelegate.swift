//
//  AppDelegate.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/16/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit
import CoreLocation
import FacebookCore

/**
 I tested this app with instruments on a physical device by clicking on "Show Debug Navigator" in the top left of Xcode. I clicked on "CPU", then "Profile in Instruments", then "Transfer" when prompted. I used the app and paused the instrument when I saw spikes in CPU usage. It helped to click on "Call Tree" at the bottom and check the boxes for "Hide System Libraries" and "Invert Call Tree".
 I did the same for RAM, pausing when memory increased dramatically, or when the Leaks timeline showed a problem. I would click "Mark Generation" before tapping on something to see how much memory was allocated for a specific action in the app. It helped to type the app name "NASACapstone" into the app to filter out memory unrelated to my code.
 Mainly, there was not much I could do to improve performance or memory usage because the app needed all of the resources it was using. I believe the memory continues to rise mainly because of Kingfisher caching images. Kingfisher is supposed to make sure caches don't go past their size limit. So mainly what I would do is change the cache size limit if I needed to.
*/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
}

