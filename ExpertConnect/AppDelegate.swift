//
//  AppDelegate.swift
//  ExpertConnect
//
//  Created by Nadeem on 07/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import CoreData
import GooglePlacePicker
import GooglePlaces
import GoogleMaps
import FBSDKLoginKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var window: UIWindow?
    var objTabbarMain = TabbarMainVC()
    var selectedCountryCode = String()
    var deviceToken = String()
    
    var locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    var lattitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var cityName : String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.applicationIconBadgeNumber = 0

        let pushNotificationStatus = UserDefaults.standard.value(forKey: "PushNotificationStatus")
        if(pushNotificationStatus == nil) {
            UserDefaults.standard.set(true, forKey: "PushNotificationStatus")
        }
        // Google PlacePicker
        GMSPlacesClient.provideAPIKey("AIzaSyCHghGMhFROKnppb6LINQXJdXsXGtMgamo")
        GMSServices.provideAPIKey("AIzaSyCHghGMhFROKnppb6LINQXJdXsXGtMgamo")
        
        UserDefaults.standard.setValue("com.ExpertConnect.devicetoken", forKey: "com.ExpertConnect.devicetoken")
        registerForPushNotifications(application: application)
        
        if let font = UIFont(name: "Raleway-Medium", size: 22) {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.ExpertConnectRed, NSFontAttributeName: font]
        }
        //Get Current Location
        self.getCurrentLocation()

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
        application.applicationIconBadgeNumber = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.ExpertConnect.UpdateBadgeFromBackground"), object: nil, userInfo:nil)
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
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: LocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lattitude = locValue.latitude
        self.longitude = locValue.longitude
        self.setUsersClosestCity()
        self.locationManager.stopUpdatingLocation()
    }
    
    func setUsersClosestCity()
    {
        let message = "Loading".localized(in: "BrowseExpertsVC")
        //self.displayProgress(message: message)
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.lattitude, longitude: self.longitude)
        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            //self.dismissProgress()
            let placeArray = placemarks as [CLPlacemark]!
            if((placeArray?.count)! > 0) {
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                if placeMark.addressDictionary != nil {
                    // Location name
                    if let locationName = placeMark.addressDictionary?["Name"] as? NSString {
                        print(locationName)
                    }
                    // Street address
                    if let street = placeMark.addressDictionary?["Thoroughfare"] as? NSString {
                        print(street)
                    }
                    // City
                    if let city = placeMark.addressDictionary?["City"] as? NSString {
                        print("City Place : \(city)")
                        self.cityName = city as String
                    }
                    // Zip code
                    if let zip = placeMark.addressDictionary?["ZIP"] as? NSString {
                        print(zip)
                    }
                    // Country
                    if let country = placeMark.addressDictionary?["Country"] as? NSString {
                        print(country)
                    }
                }
            }
        }
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
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.ExpertConnectRed
        navigationBarAppearace.backgroundColor = UIColor.ExpertConnectRed
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
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        application.applicationIconBadgeNumber = 0

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.ExpertConnect.UpdateBadgeFromBackground"), object: nil, userInfo:nil)
       /* if let aps = data["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let type = alert["notification_type"] as? NSString {
                   
                    if(type == "request") {
                        let tabArray = self.objTabbarMain.tabBar.items as NSArray!
                        let browseEnquiryTabItem = tabArray?.object(at: 2) as! UITabBarItem
                        if let badgeValue = browseEnquiryTabItem.badgeValue {
                            browseEnquiryTabItem.badgeValue = String((Int(badgeValue) ?? 0) + 1)
                        } else {
                            browseEnquiryTabItem.badgeValue = "1"
                        }
                    } else if(type == "accept") {
                        let tabArray = self.objTabbarMain.tabBar.items as NSArray!
                        let myAssignmentTabItem = tabArray?.object(at: 1) as! UITabBarItem
                        if let badgeValue = myAssignmentTabItem.badgeValue {
                            myAssignmentTabItem.badgeValue = String((Int(badgeValue) ?? 0) + 1)
                        } else {
                            myAssignmentTabItem.badgeValue = "1"
                        }
                    } else if(type == "confirm") {
                        let tabArray = self.objTabbarMain.tabBar.items as NSArray!
                        let myAssignmentTabItem = tabArray?.object(at: 1) as! UITabBarItem
                        if let badgeValue = myAssignmentTabItem.badgeValue {
                            myAssignmentTabItem.badgeValue = String((Int(badgeValue) ?? 0) + 1)
                        } else {
                            myAssignmentTabItem.badgeValue = "1"
                        }
                    }
                }
            }
        }*/
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

