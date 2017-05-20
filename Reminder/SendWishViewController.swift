//
//  SendWishViewController.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 14/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit

class SendWishViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var textTableView: UITableView!
    @IBOutlet weak var imageTableView: UITableView!
    
    var textMessages = [String]()
    var pictureMessages = [UIImage]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageTableView.isHidden = true
        textMessages = Helper.getTextTemplateMessages()
        
        pictureMessages.append(UIImage(named: "birthday1")!)
        pictureMessages.append(UIImage(named: "birthday2")!)
        pictureMessages.append(UIImage(named: "birthday4")!)
        pictureMessages.append(UIImage(named: "birthday5")!)

        textTableView.dataSource = self
        textTableView.estimatedRowHeight = 110
        textTableView.rowHeight = UITableViewAutomaticDimension
        
        imageTableView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
             dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            imageTableView.isHidden = true
            textTableView.isHidden = false
        case 1:
            print("Second Segment Selected")
            textTableView.isHidden = true
            imageTableView.isHidden = false
        default:
            break
        }
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

extension SendWishViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == imageTableView {
            return pictureMessages.count
        }
        return textMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == imageTableView {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "PictureTemplate", for: indexPath) as! WishPictureTableViewCell
            cell.pictureView.image = pictureMessages[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TextTemplate", for: indexPath) as! WishTextCellTableViewCell
        cell.textTemplate.text = textMessages[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension SendWishViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController)
        -> UIPresentationController? {
            return DimmingPresentationController(
                presentedViewController: presented, presenting: presenting)
    }
}
