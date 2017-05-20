//
//  UserDetailViewController.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 6/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class UserDetailViewController: UIViewController, UITextFieldDelegate {

    var managedObjectContext: NSManagedObjectContext?
    var userBirthdayToEdit: User?
    var isEditMode: Bool = false
    var isNewMode: Bool = false
    var datePicker: UIDatePicker!
    var image: UIImage?
    var date = Date()
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var imageEditHintLabel: UILabel!
    @IBOutlet weak var EditViewContainer: UIStackView!
    @IBOutlet weak var DisplayViewCOntainer: UIStackView!
    
    //display view
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDobLabel: UILabel!
    @IBOutlet weak var sendWishButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    //edit view
    @IBOutlet weak var firstNameEditBox: UITextField!
    @IBOutlet weak var lastNameEditBox: UITextField!
    @IBOutlet weak var birthdayEditBox: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameEditBox.delegate = self
        self.lastNameEditBox.delegate = self
        self.birthdayEditBox.delegate = self
        
        if isNewMode {
            self.title = "New"
            self.navigationItem.rightBarButtonItem?.title = ""
            self.birthdayEditBox.text = Helper.getDateStringFromDate(date)
        }
        setRoundImage()
        toggleView()
        loadUserDetailToView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRoundImage(){
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        
        userImage.layer.borderWidth = 3.0;
        userImage.layer.borderColor = UIColor.orange.cgColor
        /*
        //send wish button
        sendWishButton.layer.borderWidth = 0.8
        sendWishButton.layer.borderColor = UIColor.orange.cgColor
        sendWishButton.layer.cornerRadius = 4.0
        
        //delete button
        deleteButton.layer.borderWidth = 0.8
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.layer.cornerRadius = 4.0
        
        //save wish button
        saveButton.layer.borderWidth = 0.8
        saveButton.layer.borderColor = UIColor.orange.cgColor
        saveButton.layer.cornerRadius = 4.0
         */
    }
    
    func loadUserDetailToView(){
        
        if let user = userBirthdayToEdit {
            self.title = user.first_name!
            userNameLabel.text = "\(user.first_name!) \(user.last_name!)"
            userDobLabel.text = Helper.getDateStringFromDate(user.dob!)
            date = user.dob!
            if user.hasPhoto {
                userImage.image = user.photoImage
            }
            
            firstNameEditBox.text = user.first_name!
            lastNameEditBox.text = user.last_name!
            birthdayEditBox.text = Helper.getDateStringFromDate(user.dob!)
        }
    }
    
    func toggleView(){
        if isEditMode || isNewMode {
            DisplayViewCOntainer.isHidden = true
            EditViewContainer.isHidden = false
            imageEditHintLabel.isHidden = false
            addGestureToImageView()
        } else {
            EditViewContainer.isHidden = true
            imageEditHintLabel.isHidden = true
            DisplayViewCOntainer.isHidden = false
        }
    }
    
    func addGestureToImageView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserDetailViewController.pickPhoto))
        userImage.addGestureRecognizer(tap)
        userImage.isUserInteractionEnabled = true
    }
    
    func showDatePicker(textField : UITextField){
        //Date picker
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        textField.inputView = datePicker
        datePicker.date = date
 
        
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolbar.sizeToFit()
        
        //adding button to toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(UserDetailViewController.datePickerDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(UserDetailViewController.datePickerCancelClick))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
        
    }
    
    func datePickerDoneClick() {
        date = datePicker.date
        birthdayEditBox.text = Helper.getDateStringFromDate(datePicker.date)
        birthdayEditBox.resignFirstResponder()
    }
    
    func datePickerCancelClick() {
        birthdayEditBox.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == birthdayEditBox {
            scrollView.setContentOffset(CGPoint(x:0, y:40), animated: true)
            showDatePicker(textField: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == birthdayEditBox {
            scrollView.setContentOffset(CGPoint(x:0, y:-40), animated: true)
        }
    }
    
    @IBAction func showEdit(_ sender: UIBarButtonItem) {
        isEditMode = true
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        toggleView()
    }
    
    @IBAction func sendWish(_ sender: UIButton) {
        
    }

    @IBAction func deleteUser(_ sender: UIButton) {
        
        let confirmAlert = UIAlertController(title: "Delete Birthday", message: "Are you sure want to delete?", preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: .destructive) { (UIAlertAction) in
            
            if self.userBirthdayToEdit != nil {
                self.managedObjectContext?.delete(self.userBirthdayToEdit!)
                
                do {
                    try self.managedObjectContext?.save()
                } catch {
                    Helper.showAlertMessage(viewController: self, titleStr: "Error", messageStr: error as! String)
                }
                self.performSegue(withIdentifier: "unwindFromDetailConroller", sender: sender)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            
        }
        
        confirmAlert.addAction(cancelAction)
        confirmAlert.addAction(okAction)
        present(confirmAlert, animated: true, completion: nil)
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        if (firstNameEditBox.text?.isEmpty)! {
            Helper.showAlertMessage(viewController: self, titleStr: "Error", messageStr: "Please fill first name")
            return
        }
        
        if (lastNameEditBox.text?.isEmpty)! {
            Helper.showAlertMessage(viewController: self, titleStr: "Error", messageStr: "Please fill last name")
            return
        }
        
        let user:User
        if let temp = userBirthdayToEdit {
            user = temp
            user.deleteReminder()
        } else {
            user = User(context: managedObjectContext!)
            user.import_type = "MANUAL"
        }
        
        user.first_name = firstNameEditBox.text
        user.last_name = lastNameEditBox.text
        user.dob = date
        user.dob_date = Helper.getComponentFrom(date: date).day!
        user.dob_month = Helper.getComponentFrom(date: date).month!
        user.dob_year = Helper.getComponentFrom(date: date).year!
        
        if let image = image {
            if !user.hasPhoto {
                user.photo_id = User.nextPhotoID() as NSNumber
            }
            
            if let data = UIImageJPEGRepresentation(image, 0.5) {
                do {
                    try data.write(to: user.photoURL, options: .atomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        
        do {
            try managedObjectContext?.save()
            Helper.addReminderNotification(user: user, notificationCenter: UNUserNotificationCenter.current(), managedObjectContext: managedObjectContext)
        } catch {
            print(error)
        }
        performSegue(withIdentifier: "unwindFromDetailConroller", sender: sender)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserDetailViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {_ in self.takePhotoWithCamera()})
        alertController.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title:"Choose From Library", style: .default, handler: {_ in self.choosePhotoFromLibrary()})
        alertController.addAction(chooseFromLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func show(image: UIImage){
        userImage.image = image
    }
}
