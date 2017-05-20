//
//  DimmingPresentationController.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 18/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit
class DimmingPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false
    }
}
