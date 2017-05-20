//
//  BirthdayTabelViewCellTableViewCell.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 28/4/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit

class BirthdayTabelViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var diplayImage: UIImageView!
    @IBOutlet weak var checkBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        diplayImage.layer.cornerRadius = diplayImage.frame.size.width/2
        diplayImage.clipsToBounds = true
        
        diplayImage.layer.borderWidth = 3.0;
        diplayImage.layer.borderColor = UIColor.orange.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
