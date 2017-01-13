//
//  AppDelegate.swift
//  ExpertConnect
//
//  Created by Nadeem on 07/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps
import FBSDKLoginKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var objTabbarMain = TabbarMainVC()
    var selectedCountryCode = String()
    var deviceToken = String()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Google PlacePicker
        GMSPlacesClient.provideAPIKey("AIzaSyCHghGMhFROKnppb6LINQXJdXsXGtMgamo")
        GMSServices.provideAPIKey("AIzaSyCHghGMhFROKnppb6LINQXJdXsXGtMgamo")

        UserDefaults.standard.setValue("com.ExpertConnect.devicetoken", forKey: "com.ExpertConnect.devicetoken")

        registerForPushNotifications(application: application)
        
        //self.window?.rootViewController = LoginWireFrame.setupLoginModule()
        if let font = UIFont(name: "Raleway-Medium", size: 22) {
           // UINavigationBar.appearance().titleTextAttributes = attributes
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.ExpertConnectRed, NSFontAttributeName: font]

        } else {
            // The font "Raleway-SemiBold" is not found
        }
        self.setInitialViewController()
        
        //FeceBook Login
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        FBSDKAppEvents.activateApp()
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
        self.saveContext()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ExpertConnect")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func setInitialViewController() {
        objTabbarMain = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier:"TabbarMainVC") as! UITabBarController as! TabbarMainVC
//        var navigationArray: [UIViewController] = [objTabbarMain.viewControllers]
//        var navigationArray = [objTabbarMain.viewControllers]
//        
//        
//        let nc1 : UIViewController = navigationArray[0]
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.ExpertConnectRed
        navigationBarAppearace.backgroundColor = UIColor.ExpertConnectRed
//        navigationBarAppearace.barTintColor = uicolorFromHex(0x034517)
        UITabBar.appearance().tintColor = UIColor.ExpertConnectRed

        self.window?.rootViewController = objTabbarMain
        self.window?.makeKeyAndVisible()
        
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print(deviceTokenString)
        self.deviceToken = deviceTokenString
        UserDefaults.standard.setValue(self.deviceToken, forKey: "com.ExpertConnect.devicetoken")
        print("deviceToken \(self.deviceToken)")

    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserDefaults.standard.setValue("com.ExpertConnect.devicetoken", forKey: "com.ExpertConnect.devicetoken")
        print("i am not available in simulator \(error)")
        
    }
    
    
    
    /* swift 3 version stack
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet = CharacterSet(charactersIn: "<>")
        let deviceTokenString = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "");
        print(deviceTokenString)
    }
     */
    
    
    /*
    func application(_ application: UIApplication, didRegister notificationSettings: UNNotificationSetting) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    */
    
    
//    // Called when APNs has assigned the device a unique token
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        // Convert token to string
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        
//        // Print it to console
//        print("APNs device token: \(deviceTokenString)")
//        
//        // Persist it in your backend in case it's new
//    }
//    
//    // Called when APNs failed to register the device for push notifications
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        // Print the error to console (you should alert the user that registration failed)
//        print("APNs registration failed: \(error)")
//    }
//    
//    // Push notification received
//    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
//        // Print notification payload data
//        print("Push notification received: \(data)")
//    }
}

