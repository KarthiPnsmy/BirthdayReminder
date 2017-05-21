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
        
        textTableView.separatorStyle = .none
        imageTableView.separatorStyle = .none
        self.navigationItem.rightBarButtonItem?.title = ""

        segmentControl.tintColor = Helper.getBorderColor()
        imageTableView.isHidden = true
        textMessages = Helper.getTextTemplateMessages()
        
        pictureMessages.append(UIImage(named: "birthday6")!)
        pictureMessages.append(UIImage(named: "birthday1")!)
        pictureMessages.append(UIImage(named: "birthday2")!)
        pictureMessages.append(UIImage(named: "birthday4")!)
        pictureMessages.append(UIImage(named: "birthday5")!)
        pictureMessages.append(UIImage(named: "birthday7")!)
        pictureMessages.append(UIImage(named: "birthday8")!)
        pictureMessages.append(UIImage(named: "birthday9")!)
        pictureMessages.append(UIImage(named: "birthday11")!)
        pictureMessages.append(UIImage(named: "birthday10")!)

        textTableView.dataSource = self
        textTableView.estimatedRowHeight = 110
        textTableView.rowHeight = UITableViewAutomaticDimension
        
        imageTableView.dataSource = self
        textTableView.delegate = self
        imageTableView.delegate = self

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
    

    func shareItem(itmeToShare: Any){
        let activityViewController = UIActivityViewController(activityItems: [itmeToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

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

extension SendWishViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == textTableView {
            print("selected text index = \(textMessages[indexPath.row])")
            shareItem(itmeToShare: textMessages[indexPath.row])
        } else {
            print("selected pic index = \(pictureMessages[indexPath.row])")
            shareItem(itmeToShare: pictureMessages[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
