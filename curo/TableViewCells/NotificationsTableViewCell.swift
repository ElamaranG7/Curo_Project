//
//  NotificationsTableViewCell.swift
//  curo
//
//  Created by SAIL on 13/03/24.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    
   
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
