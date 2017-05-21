//
//  AppDelegate.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 19/4/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit
import Contacts
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var contactStore = CNContactStore()
    lazy var managedObjectContext: NSManagedObjectContext =
        self.persistentContainer.viewContext
    let options: UNAuthorizationOptions = [.alert, .sound, .alert];
    let notificationDelegate = BirthdayNotificationDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabBarController = window!.rootViewController as? UITabBarController
        if let tabBarViewControllers = tabBarController?.viewControllers {
            let navigationController = tabBarViewControllers[0] as? UINavigationController
            
            //navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Futura", size: 20)!]
            
            let birthdayViewController = navigationController?.topViewController as? BirthdaysViewController
            birthdayViewController?.managedObjectContext = managedObjectContext
        }
        
        // Changing the tint colour of the tab bar icons
        UITabBar.appearance().tintColor = Helper.getBorderColor()

        let navigationBarImage: UIImage = UIImage(named: "background")!
        UINavigationBar.appearance().setBackgroundImage(navigationBarImage, for: .default)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let wishAction = UNNotificationAction(identifier: "Wish",
                                              title: "Wish",
                                              options: [UNNotificationActionOptions.foreground])
        let category = UNNotificationCategory(identifier: "ReminderWishCategory",
                                              actions: [wishAction],
                                              intentIdentifiers: [], options: [])
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        center.delegate = notificationDelegate
        center.setNotificationCategories([category])

        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication:sourceApplication, annotation: annotation)
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: {
            storeDescription, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        })
        return container
    }()
    
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
    
    // MARK: Custom functions
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Birthdays", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewController.present(alertController, animated: true, completion: nil)
    }

    func requestForAccess(_ completionHandler:  @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message: message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
}

