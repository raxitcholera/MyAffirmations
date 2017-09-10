//
//  AppDelegate.swift
//  MyAffirmations
//
//  Created by Raxit Cholera on 8/14/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let stack = CoreDataStack(modelName: "MyAffirmations")!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkIfFirstLaunch()
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
        // Saves changes in the application's managed object context before the application terminates.
    }

    
    func checkIfFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "HasLaunchedBefore") {
            print("App has launched before")
        } else {
            print("This is the first launch ever!")
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            //preloadData()
            UserDefaults.standard.synchronize()
        }
    }
    
    func preloadData() {
        // Remove previous stuff (if any)
        do {
            try dbStack.dropAllData()
        } catch {
            print("Error droping all objects in DB")
        }
        
        do {
            if let file = Bundle.main.url(forResource: "brahmavidya", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let responseData = try JSONSerialization.jsonObject(with: data, options: [])
                
                let response = responseData as? NSDictionary
                let myAffermations = response?.value(forKey: "allAffermations")  as! [[String:Any]]
                for i in 0 ..< myAffermations.count{
                    
                    _ = Affermations(dictionary: myAffermations[i], context: dbStack.context)
                    dbStack.save()
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
extension NSObject
{
    var appDelegate: AppDelegate!{
        return UIApplication.shared.delegate as! AppDelegate
    }
    var dbStack:CoreDataStack! {
        return appDelegate.stack
    }
}

