//
//  User+CoreDataClass.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 1/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    var daysLeftForNextBirthday: Int? {
        let dateRangeStart = Date()
        var dateRangeEnd = Helper.getDateFromMonthAndDay(month: dob_month, day: dob_date, isNextYear: false)
        
        if dateRangeStart > dateRangeEnd {
            dateRangeEnd = Helper.getDateFromMonthAndDay(month: dob_month, day: dob_date, isNextYear: true)
        }
        return Helper.calcuateDaysBetweenTwoDates(start:dateRangeStart, end: dateRangeEnd)
    }
    
    var headMonthVal: String? {
        return Helper.monthNames[dob_month - 1]
    }
    
    var hasPhoto: Bool {
        return photo_id != nil
    }
    
    var photoURL: URL {
        assert(photo_id != nil, "No photo ID set")
        let filename = "Photo-\(photo_id!.intValue).jpg"
        return Helper.applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID")
        userDefaults.set(currentID + 1, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
    
    func deletePhotoFile() {
        if hasPhoto {
            do {
                try FileManager.default.removeItem(at: photoURL)
            } catch {
                print("Error removing file: \(error)")
            }
        }
    }
    
    func deleteReminder() {
        print("going to delete reminder for >> \(getNotificationId())")
        Helper.removeScheduledNotificationById(identifiers: getNotificationId())
    }

    func getNotificationId() -> [String]{
        var ids = [String]()
        if let nId = notification_id {
            ids = nId.components(separatedBy: ",")
        }
        return ids
    }
}
