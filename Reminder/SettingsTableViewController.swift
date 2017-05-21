//
//  SettingsTableViewController.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 20/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet weak var daysBefore: UITextField!
    @IBOutlet weak var firstReminderTextField: UITextField!
    @IBOutlet weak var secondReminderTextField: UITextField!
    var focusedTextField: UITextField?

    var datePicker: UIDatePicker!
    var date = Date()
    var reminderDate1: Date?
    var reminderDate2: Date?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daysBefore.delegate = self
        firstReminderTextField.delegate = self
        secondReminderTextField.delegate = self
        
        fetchConfigFromDefault()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 14)
    }
    
    func fetchConfigFromDefault(){
        reminderDate1 = defaults.object(forKey:"ReminderDate1") as? Date
        reminderDate2 = defaults.object(forKey:"ReminderDate2") as? Date
        let noOfDays = defaults.object(forKey:"DaysBefore") as? Int
        
        if reminderDate1 != nil {
            firstReminderTextField.text = Helper.getFormatedTime(date: reminderDate1!)
        } else {
            firstReminderTextField.text = "\(Helper.REMINDER_HOUR):\(Helper.REMINDER_MINUTE) AM"
        }
        
        if reminderDate2 != nil {
            secondReminderTextField.text = Helper.getFormatedTime(date: reminderDate2!)
        } else {
            secondReminderTextField.text = "\(Helper.REMINDER_HOUR):\(Helper.REMINDER_MINUTE) AM"
        }
        
        if noOfDays != nil {
            daysBefore.text = "\(noOfDays!)"
        } else {
            daysBefore.text = "\(Helper.REMINDER_BEFORE_NO_OF_DAYS)"
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        if reminderDate1 != nil {
            defaults.set(reminderDate1, forKey: "ReminderDate1")
        }
        
        if reminderDate2 != nil {
            defaults.set(reminderDate2, forKey: "ReminderDate2")
        }
        
        defaults.set(Int(daysBefore.text!), forKey: "DaysBefore")
        
        Helper.showAlertMessage(viewController: self, titleStr: "Success", messageStr: "Your changes saved successfully")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == daysBefore {
            print("daysBefore")
            showNumberKeyBoard(textField: textField)
        } else {
            print("others")
            focusedTextField = textField
            showDatePicker(textField: textField)
        }
    }
    
    func showNumberKeyBoard(textField : UITextField){
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolbar.sizeToFit()
        
        //adding button to toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.numberKeyboardDoneClick))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.numberKeyboardDoneClick))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
    }
    
    func showDatePicker(textField : UITextField){
        //Date picker
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .time
        textField.inputView = datePicker
        datePicker.date = date
        
        if focusedTextField == firstReminderTextField {
            if reminderDate1 != nil {
                datePicker.date = reminderDate1!
            }
        } else if focusedTextField == secondReminderTextField {
            if reminderDate2 != nil {
                datePicker.date = reminderDate2!
            }
        }
        
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolbar.sizeToFit()
        
        //adding button to toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.datePickerDoneClick(textField:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.datePickerCancelClick(textField:)))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
    }
    
    func assignDate(){
        if focusedTextField == firstReminderTextField {
            reminderDate1 = datePicker.date
        } else {
            reminderDate2 = datePicker.date
        }
    }
    
    func numberKeyboardDoneClick() {
        daysBefore.resignFirstResponder()
    }
    
    func datePickerDoneClick(textField:UITextField) {
        date = datePicker.date
        focusedTextField!.text = Helper.getFormatedTime(date: datePicker.date)
        focusedTextField!.resignFirstResponder()
        assignDate()
    }
    
    func datePickerCancelClick(textField:UITextField) {
        focusedTextField!.resignFirstResponder()
    }
    
}
