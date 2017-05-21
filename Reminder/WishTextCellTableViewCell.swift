//
//  WishTextCellTableViewCell.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 14/5/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit

class WishTextCellTableViewCell: UITableViewCell {

    @IBOutlet weak var textTemplate: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.borderWidth = 0.8
        containerView.layer.borderColor = Helper.getBorderColor().cgColor
        containerView.layer.cornerRadius = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
