//
//  User+CoreDataProperties.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 1/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var dob: Date?
    @NSManaged public var dob_month: Int
    @NSManaged public var dob_date: Int
    @NSManaged public var dob_year: Int
    @NSManaged public var note: String?
    @NSManaged public var image_file_path: String?
    @NSManaged public var import_type: String
    @NSManaged public var photo_id: NSNumber?
    @NSManaged public var notification_id: String?
    

}
