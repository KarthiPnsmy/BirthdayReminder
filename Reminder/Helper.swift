//
//  Helper.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 4/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData
import UserNotifications

class Helper{

    static var monthNames = ["January", "February", "March", "April", "May", "June",
                             "July", "August", "September", "October", "November", "December"
    ];
    
    static let REMINDER_BEFORE_NO_OF_DAYS = 5
    static let REMINDER_HOUR = 08
    static let REMINDER_MINUTE = 30
    let defaults = UserDefaults.standard
    
    static let applicationDocumentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    static func getCurrentYear() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year = components.year
        return year!
    }
    
    static func getComponentFrom(date: Date) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .month, .day], from: date)
    }

    
    static func getDateFromMonthAndDay(month: Int, day: Int, isNextYear: Bool) -> Date {
        var components = DateComponents()
        components.year = getCurrentYear()
        if isNextYear {
            components.year = components.year! + 1
        }
        
        components.month = month
        components.day = day
        components.hour = 8
        components.timeZone = TimeZone(abbreviation: "GMT")
        
        let birthdayDate = Calendar.current.date(from: components)!
        return birthdayDate
    }
    
    static func calcuateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        
        return end - start
    }

    static func getDateStringFromDate(_ date: Date) -> String! {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    static func getNextBirthday(day:Int, month:Int, year:Int) -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        
        components.year = year
        components.month = month
        components.day = day
        components.hour = 8
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(abbreviation: "GMT")

        return gregorian.date(from: components)!
    }
    
    static func getFistReminderDate(birhday:Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: -REMINDER_BEFORE_NO_OF_DAYS, to: birhday)!
    }
    
    
    static func showAlertMessage(viewController: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert);
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
            
        }
        
        alert.addAction(cancelAction)
            viewController.present(alert, animated: true, completion: nil)
        
    }
    
    static func randomString(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    static func getFakeTrigger() -> UNTimeIntervalNotificationTrigger {
        let fakeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        return fakeTrigger
    }
    
    static func updateReminderKeyForUser(_ userObj:User, reminderKey:String, managedObjectContext: NSManagedObjectContext?) {
        
        userObj.notification_id = reminderKey
        
        do {
            try managedObjectContext?.save()
        } catch {
            print(error)
        }
        
        //print("reminderKey \(userObj.notification_id!) saved for \(userObj.first_name!)")
    }
    
    static func getReminder2FireDate(userObj:User) -> Date {
        let dateRangeStart = Date()
        var dateRangeEnd = Helper.getDateFromMonthAndDay(month: userObj.dob_month, day: userObj.dob_date, isNextYear: false)
        
        if dateRangeStart > dateRangeEnd {
            dateRangeEnd = Helper.getDateFromMonthAndDay(month: userObj.dob_month, day: userObj.dob_date, isNextYear: true)
        }
        
        return dateRangeEnd
    }
    
    static func getReminder2TimeFromDefaults() -> (Int, Int) {
        var timing = (hour: Helper.REMINDER_HOUR, minute: Helper.REMINDER_MINUTE)
        let reminderDate2 = UserDefaults.standard.object(forKey:"ReminderDate1") as? Date
        if reminderDate2 != nil {
            let calendar = Calendar.current
            let component = calendar.dateComponents([.hour, .minute], from: reminderDate2!)
            timing.hour = component.hour!
            timing.minute = component.minute!
        }
        return timing
    }
    
    static func getReminder1TimeFromDefaults() -> (Int, Int) {
        var timing = (hour: Helper.REMINDER_HOUR, minute: Helper.REMINDER_MINUTE)
        let reminderDate1 = UserDefaults.standard.object(forKey:"ReminderDate2") as? Date
        if reminderDate1 != nil {
            let calendar = Calendar.current
            let component = calendar.dateComponents([.hour, .minute], from: reminderDate1!)
            timing.hour = component.hour!
            timing.minute = component.minute!
        }
        return timing
    }
    
    
    
    static func getReminder1FireDate(nextBirthDayObj:Date) -> Date {
        var noOfDays = UserDefaults.standard.object(forKey:"DaysBefore") as? Int
        if noOfDays == nil {
            noOfDays = REMINDER_BEFORE_NO_OF_DAYS
        }
        
        return Calendar.current.date(byAdding: .day, value: -noOfDays!, to: nextBirthDayObj)!
    }
    
    static func addReminderNotification(user:User, notificationCenter: UNUserNotificationCenter, managedObjectContext: NSManagedObjectContext?){
        
        var notificationIndenfier = ""
        let reminder2Timing = Helper.getReminder2TimeFromDefaults()
        print("reminder2Timing \(reminder2Timing) ")
        
        let content2 = UNMutableNotificationContent()
        content2.title = "Birthday Reminder"
        content2.body = "Today is your friend \(user.first_name!) \(user.last_name!)'s birthday."
        content2.sound = UNNotificationSound.default()
        content2.categoryIdentifier = "ReminderWishCategory"
        
        let notification2FireDate = Helper.getReminder2FireDate(userObj: user)
        var triggerDate2 = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: notification2FireDate)
        triggerDate2.hour = reminder2Timing.0
        triggerDate2.minute = reminder2Timing.1
        
        
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: triggerDate2, repeats: true)
        let random2 = Helper.randomString(length: 6)
        notificationIndenfier = random2
        
        let request2 = UNNotificationRequest(identifier: random2, content: content2, trigger: Helper.getFakeTrigger())
        notificationCenter.add(request2) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
        let reminder1Timing = Helper.getReminder1TimeFromDefaults()
        print("reminder1Timing \(reminder1Timing) ")
        let content1 = UNMutableNotificationContent()
        content1.title = "Birthday Reminder"
        content1.body = "Your friend \(user.first_name!) \(user.last_name!)'s birthday due in 5 days. Be prepare to surprise him"
        content1.sound = UNNotificationSound.default()
        
        let notification1FireDate = Helper.getReminder1FireDate(nextBirthDayObj: notification2FireDate)
        var triggerDate1 = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: notification1FireDate)
        triggerDate1.hour = reminder1Timing.0
        triggerDate1.minute = reminder1Timing.1
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: triggerDate1, repeats: true)
        
        
        let random1 = Helper.randomString(length: 6)
        let request1 = UNNotificationRequest(identifier: random1, content: content1, trigger: trigger1)
        notificationCenter.add(request1) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
        notificationIndenfier = "\(random1),\(random2)"
        updateReminderKeyForUser(user, reminderKey: notificationIndenfier, managedObjectContext: managedObjectContext)
    }
    
    static func removeScheduledNotificationById(identifiers:[String]){
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            //print("before pending notif count \(requests.count)")
        })
        
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            //print("after pending notif count \(requests.count)")
        })
        
        
        /*
        center.getNotificationCategories(completionHandler: { cats in
            print("notif cat count \(cats.count)")
            
            for cat in cats {
                print("notif cat actions \(cat.actions)")
                print("notif cat identifier \(cat.identifier)")
            }
        }
        )
 
        
         center.getPendingNotificationRequests(completionHandler: { requests in
         print("notif request count \(requests.count)")
         for request in requests {
         print("request.content.body \(request.content.body)")
         
         if identifiers.contains(request.identifier) {
         center.removePendingNotificationRequests(withIdentifiers: identifiers)
         }
         guard let trigger = request.trigger as? UNCalendarNotificationTrigger else {
         print("trigger is not available")
         return
         }
         print(Calendar.current.dateComponents([.year,.day,.month,.hour,.minute,.second], from: trigger.nextTriggerDate()!))
         
         }
         })
  */
        
    }
    
    static func getFormatedTime(date: Date) -> String {
        /*
        let calendar = Calendar.current
        let component = calendar.dateComponents([.hour, .minute], from: date)
        return "\(component.hour!) : \(component.minute!)"
         */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date) //08/10/2016 01:42:22 AM
    }
    
    static func getBorderColor() -> UIColor {
        let borderColor: UIColor = UIColor( red: CGFloat(252/255.0), green: CGFloat(131/255.0), blue: CGFloat(127/255.0), alpha: CGFloat(1.0))
        return borderColor
    }
    
    static func getTextTemplateMessages() -> [String] {
        var textMessages = [String]()
        textMessages.append("Happy Birthday!!! I hope this is the begining of your greatest, most wonderful year ever!")
        textMessages.append("When the world works right, good things happen to and for good people and you are definitely good people. Happy Birthday!")
        textMessages.append("Wishing you a day that is as special in every way as you are. Happy Birthday.")
        textMessages.append("You are my friend. You are always there for me, supporting me, encouraging me , listening to me and all those other things that friends do. Happy Birthday Friend.")
        textMessages.append("May your birthday and every day be filled with the warmth of sunshine, the happiness of smiles, the sounds of laughter, the feeling of love and the sharing of good cheer.")
        textMessages.append("May your birthday be filled with many happy hours and your life with many happy birthdays. HAPPY BIRTHDAY !!")
        textMessages.append("Happy Birthday. I hope that you will have a truly marvelous and joyous day with family and friends.")
        textMessages.append("Wishing you health, love, wealth, happiness and just everything your heart desires. Happy Birthday.")
        textMessages.append("Happy Birthday to a friend who means more to me than chocolate.")
        textMessages.append("Things I like about you: humor, looks, everything. Happy Birthday.")
        textMessages.append("Birthdays are moments to celebrate the year that has gone by and look towards the one ahead with hope and enthusiasm. Wishing you a very happy birthday. ")
        textMessages.append("May every moment of your birthday be the happiest you've ever had — and may your happiness spill over to every other day of the year. ")
        textMessages.append("Happy birthday! It's time for you to have an amazing birthday and savor the joy, love and peace we aim to bring you.")
        textMessages.append("May your special day be packed with all the joy, peace and glory you wish for. Happy birthday.")
        textMessages.append("You're very special — and you should know it. So I will let you how much every second of your special day. Happy birthday.")
        textMessages.append("May your birthday set your life on fire and light up your path to inner joy, well-being and love.")
        return textMessages
    }
}
