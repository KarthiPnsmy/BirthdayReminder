//
//  BirthdayNotificationDelegate.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 13/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import Foundation
import UserNotifications

class BirthdayNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("userNotificationCenter willPresent")
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter didReceive")
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
            presentSendWishViewController()
        case "Snooze":
            print("Snooze")
        case "Wish":
            print("Wish")
            presentSendWishViewController()
        default:
            print("Unknown action")
        }
        completionHandler()
    }
    
    func presentSendWishViewController(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SendWishView") as! SendWishViewController
        let navController = UINavigationController.init(rootViewController: viewController)
        print("navController \(navController)")
        
        let window:UIWindow? = (UIApplication.shared.delegate?.window)!
        print("window \(window)")

        
        if let rootViewController = window?.rootViewController {
            var currentController = rootViewController
            while let presentedController = currentController.presentedViewController {
                print("#### \(presentedController)")
                currentController = presentedController
            }
            print("currentController \(currentController)")
            currentController.present(navController, animated: true, completion: nil)
        }
 
        
        //performSegueWithIdentifier("sendWish", sender: self)
    }
}
