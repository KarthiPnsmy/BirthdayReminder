//
//  BirthdaysViewController.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 24/4/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit
import Contacts
import CoreData
import UserNotifications

class BirthdaysViewController: UIViewController {
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [User]!
    }
    
    var objectArray = [Objects]()
    @IBOutlet weak var birthdayTabelView: UITableView!
    var managedObjectContext: NSManagedObjectContext?
    var users = [User] ()
    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdayTabelView.dataSource = self
        birthdayTabelView.delegate = self
        
        birthdayTabelView.estimatedRowHeight = 100
        birthdayTabelView.rowHeight = UITableViewAutomaticDimension
        
        print("database path => \(applicationDocumentsDirectory)")
        
        loadBirthdayFromDB()
    }
    
    
    let applicationDocumentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadBirthdayFromDB(){
        objectArray = [Objects]()
        let fetchRequest = NSFetchRequest<User>()
        let entity = User.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor1 = NSSortDescriptor(key: "dob_month", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "dob_date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            if managedObjectContext != nil {
                users = try managedObjectContext!.fetch(fetchRequest)
                print("count of DB users \(users.count)")
            }
        } catch {
            print(error)
        }
        
        if users.count > 0 {
            users.sort(by: { $0.daysLeftForNextBirthday! < $1.daysLeftForNextBirthday! })
        }
        
        var prevHeader = ""
        var userObjects = [User] ()

        for user in users {
            if prevHeader == "" {
                //print("adding to userObjects --> \(user.first_name!) \(user.headMonthVal!)")
                userObjects.append(user)
            } else {
                if prevHeader == user.headMonthVal {
                    //print("adding to userObjects --> \(user.first_name!) \(user.headMonthVal!)")
                    userObjects.append(user)
                } else {
                    //print("month wrapping objectArray--> \(userObjects.count) \(prevHeader)")
                    objectArray.append(Objects(sectionName: prevHeader, sectionObjects: userObjects))
                    userObjects = [User] ()
                    //print("adding to userObjects --> \(user.first_name!) \(user.headMonthVal!)")
                    userObjects.append(user)
                }
            }
            
            prevHeader = user.headMonthVal!
        }
            
        objectArray.append(Objects(sectionName: prevHeader, sectionObjects: userObjects))
        birthdayTabelView.reloadData()
    }

    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        showActionSheetForAddBirthday()
    }
    
    
    func showActionSheetForAddBirthday(){
        let actionSheet = UIAlertController(title: nil, message: "Import birthdays from", preferredStyle: .actionSheet)
        
        let contactAction = UIAlertAction(title: "Contact", style: .default) { (alert: UIAlertAction) in
            self.performSegue(withIdentifier: "import", sender: self)
        }
        
        let manualAction = UIAlertAction(title: "Manual", style: .default) { (UIAlertAction) in
            self.performSegue(withIdentifier: "addNewUser", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in

        }
        
        actionSheet.addAction(contactAction)
        //actionSheet.addAction(calenderAction)
        actionSheet.addAction(manualAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "import" {
            let importTabelViewController = segue.destination as? ImportTableViewController
            importTabelViewController?.managedObjectContext = managedObjectContext
        } else if segue.identifier == "showUserDetail" {
            let userDetailViewController = segue.destination as? UserDetailViewController
            userDetailViewController?.managedObjectContext = managedObjectContext
            userDetailViewController?.userBirthdayToEdit = selectedUser
        } else if segue.identifier == "addNewUser" {
            let userDetailViewController = segue.destination as? UserDetailViewController
            userDetailViewController?.managedObjectContext = managedObjectContext
            userDetailViewController?.isNewMode = true
        }
    }
}

extension BirthdaysViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = objectArray[indexPath.section].sectionObjects[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayCell") as! BirthdayTabelViewCell
        
        configureCell(for: user, cell: cell)
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName.uppercased()
    }
    
}

extension BirthdaysViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = objectArray[indexPath.section].sectionObjects[indexPath.row]
        self.performSegue(withIdentifier: "showUserDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension BirthdaysViewController {
    @IBAction func unwindToBirthdayViewController(segue: UIStoryboardSegue) {
        self.loadBirthdayFromDB()
    }
    
    func configureCell(for user: User, cell:BirthdayTabelViewCell) {
        cell.nameLabel.text = "\(user.first_name!) \(user.last_name!)"
        if let nextBirthday = user.daysLeftForNextBirthday {
            cell.dobLabel.text = "\(nextBirthday) days left"
        }
        
        if user.hasPhoto {
            if let theImage = user.photoImage {
                cell.diplayImage.image = theImage
            }
        } else {
            let defaultImage = UIImage(named: "default_image")
            cell.diplayImage.image = defaultImage
        }
        
        cell.checkBox.isHidden = true
    }
}



