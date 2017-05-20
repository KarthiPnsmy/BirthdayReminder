//
//  MyUser.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 1/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import Foundation

class MyUser:NSObject {
    var first_name: String?
    var last_name: String?
    var dob: Date?
    var dob_month: Int = 0
    var dob_date: Int = 0
    var dob_year: Int = 0
    var note: String?
    var image_data: Data?
    var image_file_path: String?
    var import_type: String = ""
}
